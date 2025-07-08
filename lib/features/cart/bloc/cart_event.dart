import 'package:equatable/equatable.dart';
import '../../home/models/outfit_model.dart';
import '../../home/models/product_model.dart';
import '../models/cart_item_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCartItems extends CartEvent {}

class CartItemsUpdated extends CartEvent {
  final List<CartItem> cartItems;
  final double totalPrice;
  const CartItemsUpdated(this.cartItems, this.totalPrice);

  @override
  List<Object?> get props => [cartItems, totalPrice];
}

class AddOutfitToCart extends CartEvent {
  final Outfit outfit;
  final List<Product> productsInOutfit; // To know what products are part of the outfit for saving
  // You might also pass selected size/color here
  const AddOutfitToCart(this.outfit, this.productsInOutfit);

  @override
  List<Object?> get props => [outfit, productsInOutfit];
}

class RemoveCartItem extends CartEvent {
  final String cartItemId;
  const RemoveCartItem(this.cartItemId);

  @override
  List<Object?> get props => [cartItemId];
}

class UpdateCartItemQuantity extends CartEvent {
  final String cartItemId;
  final int newQuantity;
  const UpdateCartItemQuantity(this.cartItemId, this.newQuantity);

  @override
  List<Object?> get props => [cartItemId, newQuantity];
}

class RemoveProductFromOutfitInCart extends CartEvent {
  final String cartItemId; // The ID of the parent outfit/cart item
  final String productId; // The ID of the product to remove
  const RemoveProductFromOutfitInCart(this.cartItemId, this.productId);

  @override
  List<Object?> get props => [cartItemId, productId];
}

class CartErrorEvent extends CartEvent {
  final String message;
  const CartErrorEvent(this.message);

  @override
  List<Object?> get props => [message];
}