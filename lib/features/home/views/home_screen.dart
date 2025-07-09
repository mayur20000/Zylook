import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../models/outfit_model.dart';
import 'outfit_detail_screen.dart'; // Keep this import

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // ... (Your existing AppBar, Search Bar, Discount Banner, Categories sections) ...
          // These remain the same as they are part of the HomeScreen's content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(HugeIcons.strokeRoundedQrCode01, color: Color(0xFF5B6056), size: 28),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Delivery address',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '92 High Street, London',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down, size: 20),
                        ],
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(HugeIcons.strokeRoundedNotification01, color: Color(0xFF5B6056), size: 28),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent[400],
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search the entire shop',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Text(
                    'Delivery is ',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87),
                  ),
                  const Text(
                    '50% ',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const Text(
                    'cheaper',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87),
                  ),
                  const Spacer(),
                  Image.asset(
                    'assets/images/delivery_promo.jpg', // Ensure this asset exists
                    height: 40,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('See All Categories')));
                  },
                  child: const Row(
                    children: [
                      Text('See all', style: TextStyle(color: Colors.grey)),
                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100, // Height for horizontal category circles
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: 6, // Example: 6 categories
              itemBuilder: (context, index) {
                final categories = [
                  {'name': 'Phones', 'icon': HugeIcons.strokeRoundedSmartPhone01},
                  {'name': 'Consoles', 'icon': HugeIcons.strokeRoundedGame},
                  {'name': 'Laptops', 'icon': HugeIcons.strokeRoundedLaptop},
                  {'name': 'Cameras', 'icon': HugeIcons.strokeRoundedCamera01},
                  {'name': 'Audio', 'icon': HugeIcons.strokeRoundedHeadphones},
                  {'name': 'Wearables', 'icon': HugeIcons.strokeRoundedSmartWatch01},
                ];
                final category = categories[index % categories.length];
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(category['icon'] as IconData, size: 30, color: const Color(0xFF5B6056)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['name'] as String,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Flash Sale Section (Outfits)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Flash Sale',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.yellow[600],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    '02:59:23',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('See All Flash Sales')));
                  },
                  child: const Row(
                    children: [
                      Text('See all', style: TextStyle(color: Colors.grey)),
                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HomeLoaded) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: state.outfits.length,
                    itemBuilder: (context, index) {
                      final outfit = state.outfits[index];
                      final outfitPrice = state.outfitPrices[outfit.id] ?? 0.0;
                      final oldOutfitPrice = outfitPrice * 1.25;

                      return FlashSaleOutfitCard(
                        outfit: outfit,
                        currentPrice: outfitPrice,
                        oldPrice: oldOutfitPrice,
                        onTap: () {
                          // Crucial Change: Use Navigator.of(context) (which is the current tab's navigator)
                          // to push the OutfitDetailScreen. This keeps it within the Home tab's stack.
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (detailContext) => OutfitDetailScreen(outfit: outfit),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is HomeError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text('No Flash Sale outfits available'));
              },
            ),
          ),
        ],
      ),
    );
  }
}

// FlashSaleOutfitCard remains unchanged
class FlashSaleOutfitCard extends StatelessWidget {
  final Outfit outfit;
  final double currentPrice;
  final double oldPrice;
  final VoidCallback onTap;

  const FlashSaleOutfitCard({
    Key? key,
    required this.outfit,
    required this.currentPrice,
    required this.oldPrice,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(right: 16.0),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    outfit.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/placeholder_outfit.png',
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border, size: 24, color: Colors.grey),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Added ${outfit.name} to favorites')),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      outfit.name,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '£${currentPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '£${oldPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
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
}