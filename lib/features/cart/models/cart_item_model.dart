import 'package:cloud_firestore/cloud_firestore.dart';
import '../../home/models/outfit_model.dart'; // Import Outfit model
import '../../home/models/product_model.dart'; // Import Product model

class CartProductItem {
  final Product product; // Full product data
  final String selectedSize;
  final String selectedColor;
  int quantity; // Quantity of this specific product within the cart item

  CartProductItem({
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
    this.quantity = 1,
  });

  // To Firestore for saving in user's cart
  Map<String, dynamic> toFirestore() {
    return {
      'productId': product.id, // Store ID, not DocumentReference, for simpler retrieval
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
      'quantity': quantity,
    };
  }

  // From Firestore (will require fetching product details separately)
  factory CartProductItem.fromFirestore(Map<String, dynamic> data, Product product) {
    return CartProductItem(
      product: product, // Product object needs to be resolved from ID
      selectedSize: data['selectedSize'] ?? '',
      selectedColor: data['selectedColor'] ?? '',
      quantity: data['quantity'] ?? 1,
    );
  }

  // For updating quantity in cart
  CartProductItem copyWith({
    int? quantity,
  }) {
    return CartProductItem(
      product: product,
      selectedSize: selectedSize,
      selectedColor: selectedColor,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartItem {
  final String id; // Cart item ID (from Firestore document)
  final String type; // "outfit" or "single_product"
  final Outfit? outfit; // If type is "outfit"
  final List<CartProductItem> items; // List of products/components in this cart item
  int quantity; // Quantity of this specific cart item (e.g., 2 of the "Weekend Wanderer" outfit)
  final Timestamp addedAt;

  CartItem({
    required this.id,
    required this.type,
    this.outfit,
    required this.items,
    this.quantity = 1,
    required this.addedAt,
  });

  // Calculate total price of this cart item based on current selected products
  double get totalPrice {
    return items.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  // Convert to Firestore data for saving
  Map<String, dynamic> toFirestore() {
    return {
      'type': type,
      'outfitRef': outfit?.id != null ? FirebaseFirestore.instance.collection('outfits').doc(outfit!.id) : null,
      'items': items.map((item) => item.toFirestore()).toList(),
      'quantity': quantity,
      'addedAt': addedAt,
    };
  }

  // For updating quantity of the overall cart item
  CartItem copyWith({
    int? quantity,
    List<CartProductItem>? items,
  }) {
    return CartItem(
      id: id,
      type: type,
      outfit: outfit,
      items: items ?? this.items,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt,
    );
  }
}