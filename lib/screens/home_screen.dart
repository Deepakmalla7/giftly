import 'package:flutter/material.dart';
import 'package:giftly/wedgets/product_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:giftly/screens/bottom_screen/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  String selectedEvent = '';
  String selectedAge = '';
  String selectedGender = '';
  int selectedChip = 0; //

  void _openEventDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Enter Event'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Birthday, Anniversary'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                selectedEvent = controller.text;
                selectedChip = 1;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _openAgeDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Select Age Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ageTile('Kids (0-12)'),
            _ageTile('Teen (13-19)'),
            _ageTile('Adult (20-40)'),
            _ageTile('Senior (40+)'),
          ],
        ),
      ),
    );
  }

  Widget _ageTile(String age) {
    return ListTile(
      title: Text(age),
      onTap: () {
        setState(() {
          selectedAge = age;
          selectedChip = 2;
        });
        Navigator.pop(context);
      },
    );
  }

  /////
  void _openGenderDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Select Gender'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Male'),
              onTap: () {
                setState(() {
                  selectedGender = 'Male';
                  selectedChip = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Female'),
              onTap: () {
                setState(() {
                  selectedGender = 'Female';
                  selectedChip = 3;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHome() {
    return Column(
      children: [
        const SizedBox(height: 8),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              FilterChip(
                label: const Text('All'),
                selected: selectedChip == 0,
                onSelected: (_) {
                  setState(() {
                    selectedChip = 0;
                    selectedEvent = '';
                    selectedAge = '';
                    selectedGender = '';
                  });
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: Text(selectedEvent.isEmpty ? 'Event' : selectedEvent),
                selected: selectedChip == 1,
                onSelected: (_) => _openEventDialog(),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: Text(selectedAge.isEmpty ? 'Age' : selectedAge),
                selected: selectedChip == 2,
                onSelected: (_) => _openAgeDialog(),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: Text(selectedGender.isEmpty ? 'Gender' : selectedGender),
                selected: selectedChip == 3,
                onSelected: (_) => _openGenderDialog(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        /// PRODUCTS
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            padding: const EdgeInsets.all(16),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: const [
              ProductCard(
                image: 'assets/images/flowers.png',
                title: 'Rose Bouquets',
                rating: 4.1,
              ),
              ProductCard(
                image: 'assets/images/watch.png',
                title: 'Gents Watch',
                rating: 4.5,
              ),
              ProductCard(
                image: 'assets/images/wallet.png',
                title: 'Wallet',
                rating: 4.2,
              ),
              ProductCard(
                image: 'assets/images/perfume.png',
                title: 'Perfume\'s set',
                rating: 3.9,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildHome(),
      _buildPlaceholder('Cart Screen'),
      _buildPlaceholder('Profile Screen'),
      _buildPlaceholder('About Screen'),
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 65, 148, 226),
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
      ),
    );
  }
}
