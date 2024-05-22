import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/seller/seller_complains_screen.dart';
import 'package:shop_app/screens/seller/seller_orders_screen.dart';
import 'package:shop_app/screens/seller/seller_product_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class InitSellerScreen extends StatefulWidget {
  static String routeName = "/init-seller";

  @override
  State<InitSellerScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitSellerScreen> {
  int currentSelectedIndex = 0;

  void updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
  }

  final pages = [
    SellerProductScreen(), // New: Seller Product Screen
    SellerOrderScreen(), // New: Seller Order Screen
    SellerComplaintsScreen(), // New: Seller Complaints Screen
    ProfileScreen(), // Profile screen remains the same
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: updateCurrentIndex,
        currentIndex: currentSelectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shop_outlined, // New: Seller product icon
              color: inActiveIconColor,
            ),
            activeIcon: Icon(
              Icons.shop,
              color: kPrimaryColor,
            ),
            label: "Products",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_bag_outlined, // New: Seller orders icon
              color: inActiveIconColor,
            ),
            activeIcon: Icon(
              Icons.shopping_bag,
              color: kPrimaryColor,
            ),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.warning_amber_outlined, // New: Seller complaints icon
              color: inActiveIconColor,
            ),
            activeIcon: Icon(
              Icons.warning_amber,
              color: kPrimaryColor,
            ),
            label: "Complaints",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              color: inActiveIconColor,
            ),
            activeIcon: Icon(
              Icons.person,
              color: kPrimaryColor,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
