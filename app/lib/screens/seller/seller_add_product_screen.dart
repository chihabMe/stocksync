import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shop_app/models/Product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/services/product_servies.dart'; // For image picking

class SellerAddProductScreen extends StatefulWidget {
  static const String routeName = "/seller_add_product";

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<SellerAddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _categoryName = TextEditingController();
  List<XFile> _imageFiles = [];

  final ImagePicker _picker = ImagePicker();

  void _addProduct(BuildContext context) async {
    final productService = ProductService();
    final newProduct = NewProduct(
      name: _nameController.text,
      price: double.parse(_priceController.text),
      description: _descriptionController.text,
      stock: int.parse(_stockController.text),
      images: [],
      category: _categoryName.text,
    );

    bool success = await productService.addProduct(newProduct, _imageFiles);
    if (success) {
      Navigator.of(context).pop();
    } else {
      // Handle error
      print("Failed to add product");
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
        title: Text('Add Product'),
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
                      labelText: 'category name',
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
                      onPressed: () => _addProduct(context),
                      child: Text('Add'),
                    ),
                  ],
                ),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () => _addProduct(context),
            //       child: Text('Add'),
            //     ),
            //   ],
            // ),
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
