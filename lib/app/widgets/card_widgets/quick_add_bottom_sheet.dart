import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/providers/cart/shopify_cart_provider.dart';
import 'package:keen_official_app/data/services/toast_service.dart';
import 'package:keen_official_app/domain/models/product_model.dart';

class QuickAddBottomSheet extends ConsumerStatefulWidget {
  const QuickAddBottomSheet({
    super.key,
    required this.product,
    required this.variantIndex,
  });

  final Products product;
  final int variantIndex;

  @override
  ConsumerState<QuickAddBottomSheet> createState() =>
      _QuickAddBottomSheetState();
}

class _QuickAddBottomSheetState extends ConsumerState<QuickAddBottomSheet> {
  String? selectedSize;
  String? selectedColor;
  int selectedVariantIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeSelection();
  }

  void _initializeSelection() {
    if (widget.product.variants != null &&
        widget.product.variants!.isNotEmpty) {
      selectedSize = widget.product.variants![widget.variantIndex].option1;
      selectedColor = widget.product.variants![widget.variantIndex].option2;
      selectedVariantIndex = widget.variantIndex;
    }
  }

  void _updateVariant() {
    for (int i = 0; i < widget.product.variants!.length; i++) {
      if (widget.product.variants![i].option1?.toLowerCase() ==
              selectedSize?.toLowerCase() &&
          widget.product.variants![i].option2?.toLowerCase() ==
              selectedColor?.toLowerCase()) {
        setState(() {
          selectedVariantIndex = i;
        });
        break;
      }
    }
  }

  List<String> _getAvailableSizes() {
    final sizes = <String>{};
    if (widget.product.variants != null) {
      for (final variant in widget.product.variants!) {
        if (variant.option1 != null) {
          sizes.add(variant.option1!);
        }
      }
    }
    return sizes.toList();
  }

  List<String> _getAvailableColors() {
    final colors = <String>{};
    if (widget.product.variants != null) {
      for (final variant in widget.product.variants!) {
        if (variant.option2 != null) {
          colors.add(variant.option2!);
        }
      }
    }
    return colors.toList();
  }

  String _getPrice() {
    if (widget.product.variants != null &&
        selectedVariantIndex < widget.product.variants!.length) {
      return widget.product.variants![selectedVariantIndex].price ?? '0.00';
    }
    return '0.00';
  }

  String _getCompareAtPrice() {
    if (widget.product.variants != null &&
        selectedVariantIndex < widget.product.variants!.length) {
      return widget.product.variants![selectedVariantIndex].compareAtPrice ??
          '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final sizes = _getAvailableSizes();
    final colors = _getAvailableColors();
    final price = _getPrice();
    final compareAtPrice = _getCompareAtPrice();
    final hasDiscount = compareAtPrice.isNotEmpty && compareAtPrice != price;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Product info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                // Product image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[100],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child:
                        widget.product.image?.src != null
                            ? Image.network(
                              widget.product.image!.src!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image,
                                  size: 40,
                                  color: Colors.grey,
                                );
                              },
                            )
                            : const Icon(
                              Icons.image,
                              size: 40,
                              color: Colors.grey,
                            ),
                  ),
                ),
                const SizedBox(width: 16),

                // Product details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.title ?? 'Product',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '\$$price',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: hasDiscount ? Colors.red : Colors.black,
                            ),
                          ),
                          if (hasDiscount) ...[
                            const SizedBox(width: 8),
                            Text(
                              '\$$compareAtPrice',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Size selection
          if (sizes.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Size',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        sizes.map((size) {
                          final isSelected = selectedSize == size;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedSize = size;
                              });
                              _updateVariant();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Colors.black
                                        : Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? Colors.black
                                          : Colors.grey[300]!,
                                ),
                              ),
                              child: Text(
                                size,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Color selection
          if (colors.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Color',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        colors.map((color) {
                          final isSelected = selectedColor == color;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedColor = color;
                              });
                              _updateVariant();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Colors.black
                                        : Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? Colors.black
                                          : Colors.grey[300]!,
                                ),
                              ),
                              child: Text(
                                color,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Add to cart button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  if (widget.product.variants != null &&
                      selectedVariantIndex < widget.product.variants!.length) {
                    final variant =
                        widget.product.variants![selectedVariantIndex];
                    final variantGid = variant.adminGraphqlApiId;

                    if (variantGid != null) {
                      ref
                          .read(shopifyCartProvider.notifier)
                          .addToCart(variantGid);
                      ToastManager.showSuccess(
                        context,
                        'Added to cart successfully!',
                      );
                      Navigator.pop(context);
                    } else {
                      ToastManager.showError(
                          context, 'Unable to add to cart. Please try again.');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
