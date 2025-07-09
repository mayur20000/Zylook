import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for DocumentReference

import '../models/outfit_model.dart';
import '../models/product_model.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../services/home_service.dart'; // Import the new service

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeService _homeService = HomeService(); // Instantiate the service

  HomeBloc({required HomeService homeService}) : super(HomeInitial()) {
    on<LoadOutfitsEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        final List<Outfit> outfits = await _homeService.getOutfits();
        // For each outfit, fetch its component products to calculate total price
        // This is simplified; in a real app, you might fetch products only when needed
        // or pre-calculate outfit price on creation/update.
        Map<String, List<Product>> outfitProductsMap = {};
        Map<String, double> outfitPricesMap = {};

        for (var outfit in outfits) {
          final productsInOutfit = await _homeService.getProductsForOutfit(outfit);
          outfitProductsMap[outfit.id] = productsInOutfit;

          double totalPrice = 0.0;
          for (var product in productsInOutfit) {
            totalPrice += product.price;
          }
          outfitPricesMap[outfit.id] = totalPrice;
        }

        emit(HomeLoaded(
          outfits: outfits,
          outfitPrices: outfitPricesMap,
          outfitProducts: outfitProductsMap, // Pass product details for outfit view
        ));
      } catch (e) {
        emit(HomeError('Failed to load outfits: $e'));
      }
    });

    on<LoadOutfitDetailsEvent>((event, emit) async {
      emit(HomeLoadingDetails()); // A new state for loading details
      try {
        final productsInOutfit = await _homeService.getProductsForOutfit(event.outfit);
        emit(HomeOutfitDetailsLoaded(event.outfit, productsInOutfit));
      } catch (e) {
        emit(HomeError('Failed to load outfit details: $e'));
      }
    });
  }
}