import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String hintText;
  const SearchWidget({
    super.key,
    this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      autofocus: false,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: const Icon(
          Icons.search,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
