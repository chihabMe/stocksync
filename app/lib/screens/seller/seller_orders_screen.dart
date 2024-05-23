import 'package:flutter/material.dart';
import 'package:shop_app/models/Order.dart';
import 'package:shop_app/services/order_servies.dart';

class SellerOrderScreen extends StatefulWidget {
  @override
  _SellerOrderScreenState createState() => _SellerOrderScreenState();
}

class _SellerOrderScreenState extends State<SellerOrderScreen> {
  final OrderServices _orderServices = OrderServices();

  Future<List<Order>> _fetchOrders() async {
    try {
      List<Order> orders = await _orderServices.getSellerOrders();
      return orders;
    } catch (error) {
      print('Error fetching orders: $error');
      throw Exception('Failed to fetch orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Implement filter/sort functionality
              },
              child: Text('Filter/Sort Orders'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Order>>(
                future: _fetchOrders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          'Failed to fetch orders. Please try again later.'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No orders found.'));
                  } else {
                    List<Order> orders = snapshot.data!;
                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final Order order = orders[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ListTile(
                                title: Text('Order ${order.id}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Name: ${order.firstName} ${order.lastName}'),
                                    Text('Phone: ${order.phone}'),
                                    Text('City: ${order.city}'),
                                    Text('Address: ${order.address}'),
                                    Text('State: ${order.state}'),
                                    Text('Status: ${order.status}'),
                                    Text(
                                        'Total: \$${order.total.toStringAsFixed(2)}'),
                                    Text('Date: ${order.date.toLocal()}'
                                        .split(' ')[0]),
                                    Text('Items: ${order.items.length}'),
                                  ],
                                ),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _acceptOrder(order.id);
                                    },
                                    icon: Icon(Icons.check_circle),
                                    iconSize: 24,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _markOrderCompleted(order.id);
                                    },
                                    icon: Icon(Icons.assignment_turned_in),
                                    iconSize: 24,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _markOrderCompleted(String orderId) async {
    try {
      bool success =
          await _orderServices.updateOrderStatus(orderId, 'completed');
      if (success) {
        setState(() {
          _fetchOrders();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order marked as completed')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to mark order as completed')),
        );
      }
    } catch (error) {
      print('Error marking order as completed: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to mark order as completed. Please try again later.',
          ),
        ),
      );
    }
  }

  Future<void> _acceptOrder(String orderId) async {
    try {
      bool success = await _orderServices.acceptOrder(orderId);
      if (success) {
        setState(() {
          _fetchOrders();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order accepted')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to accept order')),
        );
      }
    } catch (error) {
      print('Error accepting order: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to accept order. Please try again later.',
          ),
        ),
      );
    }
  }
}
