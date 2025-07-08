import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart'; // Ensure hugeicons is in your pubspec.yaml

import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/custom_nav_bar.dart'; // Your custom nav bar

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadOutfitsEvent()), // Keep your outfit loading
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F0F0), // A light grey background to match the new design
        body: SafeArea(
          child: Column(
            children: [
              // Custom AppBar Section
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
                      child: const Icon(HugeIcons.strokeRoundedQrCode01, color: Color(0xFF5B6056), size: 28), // QR Code/Menu icon
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
                                '92 High Street, London', // Example address
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
                          child: const Icon(HugeIcons.strokeRoundedNotification01, color: Color(0xFF5B6056), size: 28), // Notification icon
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent[400], // Notification dot color
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

              // Search Bar
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
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search the entire shop',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Delivery Discount Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0), // Lighter grey for the banner
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
                      // You can add a subtle image or Lottie animation here if desired
                      Image.asset(
                        'assets/images/delivery_promo.png', // Placeholder image (create this asset)
                        height: 40,
                      )
                      // Lottie.asset('assets/animations/delivery_promo.json', height: 50),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Categories Section
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
                        // TODO: Navigate to All Categories screen
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
                      {'name': 'Phones', 'icon': HugeIcons.strokeRoundedSmartPhone02},
                      {'name': 'Consoles', 'icon': HugeIcons.strokeRoundedGame},
                      {'name': 'Laptops', 'icon': HugeIcons.strokeRoundedLaptop},
                      {'name': 'Cameras', 'icon': HugeIcons.strokeRoundedCamera01},
                      {'name': 'Audio', 'icon': HugeIcons.strokeRoundedHeadphones},
                      {'name': 'Wearables', 'icon': HugeIcons.strokeRoundedSmartWatch01},
                    ];
                    final category = categories[index % categories.length]; // Use modulo to loop if itemCount > categories.length
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

              // Flash Sale Section
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
                        color: Colors.yellow[600], // Flash sale timer background
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        '02:59:23', // Placeholder for countdown timer
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to All Flash Sale items
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
                      // Using ListView.builder for horizontal scrollable products
                      // This simulates the Flash Sale items
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: state.outfits.length, // Using outfits as flash sale items
                        itemBuilder: (context, index) {
                          final outfit = state.outfits[index];
                          return FlashSaleProductCard(
                            productName: outfit.name,
                            imageUrl: outfit.imageUrl, // Use your outfit images
                            currentPrice: outfit.price,
                            oldPrice: outfit.price * 1.5, // Example old price for discount
                            description: outfit.description,
                          );
                        },
                      );
                    } else if (state is HomeError) {
                      return Center(child: Text(state.message));
                    }
                    return const Center(child: Text('No Flash Sale items available'));
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const CustomNavBar(),
      ),
    );
  }
}

// Custom Widget for Flash Sale Product Cards
class FlashSaleProductCard extends StatelessWidget {
  final String productName;
  final String imageUrl;
  final double currentPrice;
  final double oldPrice;
  final String description;

  const FlashSaleProductCard({
    Key? key,
    required this.productName,
    required this.imageUrl,
    required this.currentPrice,
    required this.oldPrice,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 16.0), // Spacing between cards
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 180, // Fixed width for flash sale cards
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  imageUrl, // Using Image.asset as per your Outfit model
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
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
                          SnackBar(content: Text('Added $productName to favorites')),
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
                    productName,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '£${currentPrice.toStringAsFixed(2)}', // Using '£' for currency
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
    );
  }
}