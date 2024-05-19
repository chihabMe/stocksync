import 'package:flutter/material.dart';
import 'package:shop_app/screens/home/components/categories.dart';
import 'package:shop_app/screens/home/components/discount_banner.dart';
import 'package:shop_app/screens/home/components/home_header.dart';
import 'package:shop_app/screens/home/components/new_products.dart';
import 'package:shop_app/screens/home/components/special_offers.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              HomeHeader(),
              Categories(),
              SpecialOffers(),
              SizedBox(height: 20),
              NewProducts(),
              DiscountBanner(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
