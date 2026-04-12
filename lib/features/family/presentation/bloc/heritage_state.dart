import 'package:equatable/equatable.dart';
import '../../domain/entities/heritage_item.dart';

abstract class HeritageState extends Equatable {
  const HeritageState();

  @override
  List<Object?> get props => [];
}

class HeritageInitial extends HeritageState {}

class HeritageLoading extends HeritageState {}

class HeritageLoaded extends HeritageState {
  final List<HeritageItemEntity> items;

  const HeritageLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class HeritageError extends HeritageState {
  final String message;

  const HeritageError(this.message);

  @override
  List<Object?> get props => [message];
}

class HeritageItemUploaded extends HeritageState {}
