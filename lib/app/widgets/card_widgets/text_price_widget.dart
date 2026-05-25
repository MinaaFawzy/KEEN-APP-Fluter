import 'package:flutter/material.dart';
import 'package:keen_official_app/domain/models/variants_model.dart';

class TextPriceWidget extends StatelessWidget {
  const TextPriceWidget({
    super.key,
    required this.product,
    required this.fontSize,
    this.detailsScreen = false,
    this.isCartScreen = false,
  });

  final Variants product;
  final double fontSize;
  final bool detailsScreen;
  final bool isCartScreen;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      mainAxisAlignment:
          detailsScreen || isCartScreen ? MainAxisAlignment.start : MainAxisAlignment.center,
      textBaseline: TextBaseline.alphabetic,
      children: [
        // Display old price if available
        if (product.compareAtPrice !=
            null) // Only show if oldPrice is not null
          Text(
            'LE ${product.compareAtPrice}',
            // Format old price
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: isCartScreen ? Colors.grey : Colors.black,
              // Faded color for old price
              decoration: TextDecoration.lineThrough, // Strikethrough effect
            ),
          ),
        if (product.compareAtPrice != null)
          const SizedBox(width: 8.0),
        Text(
          'LE ${product.price}',
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
