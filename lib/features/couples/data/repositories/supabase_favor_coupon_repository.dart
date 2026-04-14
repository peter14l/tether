import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/favor_coupon.dart';
import '../../domain/repositories/favor_coupon_repository.dart';
import '../models/favor_coupon_model.dart';

@LazySingleton(as: IFavorCouponRepository)
class SupabaseFavorCouponRepository implements IFavorCouponRepository {
  final SupabaseClient _client;

  SupabaseFavorCouponRepository(this._client);

  @override
  Future<Either<Failure, List<FavorCouponEntity>>> getCircleCoupons(String circleId) async {
    try {
      final response = await _client
          .from('favor_coupons')
          .select()
          .eq('circle_id', circleId)
          .order('created_at', ascending: false);
      final coupons = (response as List).map((json) => FavorCouponModel.fromJson(json)).toList();
      return Right(coupons);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createCoupon(FavorCouponEntity coupon) async {
    try {
      final model = FavorCouponModel(
        id: coupon.id,
        circleId: coupon.circleId,
        createdBy: coupon.createdBy,
        assignedTo: coupon.assignedTo,
        description: coupon.description,
        createdAt: coupon.createdAt,
      );
      await _client.from('favor_coupons').insert(model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> redeemCoupon(String couponId) async {
    try {
      await _client.from('favor_coupons').update({
        'redeemed': true,
        'redeemed_at': DateTime.now().toIso8601String(),
      }).eq('id', couponId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<FavorCouponEntity>> streamCircleCoupons(String circleId) {
    return _client
        .from('favor_coupons')
        .stream(primaryKey: ['id'])
        .eq('circle_id', circleId)
        .map((data) => data.map((json) => FavorCouponModel.fromJson(json)).toList());
  }
}
