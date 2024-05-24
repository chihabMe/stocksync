import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/models/CartItem.dart';
import 'package:shop_app/screens/cart/components/cart_card.dart';
import 'package:shop_app/screens/cart/components/check_out_card.dart';
import 'package:shop_app/screens/checkout/checkout_screen.dart';
import 'package:shop_app/services/cart_servies.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";

  CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  double total = 0;
  String couponCode = "";
  double discountPercentage = 0;

  Future<void> _refreshCart() async {
    List<CartItem> cartItems = await _cartService.getCartItems();
    setState(() {
      total = cartItems.fold(
          0.0, (sum, item) => sum + item.product.price * item.quantity);
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshCart();
  }

  Future<void> _applyCoupon() async {
    try {
      // Send the coupon code to your backend to validate and calculate the discount
      Map<String, dynamic> couponResult =
          await _cartService.applyCoupon(couponCode);
      if (couponResult['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Coupon applied successfully')),
        );
        setState(() {
          discountPercentage =
              (couponResult['discount_percentage'] as int).toDouble();
        });
        await _refreshCart();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid coupon code')),
        );
        setState(() {
          discountPercentage = 0;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to apply coupon: $error')),
      );
    }
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
                    style: Theme.of(context).textTheme.bodyText1,
                  );
                } else {
                  return Text(
                    "${snapshot.data!.length} items",
                    style: Theme.of(context).textTheme.bodyText1,
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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            onChanged: (value) {
              couponCode = value;
            },
            decoration: InputDecoration(
              labelText: 'Enter coupon code',
              suffixIcon: IconButton(
                onPressed: _applyCoupon, // Apply the coupon when pressed
                icon: Icon(Icons.check),
              ),
            ),
          ),
          CheckoutCard(
            totalAmount: total,
            discountAmount: total * (discountPercentage / 100),
          ),
        ],
      ),
    );
  }
}

class CheckoutCard extends StatelessWidget {
  final double totalAmount;
  final double discountAmount; // Add discountAmount

  const CheckoutCard({
    Key? key,
    required this.totalAmount,
    this.discountAmount = 0.0, // Initialize discountAmount with 0.0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double finalAmount =
        totalAmount - discountAmount; // Calculate the final amount
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total:",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "\$$finalAmount", // Display the final amount
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, CheckoutScreen.routeName);
              },
              child: Text("Check Out"),
            ),
          ],
        ),
      ),
    );
  }
}
