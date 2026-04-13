import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import 'billing_method.dart';

export 'billing_method.dart';

abstract class IBillingRepository {
  Future<Either<Failure, void>> purchasePremium({
    required PaymentMethod method,
    String? productId,
  });
  void dispose();
}
