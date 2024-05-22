import 'package:flutter/material.dart';
import 'package:shop_app/services/product_servies.dart';

import '../../../components/product_card.dart';
import '../../../models/Product.dart';
import '../../details/details_screen.dart';
import '../../products/products_screen.dart';
import 'section_title.dart';

class NewProducts extends StatefulWidget {
  @override
  _NewProductsState createState() => _NewProductsState();
}

class _NewProductsState extends State<NewProducts> {
  final ProductService productService = ProductService();
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = productService.getNewProducts();
  }

  void updateProductLikeStatus(String productId, bool isLiked) {
    setState(() {
      futureProducts = futureProducts.then((products) {
        return products.map((product) {
          if (product.id == productId) {
            // Create a new Product object with updated isLiked
            return Product(
                id: product.id,
                name: product.name,
                description: product.description,
                images: product.images,
                rating: product.rating,
                price: product.price,
                isLiked: isLiked,
                stock: 1);
          }
          return product;
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: futureProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No products found'));
        }

        List<Product> products = snapshot.data!;

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SectionTitle(
                title: "New Products",
                press: () {
                  Navigator.pushNamed(context, ProductsScreen.routeName);
                },
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(
                    products.length,
                    (index) {
                      return Padding(
                        padding: EdgeInsets.only(left: 25),
                        child: ProductCard(
                          productService: productService,
                          product: products[index],
                          onPress: () async {
                            // Get the result from the details screen
                            bool? isLiked = await Navigator.pushNamed(
                              context,
                              DetailsScreen.routeName,
                              arguments: ProductDetailsArguments(
                                product: products[index],
                              ),
                            ) as bool?;

                            // If the result is not null, update the product like status
                            if (isLiked != null) {
                              updateProductLikeStatus(
                                  products[index].id, isLiked);
                            }
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
