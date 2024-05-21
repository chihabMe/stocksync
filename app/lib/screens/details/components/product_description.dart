import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/services/product_servies.dart';

import '../../../constants.dart';
import '../../../models/Product.dart';

class ProductDescription extends StatefulWidget {
  ProductDescription({
    Key? key,
    required this.productId,
    this.pressOnSeeMore,
  }) : super(key: key);

  final String productId;
  final GestureTapCallback? pressOnSeeMore;
  final ProductService productService = ProductService();

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  late bool isLiked;
  late Future<Product> futureProduct;
  final ProductService productService = ProductService();

  @override
  void initState() {
    super.initState();
    // Load product details
    futureProduct = productService.getProduct(widget.productId);
    futureProduct.then((product) {
      setState(() {
        isLiked = product.isLiked;
      });
    });
  }

  // Method to handle like/unlike
  void handleLike(Product product) async {
    // Call the backend service to toggle like
    bool response = await productService.toggleLike(product.id);
    if (response) {
      // If the operation is successful, update the UI
      setState(() {
        isLiked = !isLiked; // Toggle the like state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: futureProduct,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          Product product = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  product.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => handleLike(product),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: 48,
                    decoration: BoxDecoration(
                      color: isLiked
                          ? const Color(0xFFFFE6E6)
                          : const Color(0xFFF5F6F9),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/Heart Icon_2.svg",
                      colorFilter: ColorFilter.mode(
                        isLiked
                            ? const Color(0xFFFF4848)
                            : const Color(0xFFDBDEE4),
                        BlendMode.srcIn,
                      ),
                      height: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 64,
                ),
                child: Text(
                  product.description ?? "",
                  maxLines: 3,
                ),
              ),
              if (widget.pressOnSeeMore != null)
                GestureDetector(
                  onTap: widget.pressOnSeeMore,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "See More Detail",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          );
        } else {
          return Center(child: Text('No product found'));
        }
      },
    );
  }
}
