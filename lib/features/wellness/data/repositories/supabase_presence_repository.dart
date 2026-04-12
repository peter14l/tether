import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/presence_repository.dart';

@LazySingleton(as: IPresenceRepository)
class SupabasePresenceRepository implements IPresenceRepository {
  final SupabaseClient _client;

  SupabasePresenceRepository(this._client);

  @override
  Future<Either<Failure, void>> toggleQuietMode(bool enabled) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return const Left(AuthFailure('User not logged in'));

      await _client.from('profiles').update({'is_quiet': enabled}).eq('id', userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Map<String, dynamic>> streamPresence(String circleId) {
    final channel = _client.channel('circle:$circleId');
    final controller = StreamController<Map<String, dynamic>>();
    
    // In Supabase 2.x, we track presence and use callbacks
    channel.onPresenceSync((payload) {
      if (controller.isClosed) return;
      
      final state = channel.presenceState();
      final Map<String, dynamic> mappedState = {};
      for (final s in state) {
        if (s.presences.isNotEmpty) {
          mappedState[s.key] = s.presences.first.payload;
        }
      }
      controller.add(mappedState);
    }).subscribe((status, [error]) async {
      if (status == RealtimeSubscribeStatus.subscribed) {
        final userId = _client.auth.currentUser?.id;
        if (userId != null) {
          await channel.track({
            'user_id': userId,
            'online_at': DateTime.now().toIso8601String(),
          });
        }
      }
    });

    controller.onCancel = () {
      channel.unsubscribe();
      controller.close();
    };

    return controller.stream;
  }
}
