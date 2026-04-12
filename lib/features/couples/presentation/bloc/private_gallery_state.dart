import 'package:equatable/equatable.dart';
import '../../domain/entities/gallery_item.dart';

abstract class PrivateGalleryState extends Equatable {
  const PrivateGalleryState();

  @override
  List<Object?> get props => [];
}

class PrivateGalleryInitial extends PrivateGalleryState {}

class PrivateGalleryLoading extends PrivateGalleryState {}

class PrivateGalleryLoaded extends PrivateGalleryState {
  final List<GalleryItemEntity> items;

  const PrivateGalleryLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class PrivateGalleryError extends PrivateGalleryState {
  final String message;

  const PrivateGalleryError(this.message);

  @override
  List<Object?> get props => [message];
}

class GalleryItemUploaded extends PrivateGalleryState {}
