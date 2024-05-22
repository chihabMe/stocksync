import 'package:flutter/material.dart';
import 'package:shop_app/models/Order.dart';
import 'package:shop_app/services/order_servies.dart';

class ProfileOrdersScreen extends StatelessWidget {
  static String routeName = "/profile_orders";

  final OrderServices orderServices = OrderServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: FutureBuilder<List<Order>>(
        future: orderServices.getOrdersList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Order order = snapshot.data![index];
                return OrderCard(order: order);
              },
            );
          }
        },
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  final Order order;

  const OrderCard({required this.order});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  String buttonText = 'Cancel Order';
  bool isButtonEnabled = true;
  late String orderStatus;

  @override
  void initState() {
    super.initState();
    orderStatus = widget.order.status;
    if (orderStatus != 'pending') {
      isButtonEnabled = false;
    }
  }

  void _cancelOrder() {
    OrderServices().cancelOrder(widget.order.id).then((success) {
      if (success) {
        setState(() {
          buttonText = 'Order Cancelled';
          isButtonEnabled = false;
          orderStatus = 'cancelled'; // Update the order status locally
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order cancelled successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to cancel order')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${widget.order.id}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Total: \$${widget.order.total.toStringAsFixed(2)}'),
            SizedBox(height: 10),
            Text('Status: $orderStatus'),
            SizedBox(height: 10),
            Text('Date: ${widget.order.date}'),
            SizedBox(height: 10),
            Text(
              'Items:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.order.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    '${item.quantity} x ${item.product.name}',
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 10), // Add space above the button
            ElevatedButton(
              onPressed: isButtonEnabled ? _cancelOrder : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    vertical: 5, horizontal: 10), // Adjust button padding
                textStyle: TextStyle(fontSize: 14), // Set button text size
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
