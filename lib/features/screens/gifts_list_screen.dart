import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:giftly/core/providers/app_providers.dart';
import 'package:giftly/core/models/gift_model.dart';
import 'package:giftly/features/screens/gift_detail_screen.dart';
import 'package:giftly/core/api/api_endpoints.dart';

class GiftsListScreen extends ConsumerStatefulWidget {
  const GiftsListScreen({super.key});

  @override
  ConsumerState<GiftsListScreen> createState() => _GiftsListScreenState();
}

class _GiftsListScreenState extends ConsumerState<GiftsListScreen> {
  String? selectedCategory;
  String? selectedEvent;

  @override
  Widget build(BuildContext context) {
    final giftsAsync = ref.watch(giftsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gift Store'),
        backgroundColor: const Color(0xFF4A3B8B),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('All')),
                      DropdownMenuItem(value: 'Sports', child: Text('Sports')),
                      DropdownMenuItem(value: 'Gaming', child: Text('Gaming')),
                      DropdownMenuItem(value: 'Tech', child: Text('Tech')),
                      DropdownMenuItem(
                        value: 'Fashion',
                        child: Text('Fashion'),
                      ),
                      DropdownMenuItem(value: 'Books', child: Text('Books')),
                      DropdownMenuItem(
                        value: 'Accessories',
                        child: Text('Accessories'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedEvent,
                    decoration: const InputDecoration(
                      labelText: 'Event',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('All')),
                      DropdownMenuItem(
                        value: 'birthday',
                        child: Text('Birthday'),
                      ),
                      DropdownMenuItem(
                        value: 'anniversary',
                        child: Text('Anniversary'),
                      ),
                      DropdownMenuItem(
                        value: 'wedding',
                        child: Text('Wedding'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedEvent = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Gifts List
          Expanded(
            child: giftsAsync.when(
              data: (gifts) {
                if (gifts.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.card_giftcard, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No gifts available',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                // Filter gifts
                List<GiftModel> filteredGifts = gifts.where((gift) {
                  if (selectedCategory != null &&
                      gift.category != selectedCategory) {
                    return false;
                  }
                  if (selectedEvent != null && gift.event != selectedEvent) {
                    return false;
                  }
                  return true;
                }).toList();

                if (filteredGifts.isEmpty) {
                  return const Center(
                    child: Text(
                      'No gifts match your filters',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(giftsProvider);
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: filteredGifts.length,
                    itemBuilder: (context, index) {
                      return GiftCard(gift: filteredGifts[index]);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${error.toString()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(giftsProvider);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GiftCard extends ConsumerWidget {
  final GiftModel gift;

  const GiftCard({super.key, required this.gift});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.value?.isFavorite(gift.id) ?? false;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GiftDetailScreen(giftId: gift.id),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      color: Colors.grey[200],
                    ),
                    child: gift.image != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              '${ApiEndpoints.serverRoot}${gift.image}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stack) {
                                return const Icon(
                                  Icons.card_giftcard,
                                  size: 64,
                                );
                              },
                            ),
                          )
                        : const Icon(Icons.card_giftcard, size: 64),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 18,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                        onPressed: () async {
                          try {
                            if (isFavorite) {
                              final itemId = favorites.value?.items
                                  .firstWhere((item) => item.gift.id == gift.id)
                                  .id;
                              if (itemId != null) {
                                await ref
                                    .read(favoritesProvider.notifier)
                                    .removeFavorite(itemId);
                              }
                            } else {
                              await ref
                                  .read(favoritesProvider.notifier)
                                  .addFavorite(gift.id);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gift.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    gift.category,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        gift.price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A3B8B),
                        ),
                      ),
                      if (gift.rating != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            Text(
                              ' ${gift.rating!.toStringAsFixed(1)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
