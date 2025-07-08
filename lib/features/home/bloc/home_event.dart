import 'package:equatable/equatable.dart';
import '../models/outfit_model.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadOutfitsEvent extends HomeEvent {}

// New event to load details for a specific outfit
class LoadOutfitDetailsEvent extends HomeEvent {
  final Outfit outfit;
  const LoadOutfitDetailsEvent(this.outfit);

  @override
  List<Object?> get props => [outfit];
}