import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../models/outfit_model.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadOutfitsEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        // Mock data (replace with Firestore or API call later)
        final List<Outfit> outfits = [
          Outfit(
            name: 'Casual Summer Combo',
            description: 'Lightweight shirt and shorts for sunny days.',
            price: 49.99,
            imageUrl: 'assets/images/outfit1.png',
          ),
          Outfit(
            name: 'Formal Evening Look',
            description: 'Elegant blazer and trousers for events.',
            price: 89.99,
            imageUrl: 'assets/images/outfit2.png',
          ),
          Outfit(
            name: 'Sporty Streetwear',
            description: 'Comfy hoodie and joggers for active days.',
            price: 69.99,
            imageUrl: 'assets/images/outfit3.png',
          ),
        ];
        emit(HomeLoaded(outfits));
      } catch (e) {
        emit(HomeError('Failed to load outfits: $e'));
      }
    });
  }
}