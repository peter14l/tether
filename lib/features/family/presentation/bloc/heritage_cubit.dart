import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/heritage_item.dart';
import '../../domain/repositories/heritage_repository.dart';
import 'heritage_state.dart';

@injectable
class HeritageCubit extends Cubit<HeritageState> {
  final IHeritageRepository _heritageRepository;
  final SupabaseClient _supabaseClient;

  HeritageCubit(this._heritageRepository, this._supabaseClient) : super(HeritageInitial());

  Future<void> loadItems(String circleId) async {
    emit(HeritageLoading());
    final result = await _heritageRepository.getHeritageItems(circleId);
    result.fold(
      (failure) => emit(HeritageError(failure.message)),
      (items) => emit(HeritageLoaded(items)),
    );
  }

  Future<void> uploadItem({
    required String circleId,
    required File file,
    String? caption,
    String? eraLabel,
  }) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return;

    emit(HeritageLoading());
    final item = HeritageItemEntity(
      id: '',
      circleId: circleId,
      uploadedBy: userId,
      mediaUrl: '', // Will be set by repo
      caption: caption,
      eraLabel: eraLabel,
      createdAt: DateTime.now(),
    );

    final result = await _heritageRepository.uploadHeritageItem(item, file);
    result.fold(
      (failure) => emit(HeritageError(failure.message)),
      (_) {
        emit(HeritageItemUploaded());
        loadItems(circleId);
      },
    );
  }
}
