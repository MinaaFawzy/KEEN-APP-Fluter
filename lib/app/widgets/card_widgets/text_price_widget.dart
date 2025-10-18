import 'package:flutter/material.dart';
import 'package:keen_official_app/domain/models/product_model.dart';

class TextPriceWidget extends StatelessWidget {
  const TextPriceWidget({
    super.key,
    required this.product,
    required this.fontSize,
    this.detailsScreen = false,
  });

  final Products product;
  final double fontSize;
  final bool detailsScreen;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      mainAxisAlignment:
          detailsScreen ? MainAxisAlignment.start : MainAxisAlignment.center,
      textBaseline: TextBaseline.alphabetic,
      children: [
        // Display old price if available
        if (product.variants?[0].compareAtPrice !=
            null) // Only show if oldPrice is not null
          Text(
            'LE ${product.variants?[0].compareAtPrice}',
            // Format old price
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              // Faded color for old price
              decoration: TextDecoration.lineThrough, // Strikethrough effect
            ),
          ),
        if (product.variants?[0].compareAtPrice != null)
          const SizedBox(width: 8.0),
        Text(
          'LE ${product.variants?[0].price}',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFf94449),
          ),
        ),
      ],
    );
  }
}
