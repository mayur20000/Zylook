import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/models/outfit_model.dart';
import '../../home/models/product_model.dart';
import '../models/cart_item_model.dart';
import '../services/cart_service.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartService _cartService;
  StreamSubscription? _cartSubscription;

  CartBloc({required CartService cartService})
      : _cartService = cartService,
        super(CartLoading()) {
    on<LoadCartItems>((event, emit) async {
      _cartSubscription?.cancel();
      _cartSubscription = _cartService.getCartItems().listen(
            (cartItems) {
          double totalPrice = cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
          add(CartItemsUpdated(cartItems, totalPrice));
        },
        onError: (error) {
          add(CartErrorEvent('Failed to load cart: $error'));
        },
      );
    });

    on<CartItemsUpdated>((event, emit) {
      emit(CartLoaded(event.cartItems, event.totalPrice));
    });

    on<AddOutfitToCart>((event, emit) async {
      if (state is CartLoaded) {
        final currentState = state as CartLoaded;
        // Optionally show loading state briefly or handle success/error via SnackBar
        // emit(CartLoading()); // Might cause flickering, consider optimistics updates or just a SnackBar
      }
      try {
        // Here, you'd typically get the selected size/color from the OutfitDetailScreen
        // For simplicity, we're passing placeholders.
        await _cartService.addOutfitToCart(
            event.outfit, event.productsInOutfit, 'M', 'Default');
        // The stream listener will automatically trigger a CartItemsUpdated event
      } catch (e) {
        emit(CartError('Failed to add outfit to cart: $e'));
      }
    });

    on<RemoveCartItem>((event, emit) async {
      try {
        await _cartService.removeCartItem(event.cartItemId);
        // The stream listener will automatically trigger a CartItemsUpdated event
      } catch (e) {
        emit(CartError('Failed to remove item from cart: $e'));
      }
    });

    on<UpdateCartItemQuantity>((event, emit) async {
      try {
        await _cartService.updateCartItemQuantity(event.cartItemId, event.newQuantity);
        // The stream listener will automatically trigger a CartItemsUpdated event
      } catch (e) {
        emit(CartError('Failed to update item quantity: $e'));
      }
    });

    on<RemoveProductFromOutfitInCart>((event, emit) async {
      try {
        await _cartService.removeProductFromOutfitInCart(event.cartItemId, event.productId);
        // The stream listener will automatically trigger a CartItemsUpdated event
      } catch (e) {
        emit(CartError('Failed to remove product from outfit: $e'));
      }
    });

    on<CartErrorEvent>((event, emit) {
      emit(CartError(event.message));
    });
  }

  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    return super.close();
  }
}