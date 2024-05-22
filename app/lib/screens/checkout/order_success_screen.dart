import 'package:flutter/material.dart';
import 'package:shop_app/screens/init_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  static String routeName = "/order_success";

  const OrderSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text("Order Success"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 16),
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  "Your order has been successfully placed!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, InitScreen.routeName);
                },
                child: const Text("Back to home"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
