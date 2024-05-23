import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/services/product_servies.dart';

class SellerUpdateProductScreen extends StatefulWidget {
  static const String routeName = "/seller_update_product";

  final Product product;

  const SellerUpdateProductScreen({required this.product});

  @override
  _SellerUpdateProductScreenState createState() =>
      _SellerUpdateProductScreenState();
}

class _SellerUpdateProductScreenState extends State<SellerUpdateProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _categoryName = TextEditingController();
  List<XFile> _imageFiles = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.name;
    _priceController.text = widget.product.price.toString();
    _descriptionController.text = widget.product.description ?? "";
    _stockController.text = widget.product.stock.toString();
    _categoryName.text = "";
  }

  void _updateProduct(BuildContext context) async {
    final productService = ProductService();
    final updatedProduct = NewProduct(
      name: _nameController.text,
      price: double.parse(_priceController.text),
      description: _descriptionController.text,
      stock: int.parse(_stockController.text),
      images: [],
      category: _categoryName.text,
    );

    bool success = await productService.updateProduct(
        widget.product.id, updatedProduct, _imageFiles);
    if (success) {
      Navigator.of(context).pop();
    } else {
      // Handle error
      print("Failed to update product");
    }
  }

  Future<void> _pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        _imageFiles.addAll(selectedImages);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      labelText: 'Product Name',
                    ),
                    _buildTextField(
                      controller: _categoryName,
                      labelText: 'Category Name',
                    ),
                    _buildTextField(
                      controller: _priceController,
                      labelText: 'Price',
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                    ),
                    _buildTextField(
                      controller: _descriptionController,
                      labelText: 'Description',
                      maxLines: 5,
                    ),
                    _buildTextField(
                      controller: _stockController,
                      labelText: 'Stock',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _pickImages,
                      child: Text('Pick Images'),
                    ),
                    SizedBox(height: 10),
                    _buildImagePreview(),
                    ElevatedButton(
                      onPressed: () => _updateProduct(context),
                      child: Text('Update'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Wrap(
      children: _imageFiles.map((image) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.file(
            File(image.path),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        );
      }).toList(),
    );
  }
}
