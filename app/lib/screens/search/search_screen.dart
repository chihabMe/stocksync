import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/home/components/search_field.dart';
import 'package:shop_app/services/product_servies.dart';

import '../details/details_screen.dart';

class SearchScreen extends StatefulWidget {
  static String routeName = "/search";

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ProductService productService = ProductService();
  Future<List<Product>>? futureSearchedProducts;
  String searchQuery = "";

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      if (searchQuery.isNotEmpty) {
        futureSearchedProducts = productService.searchProducts(searchQuery);
      } else {
        futureSearchedProducts = null;
      }
    });
  }

  void updateProductLikeStatus(String productId, bool isLiked) {
    setState(() {
      futureSearchedProducts = futureSearchedProducts!.then((products) {
        return products.map((product) {
          if (product.id == productId) {
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
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchField(
              onChanged: (query) {
                updateSearchQuery(query);
              },
              onSearchPressed: () {
                updateSearchQuery(searchQuery);
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FutureBuilder<List<Product>>(
                future: futureSearchedProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No products found'));
                  }

                  List<Product> products = snapshot.data!;

                  return GridView.builder(
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 0.7,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(
                        productService: productService,
                        product: products[index],
                        onPress: () async {
                          // Navigate to the details screen
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
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
