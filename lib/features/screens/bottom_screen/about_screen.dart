import 'package:flutter/material.dart';
import 'package:giftly/core/models/gift_item.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key, required this.favorites});

  final List<GiftItem> favorites;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Giftly'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1C8A99),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7FBFF), Color(0xFFFFF4E8)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 96,
                      width: 96,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Giftly',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Thoughtful gifting, made simple',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(label: 'Curated gifts', value: '120+'),
                    _StatItem(label: 'Happy senders', value: '8k'),
                    _StatItem(label: 'Fast delivery', value: '1-2 days'),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'What Giftly does',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              const Text(
                'Discover gifts, plan surprises, and send digital gift cards in minutes. Giftly keeps your important dates and favorite ideas in one clean place.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 18),
              const Text(
                'Why people love it',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              _buildFeatureItem(
                Icons.card_giftcard,
                'Instant gift cards',
                'Send a beautiful card with a personal message in seconds.',
              ),
              _buildFeatureItem(
                Icons.favorite_border,
                'Favorites list',
                'Save the gifts you like and revisit them anytime.',
              ),
              _buildFeatureItem(
                Icons.calendar_today,
                'Smart reminders',
                'Never miss a birthday or celebration again.',
              ),
              _buildFeatureItem(
                Icons.lock_outline,
                'Private by design',
                'Your data stays secure and your moments stay personal.',
              ),
              const SizedBox(height: 18),
              const Text(
                'Your favorites',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              if (favorites.isEmpty)
                Text(
                  'No favorites yet. Tap the heart on Home to save gifts you love.',
                  style: TextStyle(color: Colors.grey.shade700),
                )
              else
                SizedBox(
                  height: 160,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: favorites.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return _FavoriteTile(item: favorites[index]);
                    },
                  ),
                ),
              const SizedBox(height: 18),
              const Divider(),
              const SizedBox(height: 12),
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Contact',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'support@giftly.com',
                      style: TextStyle(color: Colors.blue.shade700),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '© 2026 Giftly',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 26, color: const Color(0xFF1C8A99)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}

class _FavoriteTile extends StatelessWidget {
  const _FavoriteTile({required this.item});

  final GiftItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: item.resolvedImageUrl == null
                ? Container(
                    height: 90,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.card_giftcard),
                  )
                : Image.network(
                    item.resolvedImageUrl!,
                    height: 90,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        height: 90,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              item.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
