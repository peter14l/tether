import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/favor_coupon.dart';

abstract class IFavorCouponRepository {
  Future<Either<Failure, List<FavorCouponEntity>>> getCircleCoupons(String circleId);
  Future<Either<Failure, void>> createCoupon(FavorCouponEntity coupon);
  Future<Either<Failure, void>> redeemCoupon(String couponId);
  Stream<List<FavorCouponEntity>> streamCircleCoupons(String circleId);
}
