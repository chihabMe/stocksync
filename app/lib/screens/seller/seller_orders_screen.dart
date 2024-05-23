import 'package:flutter/material.dart';
import 'package:shop_app/models/Order.dart';
import 'package:shop_app/services/order_servies.dart'; // Import Order model and services

class SellerOrderScreen extends StatefulWidget {
  @override
  _SellerOrderScreenState createState() => _SellerOrderScreenState();
}

class _SellerOrderScreenState extends State<SellerOrderScreen> {
  final OrderServices _orderServices =
      OrderServices(); // Initialize OrderServices

  // Method to fetch seller orders
  Future<List<Order>> _fetchOrders() async {
    try {
      // Fetch orders using OrderServices
      List<Order> orders = await _orderServices.getSellerOrders();
      return orders;
    } catch (error) {
      // Handle error
      print('Error fetching orders: $error');
      // Throw error to be caught by FutureBuilder
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
                future: _fetchOrders(), // Call the method to fetch orders
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show loading indicator while fetching orders
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Show error message if fetching orders fails
                    return Center(
                      child: Text(
                          'Failed to fetch orders. Please try again later.'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // Show message if no orders are found
                    return Center(child: Text('No orders found.'));
                  } else {
                    // Display orders in a ListView if data is fetched successfully
                    List<Order> orders = snapshot.data!;
                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final Order order = orders[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title:
                                Text('Order ${order.id}'), // Display order ID
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
                                    .split(' ')[0]), // Format date
                                Text(
                                    'Items: ${order.items.length}'), // Number of items
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.assignment_turned_in),
                              onPressed: () {
                                // Implement functionality to mark order as completed
                                _markOrderCompleted(order.id);
                              },
                            ),
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

  // Method to mark order as completed
  Future<void> _markOrderCompleted(String orderId) async {
    try {
      // Implement logic to update order status using OrderServices
      bool success =
          await _orderServices.updateOrderStatus(orderId, 'completed');
      if (success) {
        // If order status updated successfully, fetch orders again to reflect changes
        setState(() {
          _fetchOrders();
        });
        // Show success message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order marked as completed')),
        );
      } else {
        // Show error message if order status update fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to mark order as completed')),
        );
      }
    } catch (error) {
      // Handle error
      print('Error marking order as completed: $error');
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Failed to mark order as completed. Please try again later.')),
      );
    }
  }
}
