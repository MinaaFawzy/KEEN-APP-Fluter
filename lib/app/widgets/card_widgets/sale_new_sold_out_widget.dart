import 'package:flutter/material.dart';
import 'package:keen_official_app/app/methods/shop_methods.dart';
import 'package:keen_official_app/domain/models/product_model.dart';

class SaleNewSoldOutWidget extends StatelessWidget {
  const SaleNewSoldOutWidget({
    super.key,
    required this.product,
    required this.variantIndex,
  });

  final Products product;
  final int variantIndex;

  @override
  Widget build(BuildContext context) {

    final bool isSoldOut = checkQuantity(product, variantIndex);

    return Positioned(
      top: 8.0,
      left: 8.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          false
              ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                  vertical: 3.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  'New',
                  style: TextStyle(color: Colors.black, fontSize: 12.0),
                ),
              )
              : SizedBox(height: 0, width: 0),
          SizedBox(height: 4),
          product.variants?[variantIndex].compareAtPrice != null
              ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                  vertical: 3.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  'Sale',
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              )
              : SizedBox(height: 0, width: 0),
          SizedBox(height: 4),
          isSoldOut
              ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                  vertical: 3.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  'Sold Out',
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              )
              : SizedBox(height: 0, width: 0),
        ],
      ),
    );
  }
}


