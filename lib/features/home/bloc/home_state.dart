import 'package:equatable/equatable.dart';
import '../models/outfit_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Outfit> outfits;

  const HomeLoaded(this.outfits);

  @override
  List<Object?> get props => [outfits];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}