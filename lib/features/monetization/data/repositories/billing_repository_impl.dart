import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:injectable/injectable.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/billing_repository.dart';

@LazySingleton(as: IBillingRepository)
class BillingRepositoryImpl implements IBillingRepository {
  Razorpay? _razorpay;
  StreamSubscription<List<PurchaseDetails>>? _iapSubscription;

  Completer<Either<Failure, void>>? _pendingCompleter;

  BillingRepositoryImpl() {
    _initIAP();
  }

  void _initIAP() {
    final purchaseStream = InAppPurchase.instance.purchaseStream;
    _iapSubscription = purchaseStream.listen(_handlePurchaseUpdate);
  }

  void _handlePurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        InAppPurchase.instance.completePurchase(purchase);
        _pendingCompleter?.complete(const Right(null));
        _pendingCompleter = null;
      } else if (purchase.status == PurchaseStatus.error) {
        _pendingCompleter?.complete(
          Left(ServerFailure(purchase.error?.message ?? 'Purchase failed')),
        );
        _pendingCompleter = null;
      }
    }
  }

  @override
  Future<Either<Failure, void>> purchasePremium({
    required PaymentMethod method,
    String? productId,
  }) async {
    try {
      if (method == PaymentMethod.razorpay) {
        return _purchaseViaRazorpay();
      } else {
        return _purchaseViaIAP(productId ?? 'tether_plus_monthly');
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> _purchaseViaIAP(String productId) async {
    final available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      return const Left(ServerFailure('In-App Purchase not available on this device.'));
    }

    final response = await InAppPurchase.instance.queryProductDetails({productId});
    if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
      return Left(ServerFailure('Product "$productId" not found in store.'));
    }

    final purchaseParam = PurchaseParam(
      productDetails: response.productDetails.first,
    );

    _pendingCompleter = Completer<Either<Failure, void>>();
    await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);

    // Await result from stream listener with a timeout
    return _pendingCompleter!.future.timeout(
      const Duration(minutes: 2),
      onTimeout: () => const Left(ServerFailure('Purchase timed out. Please try again.')),
    );
  }

  Future<Either<Failure, void>> _purchaseViaRazorpay() async {
    _razorpay ??= Razorpay();

    final completer = Completer<Either<Failure, void>>();

    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
      completer.complete(const Right(null));
    });

    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
      completer.complete(Left(ServerFailure(response.message ?? 'Razorpay payment failed.')));
    });

    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse response) {
      completer.complete(const Right(null)); // treat external wallet as success
    });

    final options = {
      'key': 'YOUR_RAZORPAY_KEY_ID', // Replace with actual key from env
      'amount': 49900, // Amount in paise (₹499)
      'name': 'Tether Plus',
      'description': 'Monthly Premium Subscription',
      'prefill': {'contact': '', 'email': ''},
    };

    _razorpay!.open(options);
    return completer.future;
  }

  @override
  void dispose() {
    _iapSubscription?.cancel();
    _razorpay?.clear();
  }
}
