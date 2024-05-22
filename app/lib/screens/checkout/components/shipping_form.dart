import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/components/custom_text_form.dart';
import 'package:shop_app/models/CartItem.dart';
import 'package:shop_app/screens/checkout/order_success_screen.dart';
import 'package:shop_app/services/cart_servies.dart';
import 'package:shop_app/services/order_servies.dart';

class ShippingInfoForm extends StatefulWidget {
  const ShippingInfoForm({Key? key}) : super(key: key);

  @override
  _ShippingInfoFormState createState() => _ShippingInfoFormState();
}

class _ShippingInfoFormState extends State<ShippingInfoForm> {
  final _formKey = GlobalKey<FormState>();
  String? firstName;
  String? lastName;
  String? phone;
  String? address;
  String? city;
  String? state;
  String? zipCode;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  Future<void> _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      List<CartItem> cartItems = await CartService().getCartItems();

      List<Map<String, dynamic>> items = cartItems.map((item) {
        return {
          "product_id": item.product.id,
          "quantity": item.quantity,
        };
      }).toList();

      Map<String, dynamic> orderData = {
        "items": items,
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "city": city,
        "state": state,
        "address": address,
        "zip_code": zipCode,
      };

      // Call the OrderService to handle the order submission
      bool success = await OrderServices().submitOrder(orderData);
      if (success) {
        // Navigate to a success screen or show a success message
        await CartService().clearCart();
        Navigator.of(context).pushNamed(OrderSuccessScreen.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextFormField(
            label: "First Name",
            onSaved: (value) => firstName = value,
          ),
          SizedBox(height: 15),
          CustomTextFormField(
            label: "Last Name",
            onSaved: (value) => lastName = value,
          ),
          SizedBox(height: 15),
          CustomTextFormField(
            label: "Phone",
            onSaved: (value) => phone = value,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 15),
          CustomTextFormField(
            label: "Address",
            onSaved: (value) => address = value,
          ),
          SizedBox(height: 15),
          CustomTextFormField(
            label: "City",
            onSaved: (value) => city = value,
          ),
          SizedBox(height: 15),
          CustomTextFormField(
            label: "State",
            onSaved: (value) => state = value,
          ),
          SizedBox(height: 15),
          CustomTextFormField(
            label: "Zip Code",
            onSaved: (value) => zipCode = value,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 15),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitOrder,
            child: const Text("Submit Order"),
          ),
        ],
      ),
    );
  }
}
