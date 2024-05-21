import 'package:flutter/material.dart';
import 'package:shop_app/models/CartItem.dart';
import 'package:shop_app/services/cart_servies.dart';

class CartCard extends StatefulWidget {
  final CartItem cartItem;
  final VoidCallback onQuantityChanged;

  const CartCard({
    Key? key,
    required this.cartItem,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  late int quantity;
  final CartService _cartService = CartService();

  @override
  void initState() {
    super.initState();
    quantity = widget.cartItem.quantity;
  }

  void _updateQuantity(int newQuantity) async {
    if (newQuantity > 0) {
      await _cartService.updateQuantity(widget.cartItem.product, newQuantity);
      setState(() {
        quantity = newQuantity;
      });
    } else {
      await _cartService.removeFromCart(widget.cartItem.product);
    }
    widget.onQuantityChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(widget.cartItem.product.images.first),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.cartItem.product.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '\$${widget.cartItem.product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        _updateQuantity(quantity - 1);
                      },
                    ),
                    Text(
                      '$quantity',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        _updateQuantity(quantity + 1);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
