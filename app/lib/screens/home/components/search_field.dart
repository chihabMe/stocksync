import 'package:flutter/material.dart';
import '../../../constants.dart';

class SearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onSearchPressed;

  const SearchField({
    Key? key,
    required this.onChanged,
    required this.onSearchPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: kSecondaryColor.withOpacity(0.1),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          border: searchOutlineInputBorder,
          focusedBorder: searchOutlineInputBorder,
          enabledBorder: searchOutlineInputBorder,
          hintText: "Search product",
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: onSearchPressed,
          ),
        ),
      ),
    );
  }
}

const searchOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);
