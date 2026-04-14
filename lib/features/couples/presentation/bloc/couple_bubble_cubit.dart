import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/subscription/subscription_service.dart';
import '../../domain/entities/couple_bubble.dart';
import '../../domain/entities/digital_hug.dart';
import '../../domain/entities/heartbeat.dart';
import '../../domain/repositories/couples_repository.dart';
import 'couple_bubble_state.dart';

@injectable
class CoupleBubbleCubit extends Cubit<CoupleBubbleState> {
  final ICouplesRepository _couplesRepository;
  final SupabaseClient _supabaseClient;
  final ISubscriptionService _subscriptionService;
  StreamSubscription? _hugsSubscription;
  StreamSubscription? _heartbeatsSubscription;

  CoupleBubbleCubit(
    this._couplesRepository,
    this._supabaseClient,
    this._subscriptionService,
  ) : super(CoupleBubbleInitial());

  Future<void> loadBubble(String circleId) async {
    emit(CoupleBubbleLoading());

    final isEntitled = await _subscriptionService.checkEntitlement('couples_features');
    if (!isEntitled) {
      emit(const CoupleBubbleError('Tether Plus required to access Couple Bubbles.'));
      return;
    }

    final result = await _couplesRepository.getCoupleBubble(circleId);
    result.fold(
      (failure) => emit(CoupleBubbleError(failure.message)),
      (bubble) {
        emit(CoupleBubbleLoaded(bubble: bubble));
        _subscribeToInteractions(circleId);
      },
    );
  }

  void _subscribeToInteractions(String circleId) {
    _hugsSubscription?.cancel();
    _hugsSubscription = _couplesRepository.streamDigitalHugs(circleId).listen((hug) {
      if (hug.senderId != _supabaseClient.auth.currentUser?.id) {
        emit(InteractionReceived(hug));
      }
    });

    _heartbeatsSubscription?.cancel();
    _heartbeatsSubscription = _couplesRepository.streamHeartbeats(circleId).listen((heartbeat) {
      if (heartbeat.senderId != _supabaseClient.auth.currentUser?.id) {
        emit(InteractionReceived(heartbeat));
      }
    });
  }

  Future<void> sendDigitalHug(String circleId, String receiverId) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return;

    final hug = DigitalHugEntity(
      id: '',
      senderId: userId,
      receiverId: receiverId,
      circleId: circleId,
      sentAt: DateTime.now(),
    );

    await _couplesRepository.sendDigitalHug(hug);
  }

  Future<void> sendHeartbeat(String receiverId) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return;

    final heartbeat = HeartbeatEntity(
      id: '',
      senderId: userId,
      receiverId: receiverId,
      sentAt: DateTime.now(),
    );

    await _couplesRepository.sendHeartbeat(heartbeat);
  }

  @override
  Future<void> close() {
    _hugsSubscription?.cancel();
    _heartbeatsSubscription?.cancel();
    return super.close();
  }
}
