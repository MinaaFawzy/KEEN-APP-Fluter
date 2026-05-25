import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/providers/cart/shopify_cart_provider.dart';
import 'package:keen_official_app/data/thems/app_colors.dart';
import 'package:keen_official_app/domain/models/cart_model.dart';
import 'package:url_launcher/url_launcher.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(shopifyCartProvider);

    // Show error banner if needed
    ref.listen(shopifyCartProvider, (_, next) {
      if (next.hasError && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red[700],
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () =>
                  ref.read(shopifyCartProvider.notifier).clearError(),
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────
            _CartHeader(totalQuantity: cartState.totalQuantity),

            // ── Body ───────────────────────────────────────────────────
            Expanded(
              child: switch (cartState.status) {
                CartStatus.initial ||
                CartStatus.loading when cartState.cart == null =>
                  const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  ),
                _ when cartState.isEmpty => const _EmptyCartView(),
                _ => _CartListView(lines: cartState.lines),
              },
            ),

            // ── Footer ─────────────────────────────────────────────────
            if (!cartState.isEmpty)
              _CartFooter(
                totalAmount: cartState.totalAmount,
                currencyCode: cartState.currencyCode,
                isLoading: cartState.isLoading,
                onCheckout: () => _openCheckout(context, ref),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCheckout(BuildContext context, WidgetRef ref) async {
    final url = await ref.read(shopifyCartProvider.notifier).getCheckoutUrl();
    if (url == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not get checkout link.')),
        );
      }
      return;
    }
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// ══════════════════════════════════════════════════════════════
// Header
// ══════════════════════════════════════════════════════════════

class _CartHeader extends StatelessWidget {
  const _CartHeader({required this.totalQuantity});
  final int totalQuantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.dividerColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Shopping Cart',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (totalQuantity > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$totalQuantity',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Empty Cart
// ══════════════════════════════════════════════════════════════

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 72, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'Your cart is empty',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add items to get started',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Cart List
// ══════════════════════════════════════════════════════════════

class _CartListView extends ConsumerWidget {
  const _CartListView({required this.lines});
  final List<CartLineItem> lines;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: lines.length,
      separatorBuilder: (_, __) => const SizedBox(height: 0),
      itemBuilder: (_, i) => _CartLineItemTile(item: lines[i]),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Single Line Item Tile
// ══════════════════════════════════════════════════════════════

class _CartLineItemTile extends ConsumerWidget {
  const _CartLineItemTile({required this.item});
  final CartLineItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading =
        ref.watch(shopifyCartProvider.select((s) => s.isLoading));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Product Image ────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: item.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: item.imageUrl!,
                    width: 100,
                    height: 130,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 100,
                      height: 130,
                      color: Colors.grey[200],
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: 100,
                      height: 130,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image_outlined),
                    ),
                  )
                : Container(
                    width: 100,
                    height: 130,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported_outlined),
                  ),
          ),

          const SizedBox(width: 14),

          // ── Details ───────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productTitle,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.variantTitle != 'Default Title') ...[
                  const SizedBox(height: 4),
                  Text(
                    item.variantTitle,
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
                if (item.selectedOptions.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.selectedOptions
                        .map((o) => '${o.name}: ${o.value}')
                        .join(' · '),
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
                const SizedBox(height: 8),
                // Price
                Row(
                  children: [
                    Text(
                      '${item.currencyCode} ${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    if (item.compareAtPrice != null &&
                        item.compareAtPrice! > item.price) ...[
                      const SizedBox(width: 6),
                      Text(
                        '${item.currencyCode} ${item.compareAtPrice!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),

                // ── Quantity & Remove ──────────────────────────────
                Row(
                  children: [
                    // Quantity stepper
                    Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.dividerColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _StepButton(
                            icon: Icons.remove,
                            onTap: isLoading
                                ? null
                                : () {
                                    if (item.quantity > 1) {
                                      ref
                                          .read(shopifyCartProvider
                                              .notifier)
                                          .updateQuantity(
                                              item.lineId,
                                              item.quantity - 1);
                                    } else {
                                      ref
                                          .read(shopifyCartProvider
                                              .notifier)
                                          .removeFromCart(item.lineId);
                                    }
                                  },
                          ),
                          SizedBox(
                            width: 32,
                            child: Center(
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          _StepButton(
                            icon: Icons.add,
                            onTap: isLoading
                                ? null
                                : () => ref
                                    .read(shopifyCartProvider.notifier)
                                    .updateQuantity(
                                        item.lineId, item.quantity + 1),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Delete
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          size: 20, color: Colors.grey),
                      onPressed: isLoading
                          ? null
                          : () => ref
                              .read(shopifyCartProvider.notifier)
                              .removeFromCart(item.lineId),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Footer
// ══════════════════════════════════════════════════════════════

class _CartFooter extends StatelessWidget {
  const _CartFooter({
    required this.totalAmount,
    required this.currencyCode,
    required this.isLoading,
    required this.onCheckout,
  });
  final double totalAmount;
  final String currencyCode;
  final bool isLoading;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.dividerColor)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              Text(
                '$currencyCode ${totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: isLoading ? null : onCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline, size: 18),
                        SizedBox(width: 8),
                        Text('Proceed to Checkout',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
