import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../home/models/outfit_model.dart';
import '../../home/models/product_model.dart';
import '../models/cart_item_model.dart';
import '../../home/services/home_service.dart'; // Re-use HomeService for product fetching

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final HomeService _homeService = HomeService(); // To fetch product details

  String? get currentUserId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _userCartCollection() {
    if (currentUserId == null) {
      throw Exception('User not logged in');
    }
    return _firestore.collection('users').doc(currentUserId).collection('cart');
  }

  // Add an outfit to the cart
  Future<void> addOutfitToCart(Outfit outfit, List<Product> productsInOutfit, String selectedSize, String selectedColor) async {
    if (currentUserId == null) return;

    List<Map<String, dynamic>> itemsData = productsInOutfit.map((p) => {
      'productId': p.id,
      'selectedSize': selectedSize, // Assuming one size/color for the whole outfit initially
      'selectedColor': selectedColor, // User can change in cart screen later
      'quantity': 1, // Each component is quantity 1 within the outfit
    }).toList();

    await _userCartCollection().add({
      'type': 'outfit',
      'outfitRef': _firestore.collection('outfits').doc(outfit.id),
      'items': itemsData,
      'quantity': 1, // Initial quantity of the outfit
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get user's cart items
  Stream<List<CartItem>> getCartItems() {
    if (currentUserId == null) {
      // Return an empty stream or handle unauthenticated state
      return Stream.value([]);
    }
    return _userCartCollection().orderBy('addedAt', descending: true).snapshots().asyncMap((snapshot) async {
      List<CartItem> cartItems = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();

        // Fetch outfit if applicable
        Outfit? outfit;
        if (data['type'] == 'outfit' && data['outfitRef'] != null) {
          DocumentReference outfitRef = data['outfitRef'];
          try {
            DocumentSnapshot outfitDoc = await outfitRef.get();
            if (outfitDoc.exists) {
              outfit = Outfit.fromFirestore(outfitDoc);
            }
          } catch (e) {
            print('Error fetching outfit for cart item: $e');
          }
        }

        // Fetch product details for each item in the outfit/cart item
        List<CartProductItem> productsInCartItem = [];
        if (data['items'] is List) {
          for (var itemData in data['items']) {
            if (itemData['productId'] != null) {
              try {
                // Ensure productId is string, not DocumentReference here for HomeService
                final productId = itemData['productId'] is DocumentReference
                    ? (itemData['productId'] as DocumentReference).id
                    : itemData['productId'] as String;

                final product = await _homeService.getProductByRef(_firestore.collection('products').doc(productId));
                productsInCartItem.add(CartProductItem.fromFirestore(itemData, product));
              } catch (e) {
                print('Error fetching product for cart item component: $e');
              }
            }
          }
        }

        cartItems.add(CartItem(
          id: doc.id,
          type: data['type'] ?? 'single_product',
          outfit: outfit,
          items: productsInCartItem,
          quantity: data['quantity'] ?? 1,
          addedAt: data['addedAt'] ?? Timestamp.now(),
        ));
      }
      return cartItems;
    });
  }

  // Update quantity of an overall cart item (outfit or single product)
  Future<void> updateCartItemQuantity(String cartItemId, int newQuantity) async {
    if (currentUserId == null) return;
    if (newQuantity <= 0) {
      await removeCartItem(cartItemId);
    } else {
      await _userCartCollection().doc(cartItemId).update({'quantity': newQuantity});
    }
  }

  // Remove a cart item (an outfit or single product)
  Future<void> removeCartItem(String cartItemId) async {
    if (currentUserId == null) return;
    await _userCartCollection().doc(cartItemId).delete();
  }

  // Remove a specific product from an outfit within the cart
  Future<void> removeProductFromOutfitInCart(String cartItemId, String productIdToRemove) async {
    if (currentUserId == null) return;

    DocumentSnapshot cartDoc = await _userCartCollection().doc(cartItemId).get();
    if (cartDoc.exists) {
      Map<String, dynamic> data = cartDoc.data() as Map<String, dynamic>;
      List<dynamic> items = List.from(data['items'] ?? []);

      items.removeWhere((item) => item['productId'] == productIdToRemove);

      await _userCartCollection().doc(cartItemId).update({'items': items});
    }
  }
}