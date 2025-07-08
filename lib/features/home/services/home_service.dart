// lib/features/home/services/home_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/outfit_model.dart';
import '../models/product_model.dart'; // Make sure this import is correct

class HomeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetches a list of outfits (your existing method)
  Future<List<Outfit>> getOutfits() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('outfits').get();
      return snapshot.docs
          .map((doc) => Outfit.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting outfits: $e');
      rethrow;
    }
  }

  // NEW: Fetches a list of all products
  Future<List<Product>> getProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();
      return snapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting products: $e');
      rethrow;
    }
  }

  // Fetches a single product by its DocumentReference (your existing method)
  Future<Product> getProductByRef(DocumentReference productRef) async {
    try {
      DocumentSnapshot doc = await productRef.get();
      if (doc.exists) {
        return Product.fromFirestore(doc);
      } else {
        throw Exception('Product not found: ${productRef.id}');
      }
    } catch (e) {
      print('Error getting product by ref: $e');
      rethrow;
    }
  }

  // Fetches all products within a specific outfit (your existing method)
  Future<List<Product>> getProductsForOutfit(Outfit outfit) async {
    try {
      List<Product> products = [];
      for (var ref in outfit.productRefs) {
        products.add(await getProductByRef(ref));
      }
      return products;
    } catch (e) {
      print('Error getting products for outfit ${outfit.id}: $e');
      rethrow;
    }
  }
}