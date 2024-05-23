import 'package:flutter/material.dart';
import 'package:shop_app/models/Coupon.dart';
import 'package:shop_app/services/product_servies.dart';

class SellerCouponsScreen extends StatefulWidget {
  @override
  _SellerCouponsScreenState createState() => _SellerCouponsScreenState();
}

class _SellerCouponsScreenState extends State<SellerCouponsScreen> {
  final ProductService _productService = ProductService();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _productIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller Coupons'),
      ),
      body: FutureBuilder<List<Coupon>>(
        future: _productService.getSellerCoupons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Coupon> coupons = snapshot.data!;
            return ListView.builder(
              itemCount: coupons.length,
              itemBuilder: (context, index) {
                final Coupon coupon = coupons[index];
                return ListTile(
                  title: Text('Coupon Code: ${coupon.code}'),
                  subtitle: Text(
                    'Expiry Date: ${coupon.expiryDate} discount ${coupon.discount!}%',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        coupon.expired ? Icons.data_exploration : Icons.check,
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteCoupon(coupon.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCouponDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showCouponDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Generate Coupon'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _discountController,
                decoration: InputDecoration(labelText: 'Discount (%)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _productIdController,
                decoration: InputDecoration(labelText: 'Product ID'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                int discount = int.tryParse(_discountController.text) ?? 0;
                String productId = _productIdController.text.trim();
                _generateCoupon(discount, productId);
                Navigator.pop(context);
              },
              child: Text('Generate'),
            ),
          ],
        );
      },
    );
  }

  void _generateCoupon(int discount, String productId) {
    _productService.generateSellerCoupon(discount, productId).then((coupon) {
      if (coupon != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Coupon generated successfully')),
        );
        setState(() {}); // Refresh the coupons list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate coupon')),
        );
      }
    });
  }

  void _deleteCoupon(String couponId) {
    _productService.deleteSellerCoupon(couponId).then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Coupon deleted successfully')),
        );
        setState(() {}); // Refresh the coupons list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete coupon')),
        );
      }
    });
  }

  @override
  void dispose() {
    _discountController.dispose();
    _productIdController.dispose();
    super.dispose();
  }
}
