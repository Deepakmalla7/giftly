import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:giftly/features/dashboard/presentation/viewmodels/gift_recommendation_view_model.dart';
import 'package:giftly/wedgets/product_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:giftly/features/profile/presentation/pages/profile_screen.dart';
import 'package:giftly/features/screens/bottom_screen/cart_screen.dart';
import 'package:giftly/features/screens/bottom_screen/about_screen.dart';
import 'package:giftly/core/models/gift_item.dart';
import 'package:giftly/features/item/presentation/pages/gift_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  final ScrollController _gridController = ScrollController();

  // Shake detection
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  static const double _shakeThreshold = 5.0;
  DateTime _lastShakeTime = DateTime.now().subtract(const Duration(seconds: 5));
  static const Duration _shakeCooldown = Duration(seconds: 3);

  final List<String> _events = const [
    'Birthday',
    'Valentine',
    'Anniversary',
    'Wedding',
    'Graduation',
    'Housewarming',
  ];
  final List<String> _ageGroups = const ['Kid', 'Teen', 'Adult', 'Senior'];
  final List<String> _genders = const ['Male', 'Female', 'Unisex'];

  final Map<String, GiftItem> _favoriteGifts = {};
  @override
  void initState() {
    super.initState();
    _gridController.addListener(_onGridScroll);
    _startShakeListener();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _gridController.removeListener(_onGridScroll);
    _gridController.dispose();
    super.dispose();
  }

  void _startShakeListener() {
    _accelerometerSubscription = userAccelerometerEventStream().listen(
      (event) {
        // Detect shake on any axis (horizontal or vertical)
        final maxAxis = [
          event.x.abs(),
          event.y.abs(),
          event.z.abs(),
        ].reduce((a, b) => a > b ? a : b);
        if (maxAxis > _shakeThreshold) {
          final now = DateTime.now();
          if (now.difference(_lastShakeTime) > _shakeCooldown) {
            _lastShakeTime = now;
            _onShakeDetected();
          }
        }
      },
      onError: (e) {
        debugPrint('Shake listener error: $e');
      },
    );
  }

  void _onShakeDetected() {
    if (_currentIndex != 0) return; // Only refresh on home tab
    ref.read(giftRecommendationViewModelProvider).loadInitial();
    if (_gridController.hasClients) {
      _gridController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Page refreshed successfully'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _onGridScroll() {
    if (!_gridController.hasClients) return;
    final position = _gridController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(giftRecommendationViewModelProvider).loadMore();
    }
  }

  //
  Widget _buildHome() {
    final viewModel = ref.watch(giftRecommendationViewModelProvider);

    return Column(
      children: [
        const SizedBox(height: 8),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI Gift Recommendations jnbjgf',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: viewModel.event,
                        decoration: const InputDecoration(
                          labelText: 'Event',
                          prefixIcon: Icon(Icons.event),
                          border: OutlineInputBorder(),
                        ),
                        items: _events
                            .map(
                              (event) => DropdownMenuItem(
                                value: event,
                                child: Text(event),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          ref
                              .read(giftRecommendationViewModelProvider)
                              .setFilters(
                                event: value,
                                ageGroup: viewModel.ageGroup,
                                gender: viewModel.gender,
                              );
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: viewModel.ageGroup,
                        decoration: const InputDecoration(
                          labelText: 'Age Group',
                          prefixIcon: Icon(Icons.cake),
                          border: OutlineInputBorder(),
                        ),
                        items: _ageGroups
                            .map(
                              (group) => DropdownMenuItem(
                                value: group,
                                child: Text(group),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          ref
                              .read(giftRecommendationViewModelProvider)
                              .setFilters(
                                event: viewModel.event,
                                ageGroup: value,
                                gender: viewModel.gender,
                              );
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: viewModel.gender,
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        items: _genders
                            .map(
                              (gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          ref
                              .read(giftRecommendationViewModelProvider)
                              .setFilters(
                                event: viewModel.event,
                                ageGroup: viewModel.ageGroup,
                                gender: value,
                              );
                        },
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => ref
                              .read(giftRecommendationViewModelProvider)
                              .loadInitial(),
                          icon: const Icon(Icons.auto_awesome),
                          label: const Text('Recommend'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: const Color(0xFF1C8A99),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (viewModel.isLoading) ...[
                const SizedBox(height: 12),
                const LinearProgressIndicator(),
              ],
            ],
          ),
        ),

        const SizedBox(height: 16),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Recommended gifts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        /// PRODUCTS
        Expanded(
          child: Builder(
            builder: (context) {
              if (viewModel.isLoading && viewModel.gifts.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (viewModel.errorMessage != null && viewModel.gifts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Failed to load gifts.'),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(giftRecommendationViewModelProvider)
                            .loadInitial(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (!viewModel.isLoading && viewModel.gifts.isEmpty) {
                return const Center(
                  child: Text('No gifts found. Try different inputs.'),
                );
              }

              final gifts = viewModel.gifts;
              final itemCount =
                  gifts.length + (viewModel.isLoadingMore ? 1 : 0);

              return GridView.builder(
                controller: _gridController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                padding: const EdgeInsets.all(16),
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  if (index >= gifts.length) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final gift = gifts[index];
                  final isFavorite = _favoriteGifts.containsKey(gift.id);
                  return ProductCard(
                    imageUrl: gift.resolvedImageUrl,
                    title: gift.name,
                    rating: gift.rating,
                    price: gift.price,
                    tag: gift.tagLabel,
                    giftId: gift.id,
                    isFavorite: isFavorite,
                    onFavorite: () {
                      setState(() {
                        if (isFavorite) {
                          _favoriteGifts.remove(gift.id);
                        } else {
                          _favoriteGifts[gift.id] = gift;
                        }
                      });
                    },
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              GiftDetailScreen(giftId: gift.id),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildHome(),
      const CartScreen(),
      AboutScreen(favorites: _favoriteGifts.values.toList()),
      const ProfileScreen(),
    ];

    final backgroundColor = _currentIndex == 0
        ? const Color.fromARGB(255, 65, 148, 226)
        : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 138, 153),
        elevation: 0,
        title: Text(
          'Giftly',
          style: GoogleFonts.pacifico(fontSize: 32, color: Colors.brown[800]),
        ),
      ),

      body: screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
