import 'package:flutter/material.dart';
import 'package:giftly/wedgets/product_card.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Giftly',
          style: GoogleFonts.pacifico(
            fontSize: 32,
            color: Colors.brown[800],
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              radius: 20,
              child: Icon(Icons.person, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(Icons.search, color: Colors.black54),
                  ),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(Icons.menu, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: true,
                  backgroundColor: Colors.transparent,
                  selectedColor: Theme.of(context).primaryColor,
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (bool selected) {},
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Event'),
                  selected: false,
                  backgroundColor: Colors.transparent,
                  labelStyle: const TextStyle(color: Colors.black87),
                  onSelected: (bool selected) {},
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Age'),
                  selected: false,
                  backgroundColor: Colors.transparent,
                  labelStyle: const TextStyle(color: Colors.black87),
                  onSelected: (bool selected) {},
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Gender'),
                  selected: false,
                  backgroundColor: Colors.transparent,
                  labelStyle: const TextStyle(color: Colors.black87),
                  onSelected: (bool selected) {},
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: const [
                ProductCard(
                  image: 'images/rose_bouquet.jpg',
                  title: 'Rose Bouquets',
                  rating: 4.1,
                ),
                ProductCard(
                  image: 'images/watch.jpg',
                  title: 'Gents Watch',
                  rating: 4.5,
                ),
                ProductCard(
                  image: 'images/wallet.jpg',
                  title: 'Wallet',
                  rating: 4.2,
                ),
                ProductCard(
                  image: 'images/perfume.jpg',
                  title: 'Perfume\'s set',
                  rating: 3.9,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        height: 60,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.white),
              onPressed: () {},
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
