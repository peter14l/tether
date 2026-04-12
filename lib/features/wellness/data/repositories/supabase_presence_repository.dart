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
    channel.on(RealtimeListenTypes.presence, (event) {
      controller.add(channel.presenceState());
    }).subscribe((status, [error]) async {
      if (status == RealtimeStatus.subscribed) {
        await channel.track({
          'user_id': _client.auth.currentUser?.id,
          'online_at': DateTime.now().toIso8601String(),
        });
      }
    });

    return controller.stream;
  }
}
