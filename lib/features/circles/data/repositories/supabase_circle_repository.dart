import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/circle_entity.dart';
import '../../domain/repositories/circle_repository.dart';
import '../models/circle_model.dart';

@LazySingleton(as: ICircleRepository)
class SupabaseCircleRepository implements ICircleRepository {
  final SupabaseClient _client;

  SupabaseCircleRepository(this._client);

  @override
  Future<Either<Failure, List<CircleEntity>>> getMyCircles() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return const Left(AuthFailure('User not logged in'));

      final response = await _client
          .from('circles')
          .select('*, circle_members!inner(user_id)')
          .eq('circle_members.user_id', userId);

      final circles = (response as List).map((json) => CircleModel.fromJson(json)).toList();
      return Right(circles);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CircleEntity>> createCircle(CircleEntity circle) async {
    try {
      final model = CircleModel(
        id: circle.id,
        name: circle.name,
        circleType: circle.circleType,
        createdBy: circle.createdBy,
        avatarUrl: circle.avatarUrl,
        description: circle.description,
        comfortRadius: circle.comfortRadius,
        isEncrypted: circle.isEncrypted,
        createdAt: circle.createdAt,
        updatedAt: circle.updatedAt,
      );

      final response = await _client
          .from('circles')
          .insert(model.toJson())
          .select()
          .single();

      final createdCircle = CircleModel.fromJson(response);
      
      // Also add the creator as an admin member
      await addMember(createdCircle.id, createdCircle.createdBy, 'admin');
      
      return Right(createdCircle);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addMember(String circleId, String userId, String role) async {
    try {
      await _client.from('circle_members').insert({
        'circle_id': circleId,
        'user_id': userId,
        'role': role,
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
