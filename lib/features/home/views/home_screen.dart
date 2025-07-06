import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:hugeicons/hugeicons.dart';
import '../widgets/custom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Mock data for curated clothing combos
  final List<Map<String, dynamic>> outfits = const [
    {
      'name': 'Casual Summer Combo',
      'description': 'Lightweight shirt and shorts for sunny days.',
      'price': 49.99,
      'image': 'assets/images/outfit1.jpg',
    },
    {
      'name': 'Formal Evening Look',
      'description': 'Elegant blazer and trousers for events.',
      'price': 89.99,
      'image': 'assets/images/outfit2.jpg',
    },
    {
      'name': 'Sporty Streetwear',
      'description': 'Comfy hoodie and joggers for active days.',
      'price': 69.99,
      'image': 'assets/images/outfit3.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8F4F0), Color(0xFFDDD0C8), Color(0xFFDDD0C8)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Lottie.asset(
                'assets/animations/home_header.json',
                width: 200,
                height: 200,
                frameRate: FrameRate(30),
              ),
              const Text(
                'Curated Clothing Combos',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  itemCount: outfits.length,
                  itemBuilder: (context, index) {
                    final outfit = outfits[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.asset(
                              outfit['image'],
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  outfit['name'],
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  outfit['description'],
                                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${outfit['price'].toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Added ${outfit['name']} to favorites')),
                                        );
                                      },
                                      icon: const Icon(HugeIcons.strokeRoundedHeartAdd  , color: Colors.red),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Added ${outfit['name']} to cart')),
                                        );
                                      },
                                      icon: const Icon(HugeIcons.strokeRoundedShoppingCart01, color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavBar(),
    );
  }
}