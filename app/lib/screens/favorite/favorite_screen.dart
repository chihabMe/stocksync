import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/services/product_servies.dart';

import '../details/details_screen.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final ProductService productService = ProductService();
  late Future<List<Product>> futureLikedProducts;

  @override
  void initState() {
    super.initState();
    futureLikedProducts = productService.getLikedProducts();
  }

  void updateProductLikeStatus(String productId, bool isLiked) {
    setState(() {
      futureLikedProducts = futureLikedProducts.then((products) {
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
          Text(
            "Favorites",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FutureBuilder<List<Product>>(
                future: futureLikedProducts,
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
