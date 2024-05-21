import 'package:flutter/material.dart';
import '../../cart/cart_screen.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';
import 'package:shop_app/services/cart_servies.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  int numOfItems = 0;
  final CartService _cartService =
      CartService(); // Create a single instance of CartService

  @override
  void initState() {
    super.initState();
    // Initial loading of cart items count
    _updateCartItemsCount();

    // Register a listener to update cart items count when cart changes
    _cartService.cartChangeListener = _updateCartItemsCount;
  }

  // Function to update the cart items count
  void _updateCartItemsCount() async {
    final cartItems = await _cartService
        .getCartItems(); // Use the same instance of CartService
    setState(() {
      numOfItems = cartItems.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: SearchField()),
          SizedBox(width: 16),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Cart Icon.svg",
            press: () => Navigator.pushNamed(context, CartScreen.routeName),
            numOfitem: numOfItems,
          ),
          SizedBox(width: 8),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Bell.svg",
            numOfitem:
                3, // You can replace this with the actual number of notifications
            press: () {},
          ),
        ],
      ),
    );
  }
}
