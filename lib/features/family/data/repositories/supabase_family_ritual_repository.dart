import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/family_ritual.dart';
import '../../domain/repositories/family_ritual_repository.dart';
import '../models/family_ritual_model.dart';

@LazySingleton(as: IFamilyRitualRepository)
class SupabaseFamilyRitualRepository implements IFamilyRitualRepository {
  final SupabaseClient _client;

  SupabaseFamilyRitualRepository(this._client);

  @override
  Future<Either<Failure, List<FamilyRitualEntity>>> getCircleRituals(String circleId) async {
    try {
      final response = await _client
          .from('family_rituals')
          .select()
          .eq('circle_id', circleId)
          .order('title', ascending: true);
      final rituals = (response as List).map((json) => FamilyRitualModel.fromJson(json)).toList();
      return Right(rituals);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createRitual(FamilyRitualEntity ritual) async {
    try {
      final model = FamilyRitualModel(
        id: ritual.id,
        circleId: ritual.circleId,
        title: ritual.title,
        type: ritual.type,
        scheduledTime: ritual.scheduledTime,
        daysActive: ritual.daysActive,
      );
      await _client.from('family_rituals').insert(model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<FamilyRitualEntity>> streamCircleRituals(String circleId) {
    return _client
        .from('family_rituals')
        .stream(primaryKey: ['id'])
        .eq('circle_id', circleId)
        .map((data) => data.map((json) => FamilyRitualModel.fromJson(json)).toList());
  }
}
