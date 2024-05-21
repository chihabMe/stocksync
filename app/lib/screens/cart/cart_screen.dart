import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/models/CartItem.dart';
import 'package:shop_app/services/cart_servies.dart';

import 'components/cart_card.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  double total = 0;

  Future<void> _refreshCart() async {
    List<CartItem> cartItems = await _cartService.getCartItems();
    setState(() {
      total = cartItems.fold(
          0, (sum, item) => sum + item.product.price * item.quantity);
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              "Your Cart",
              style: TextStyle(color: Colors.black),
            ),
            FutureBuilder<List<CartItem>>(
              future: _cartService.getCartItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                } else if (snapshot.hasError) {
                  return Text(
                    "Error: ${snapshot.error}",
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                } else {
                  return Text(
                    "${snapshot.data!.length} items",
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder<List<CartItem>>(
          future: _cartService.getCartItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              List<CartItem> cartItems = snapshot.data!;
              return ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Dismissible(
                    key: Key(cartItems[index].product.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) async {
                      await _cartService
                          .removeFromCart(cartItems[index].product);
                      setState(() {
                        cartItems.removeAt(index);
                        total = cartItems.fold(
                            0,
                            (sum, item) =>
                                sum + item.product.price * item.quantity);
                      });
                    },
                    background: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE6E6),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const Spacer(),
                          SvgPicture.asset("assets/icons/Trash.svg"),
                        ],
                      ),
                    ),
                    child: CartCard(
                      cartItem: cartItems[index],
                      onQuantityChanged: _refreshCart,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: CheckoutCard(totalAmount: total),
    );
  }
}
