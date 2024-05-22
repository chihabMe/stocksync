import 'package:flutter/material.dart';

class SellerComplaintsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Complaints'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Filter or sort complaints
              },
              child: Text('Filter/Sort Complaints'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with actual complaint count
                itemBuilder: (context, index) {
                  // Replace with complaint item widget
                  return ListTile(
                    title: Text('Complaint ${index + 1}'),
                    subtitle:
                        Text('Complaint details...'), // Add complaint details
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: () {
                        // Resolve complaint
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
