import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart'; // Import your ProductCard widget
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/services/product_servies.dart';

class ProductListGrid extends StatefulWidget {
  final ProductService productService = ProductService();

  ProductListGrid({Key? key}) : super(key: key);

  @override
  _ProductListGridState createState() => _ProductListGridState();
}

class _ProductListGridState extends State<ProductListGrid> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = widget.productService.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Products',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Product>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No products found.'));
              } else {
                final products = snapshot.data!;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 10.0, // Horizontal space between items
                    mainAxisSpacing: 10.0, // Vertical space between items
                    childAspectRatio: 0.75, // Aspect ratio of the grid items
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      productService: widget.productService,
                      onPress: () {
                        // Define what happens when a product is tapped
                        // For example, navigate to product details screen
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
