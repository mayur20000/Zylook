import 'package:cloud_firestore/cloud_firestore.dart';

class Outfit {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> tags;
  final List<DocumentReference> productRefs; // Reference to product documents
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Outfit({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.tags,
    required this.productRefs,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Outfit.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Outfit(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      productRefs: (data['productRefs'] as List?)
          ?.map((ref) => ref as DocumentReference)
          .toList() ??
          [],
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'tags': tags,
      'productRefs': productRefs,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

// Method to calculate total price (will need product data from Firestore)
// This will be handled in the BLoC or service layer for efficiency
// double calculateTotalPrice(List<Product> productsInOutfit) {
//   double totalPrice = 0.0;
//   for (var product in productsInOutfit) {
//     totalPrice += product.price;
//   }
//   return totalPrice;
// }
}