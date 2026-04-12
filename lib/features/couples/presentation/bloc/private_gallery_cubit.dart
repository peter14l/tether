import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/gallery_repository.dart';
import 'private_gallery_state.dart';

@injectable
class PrivateGalleryCubit extends Cubit<PrivateGalleryState> {
  final IGalleryRepository _galleryRepository;

  PrivateGalleryCubit(this._galleryRepository) : super(PrivateGalleryInitial());

  Future<void> loadItems(String circleId) async {
    emit(PrivateGalleryLoading());
    final result = await _galleryRepository.getGalleryItems(circleId);
    result.fold(
      (failure) => emit(PrivateGalleryError(failure.message)),
      (items) => emit(PrivateGalleryLoaded(items)),
    );
  }

  Future<void> uploadItem(String circleId, File file, {String? caption}) async {
    emit(PrivateGalleryLoading());
    final result = await _galleryRepository.uploadGalleryItem(circleId, file, caption);
    result.fold(
      (failure) => emit(PrivateGalleryError(failure.message)),
      (_) {
        emit(GalleryItemUploaded());
        loadItems(circleId);
      },
    );
  }
}
