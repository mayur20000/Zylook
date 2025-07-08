import 'package:equatable/equatable.dart';
import '../models/cart_item_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;
  final double totalPrice;
  const CartLoaded(this.cartItems, this.totalPrice);

  @override
  List<Object?> get props => [cartItems, totalPrice];
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}