import 'package:flutter/material.dart';
import 'package:keen_official_app/domain/models/product_model.dart';

class ProductCardTitleWidget extends StatelessWidget {
  const ProductCardTitleWidget({
    super.key,
    required this.product,
    required this.variantIndex,
  });

  final Products product;
  final dynamic variantIndex;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${product.title} - ${product.variants?[variantIndex].option2}',
      style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w400),
      maxLines: 2, // Limit name to 2 lines
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center, // Add "..." if name is too long
    );
  }
}