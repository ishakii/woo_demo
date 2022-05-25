import 'package:flutter/material.dart';
import 'package:woo_demo/utils/constants.dart';

import '../../utils/keyboard_util.dart';

/// creates a text field for searching
/// onChanged must not be null
class MySearchBar extends StatelessWidget {
  final Function(String) onChanged;

  const MySearchBar({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: TextField(
        onChanged: onChanged,
        onEditingComplete: () {
          KeyboardUtil.hideKeyboard(context);
        },
        maxLines: 1,
        decoration: const InputDecoration(
          filled: true,
          suffixIcon: Padding(
            padding: EdgeInsets.all(kDefaultPadding),
            child: Icon(Icons.search),
          ),
          hintText: "Search Coin...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(kDefaultBorderRadius),
            ),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
