import 'package:equatable/equatable.dart';
import '../models/outfit_model.dart';
import '../models/product_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Outfit> outfits;
  final Map<String, double> outfitPrices; // Map outfitId to its calculated price
  final Map<String, List<Product>> outfitProducts; // Map outfitId to its component products

  const HomeLoaded({
    required this.outfits,
    required this.outfitPrices,
    required this.outfitProducts,
  });

  @override
  List<Object?> get props => [outfits, outfitPrices, outfitProducts];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

// New states for outfit details screen
class HomeLoadingDetails extends HomeState {}

class HomeOutfitDetailsLoaded extends HomeState {
  final Outfit outfit;
  final List<Product> products; // Products contained in this specific outfit

  const HomeOutfitDetailsLoaded(this.outfit, this.products);

  @override
  List<Object?> get props => [outfit, products];
}