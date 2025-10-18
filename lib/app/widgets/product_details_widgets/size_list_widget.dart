import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/providers/product_details/product_details_provider.dart';
import 'package:keen_official_app/domain/models/product_model.dart';

class SizeList extends ConsumerWidget {
  const SizeList({
    super.key,
    required int sizeIndex,
    required this.product,
  }) : _sizeIndex = sizeIndex;

  final int _sizeIndex;
  final Products product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 40,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder:
            (context, index) =>
            Row(
              children: [
                GestureDetector(
                  child: Opacity(
                    opacity: index == _sizeIndex ? 1.0 : 0.5,
                    child: Container(
                      width: product.options![0].values![index].toLowerCase() == 'one size'? 70 : 50,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: CheckSizeQuantity(index) ? Colors.black : Colors.red,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          product.options![0].values![index],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    if (CheckSizeQuantity(index)){
                      ref.read(sizeIndexProvider.notifier).state = index;
                    }
                  },
                ),
                SizedBox(width: 8),
              ],
            ),
        itemCount: product.options![0].values?.length,
      ),
    );
  }

  bool CheckSizeQuantity(int index) {
    for (int i = 0; i < product.variants!.length; i++) {
      if (product.variants?[i].option1 ==
          product.options![0].values![index] &&
          (product.variants?[i].inventoryQuantity ?? 0) > 0){
        return true;
      }
    }
    return false;
  }
}