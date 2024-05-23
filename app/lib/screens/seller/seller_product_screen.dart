import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/seller/seller_add_product_screen.dart';
import 'package:shop_app/screens/seller/seller_update_product_screen.dart'; // Import the update product screen
import 'package:shop_app/services/product_servies.dart';

class SellerProductScreen extends StatefulWidget {
  @override
  _SellerProductScreenState createState() => _SellerProductScreenState();
}

class _SellerProductScreenState extends State<SellerProductScreen> {
  final productService = ProductService();

  Future<void> _refreshProducts() async {
    // Refresh products by fetching them again from the service
    setState(() {}); // Refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigate to the AddProductScreen
                  Navigator.pushNamed(
                      context, SellerAddProductScreen.routeName);
                },
                child: Text('Add Product'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshProducts,
                  child: FutureBuilder<List<Product>>(
                    future: productService.getSellerProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No products found'));
                      } else {
                        final products = snapshot.data!;
                        return ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return Card(
                              margin: EdgeInsets.only(bottom: 16.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Display the first image of the product
                                        if (product.images.isNotEmpty)
                                          SizedBox(
                                            height:
                                                100, // Adjust the height as needed
                                            width:
                                                100, // Adjust the width as needed
                                            child: Image.network(
                                              product.images.first,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        SizedBox(
                                            width:
                                                16.0), // Add spacing between image and text
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Display the name of the product
                                              Text(
                                                product.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              SizedBox(height: 8.0),
                                              // Display the price of the product
                                              Text(
                                                'Price: \$${product.price.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              // Display the stock of the product
                                              Text(
                                                'Stock: ${product.stock}', // Assuming there's a stock property in your Product model
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            // Navigate to update product screen and pass the product
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SellerUpdateProductScreen(
                                                        product: product),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.copy),
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                text: product.id));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Product ID copied to clipboard'),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () async {
                                            bool isDeleted =
                                                await _deleteProduct(context,
                                                    productService, product.id);
                                            if (isDeleted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Product deleted successfully')),
                                              );
                                              // Refresh the product list
                                              _refreshProducts();
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Failed to delete product')),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _deleteProduct(BuildContext context,
      ProductService productService, String productId) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Delete Product'),
              content: Text('Are you sure you want to delete this product?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    bool isDeleted =
                        await productService.deleteProduct(productId);
                    Navigator.of(context).pop(isDeleted);
                  },
                  child: Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
