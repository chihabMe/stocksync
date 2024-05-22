import 'package:flutter/material.dart';
import 'package:shop_app/screens/checkout/components/shipping_form.dart';

class CheckoutScreen extends StatelessWidget {
  static String routeName = "/checkout";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Shipping Information",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const ShippingInfoForm(),
            ],
          ),
        ),
      ),
    );
  }
}
