import 'package:flutter/material.dart';
import 'package:woo_demo/utils/constants.dart';

/// creates empty state place holder widget
class MyEmptyState extends StatelessWidget {
  const MyEmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * 4),
        child: Column(
          children: const [
            Icon(
              Icons.search_outlined,
              size: 40,
            ),
            SizedBox(height: kDefaultPadding * 2),
            Text("No results found"),
          ],
        ),
      ),
    );
  }
}
