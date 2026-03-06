import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();

  final List<_CartItem> _items = [
    _CartItem(
      title: 'Birthday Spark Gift Card',
      recipient: 'For Maya',
      price: 25.00,
      count: 1,
      color: Color(0xFF7BDFF2),
    ),
    _CartItem(
      title: 'Coffee Date Gift Card',
      recipient: 'For Jay',
      price: 15.00,
      count: 2,
      color: Color(0xFFFFC8DD),
    ),
  ];

  double get _subtotal =>
      _items.fold(0, (sum, item) => sum + (item.price * item.count));

  double get _serviceFee => _subtotal == 0 ? 0 : 1.99;
  double get _discount => 3.00;
  double get _total => (_subtotal + _serviceFee - _discount).clamp(0, 999999);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Giftly Cart',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              '${_items.length} items ready to send',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return _CartItemCard(
                    item: item,
                    onIncrement: () => setState(() => item.count++),
                    onDecrement: () => setState(() {
                      if (item.count > 1) item.count--;
                    }),
                    onRemove: () => setState(() => _items.removeAt(index)),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            _PromoField(controller: _promoController),
            const SizedBox(height: 12),
            _SummaryRow(label: 'Subtotal', value: _subtotal),
            _SummaryRow(label: 'Service fee', value: _serviceFee),
            _SummaryRow(label: 'Promo discount', value: -_discount),
            const Divider(height: 24),
            _SummaryRow(label: 'Total', value: _total, isEmphasis: true),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _items.isEmpty ? null : () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Leave a Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItem {
  _CartItem({
    required this.title,
    required this.recipient,
    required this.price,
    required this.count,
    required this.color,
  });

  final String title;
  final String recipient;
  final double price;
  int count;
  final Color color;
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final _CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.card_giftcard, color: Colors.black87),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.recipient,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  _CountButton(icon: Icons.remove, onTap: onDecrement),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('${item.count}'),
                  ),
                  _CountButton(icon: Icons.add, onTap: onIncrement),
                ],
              ),
              const SizedBox(height: 6),
              TextButton(onPressed: onRemove, child: const Text('Remove')),
            ],
          ),
        ],
      ),
    );
  }
}

class _CountButton extends StatelessWidget {
  const _CountButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

class _PromoField extends StatelessWidget {
  const _PromoField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Promo code',
        suffixIcon: TextButton(onPressed: () {}, child: const Text('Apply')),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isEmphasis = false,
  });

  final String label;
  final double value;
  final bool isEmphasis;

  @override
  Widget build(BuildContext context) {
    final valueText = value < 0
        ? '-\$${value.abs().toStringAsFixed(2)}'
        : '\$${value.toStringAsFixed(2)}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isEmphasis ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          Text(
            valueText,
            style: TextStyle(
              fontWeight: isEmphasis ? FontWeight.w700 : FontWeight.w500,
              color: isEmphasis ? Colors.black : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
