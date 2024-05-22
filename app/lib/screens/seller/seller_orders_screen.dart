import 'package:flutter/material.dart';

class SellerOrderScreen extends StatelessWidget {
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
                // Filter or sort orders
              },
              child: Text('Filter/Sort Orders'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with actual order count
                itemBuilder: (context, index) {
                  // Replace with order item widget
                  return ListTile(
                    title: Text('Order ${index + 1}'),
                    subtitle: Text('Order details...'), // Add order details
                    trailing: IconButton(
                      icon: Icon(Icons.assignment_turned_in),
                      onPressed: () {
                        // Mark order as completed
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
