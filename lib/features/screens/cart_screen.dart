import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:giftly/core/providers/app_providers.dart';
import 'package:giftly/core/api/api_endpoints.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _promoController = TextEditingController();
  bool _isApplyingPromo = false;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartAsync = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: const Color(0xFF4A3B8B),
        foregroundColor: Colors.white,
        actions: [
          cartAsync.value != null && cartAsync.value!.items.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    _showClearCartDialog(context);
                  },
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: cartAsync.when(
        data: (cart) {
          if (cart == null || cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add some gifts to get started!',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A3B8B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('Browse Gifts'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Cart Items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return CartItemCard(
                      item: item,
                      onRemove: () async {
                        try {
                          await ref
                              .read(cartProvider.notifier)
                              .removeItem(item.id);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Item removed from cart'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                          }
                        }
                      },
                      onQuantityChanged: (newQuantity) async {
                        try {
                          await ref
                              .read(cartProvider.notifier)
                              .updateItem(item.id, newQuantity);
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
              ),

              // Promo Code Section
              Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _promoController,
                        decoration: InputDecoration(
                          hintText: 'Enter promo code',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isApplyingPromo
                          ? null
                          : () async {
                              if (_promoController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter a promo code'),
                                  ),
                                );
                                return;
                              }

                              setState(() => _isApplyingPromo = true);
                              try {
                                await ref
                                    .read(cartProvider.notifier)
                                    .applyPromo(_promoController.text.trim());
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Promo code applied!'),
                                    ),
                                  );
                                  _promoController.clear();
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              } finally {
                                if (mounted) {
                                  setState(() => _isApplyingPromo = false);
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A3B8B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: _isApplyingPromo
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text('Apply'),
                    ),
                  ],
                ),
              ),

              // Order Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Column(
                  children: [
                    _SummaryRow(
                      label: 'Subtotal',
                      value: '\$${cart.totalAmount.toStringAsFixed(2)}',
                    ),
                    if (cart.discount != null && cart.discount! > 0)
                      _SummaryRow(
                        label: 'Discount (${cart.promoCode})',
                        value: '-\$${cart.discount!.toStringAsFixed(2)}',
                        valueColor: Colors.green,
                      ),
                    const Divider(height: 24),
                    _SummaryRow(
                      label: 'Total',
                      value: '\$${cart.finalAmount.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          _showCheckoutDialog(context, cart.finalAmount);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A3B8B),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Proceed to Checkout',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${cart.itemCount} ${cart.itemCount == 1 ? 'item' : 'items'})',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${error.toString()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(cartProvider.notifier).loadCart();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text(
          'Are you sure you want to remove all items from your cart?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(cartProvider.notifier).clearCart();
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Cart cleared')));
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context, double total) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_bag, size: 64, color: Color(0xFF4A3B8B)),
            const SizedBox(height: 16),
            Text(
              'Total Amount: \$${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Checkout functionality will be implemented here',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order placed successfully!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A3B8B),
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm Order'),
          ),
        ],
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final dynamic item;
  final VoidCallback onRemove;
  final Function(int) onQuantityChanged;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: item.gift.image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        '${ApiEndpoints.serverRoot}${item.gift.image}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) {
                          return const Icon(Icons.card_giftcard, size: 40);
                        },
                      ),
                    )
                  : const Icon(Icons.card_giftcard, size: 40),
            ),
            const SizedBox(width: 12),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.gift.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.gift.category,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A3B8B),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: item.quantity > 1
                                ? () => onQuantityChanged(item.quantity - 1)
                                : null,
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () =>
                                onQuantityChanged(item.quantity + 1),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Remove button
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? (isTotal ? const Color(0xFF4A3B8B) : null),
            ),
          ),
        ],
      ),
    );
  }
}
