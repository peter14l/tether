import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import 'billing_method.dart';

export 'billing_method.dart';

import 'package:purchases_flutter/purchases_flutter.dart';

abstract class IBillingRepository {
  Future<void> identify(String userId);
  Future<void> reset();
  Future<Either<Failure, void>> purchasePremium({
    required PaymentMethod method,
    String? productId,
  });
  Future<Either<Failure, void>> purchasePremiumAuto({String? productId});

  Stream<CustomerInfo> get customerInfoStream;
  Future<void> showPaywall();
  Future<void> showCustomerCenter();
  Future<bool> isPro();

  void dispose();
}
