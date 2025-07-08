// lib/features/home/models/product_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final List<String> availableSizes;
  final List<String> availableColors;
  final String category;
  final String brand;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.availableSizes,
    required this.availableColors,
    required this.category,
    required this.brand,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a Product from a Firestore DocumentSnapshot
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0, // Handle int/double from Firestore
      availableSizes: List<String>.from(data['availableSizes'] ?? []),
      availableColors: List<String>.from(data['availableColors'] ?? []),
      category: data['category'] ?? '',
      brand: data['brand'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }

  // Method to convert a Product object to a Firestore map (useful for adding/updating)
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'availableSizes': availableSizes,
      'availableColors': availableColors,
      'category': category,
      'brand': brand,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}