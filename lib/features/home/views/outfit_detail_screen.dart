import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../models/outfit_model.dart';
import '../models/product_model.dart';

class OutfitDetailScreen extends StatelessWidget {
  final Outfit outfit;

  const OutfitDetailScreen({Key? key, required this.outfit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // We provide the BLoC again for this screen to fetch details
    return BlocProvider.value( // Use BlocProvider.value to reuse existing BLoC
      value: BlocProvider.of<HomeBloc>(context)..add(LoadOutfitDetailsEvent(outfit)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(outfit.name),
          backgroundColor: const Color(0xFFF0F0F0),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: const Color(0xFFF0F0F0),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoadingDetails) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeOutfitDetailsLoaded) {
              final products = state.products;
              // Calculate total price for display
              double totalPrice = products.fold(0.0, (sum, item) => sum + item.price);

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Outfit Main Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              outfit.imageUrl,
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                'assets/images/placeholder_outfit.png',
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            outfit.name,
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            outfit.description,
                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Outfit Components:',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return ProductComponentCard(product: product);
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  // Bottom sticky add to cart bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Price:',
                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
                            ),
                            Text(
                              '£${totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Add outfit to cart logic
                            // This will be handled by the CartBloc
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Added ${outfit.name} to cart!')),
                            );
                          },
                          icon: const Icon(HugeIcons.strokeRoundedShoppingCart01, color: Colors.white),
                          label: const Text(
                            'Add to Cart',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // Dark button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is HomeError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Select an outfit to see details.'));
          },
        ),
      ),
    );
  }
}

// Widget for displaying individual product components in OutfitDetailScreen
class ProductComponentCard extends StatelessWidget {
  final Product product;

  const ProductComponentCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.imageUrl,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/placeholder_product.png', // Placeholder on error
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Category: ${product.category}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '£${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
            // TODO: Add selection for size/color if this screen allows it, or do it in cart
            // For now, assume selection happens on "Add to Cart" or in cart screen
          ],
        ),
      ),
    );
  }
}