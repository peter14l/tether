import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/installer_source.dart';
import '../../domain/repositories/billing_repository.dart';

@LazySingleton(as: IBillingRepository)
class BillingRepositoryImpl implements IBillingRepository {
  Razorpay? _razorpay;
  bool _isRcInitialized = false;
  final _customerInfoController = StreamController<CustomerInfo>.broadcast();

  BillingRepositoryImpl() {
    _initRevenueCat();
  }

  Future<void> _initRevenueCat() async {
    if (!EnvConfig.isRevenueCatEnabled) {
      debugPrint(
        'RevenueCat is not configured or using placeholder keys. Skipping initialization.',
      );
      return;
    }

    try {
      String apiKey = '';
      if (Platform.isAndroid) {
        apiKey = EnvConfig.revenueCatAndroidApiKey;
      } else if (Platform.isIOS) {
        apiKey = EnvConfig.revenueCatIosApiKey;
      }

      if (apiKey.isNotEmpty) {
        final configuration = PurchasesConfiguration(apiKey);
        await Purchases.configure(configuration);
        _isRcInitialized = true;

        // Listen for customer info updates
        Purchases.addCustomerInfoUpdateListener((customerInfo) {
          _customerInfoController.add(customerInfo);
        });

        // Get initial customer info
        final customerInfo = await Purchases.getCustomerInfo();
        _customerInfoController.add(customerInfo);
      }
    } catch (e) {
      _isRcInitialized = false;
      debugPrint('Error initializing RevenueCat: $e');
    }
  }

  @override
  Stream<CustomerInfo> get customerInfoStream => _customerInfoController.stream;

  @override
  Future<void> identify(String userId) async {
    if (!_isRcInitialized) return;
    try {
      final customerInfo = await Purchases.logIn(userId);
      _customerInfoController.add(customerInfo.customerInfo);
    } catch (e) {
      debugPrint('RevenueCat identify error: $e');
    }
  }

  @override
  Future<void> reset() async {
    if (!_isRcInitialized) return;
    try {
      final customerInfo = await Purchases.logOut();
      _customerInfoController.add(customerInfo);
    } catch (e) {
      debugPrint('RevenueCat reset error: $e');
    }
  }

  @override
  Future<bool> isPro() async {
    if (!_isRcInitialized) return false;
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.all['Tether Plus']?.isActive ?? false;
    } catch (e) {
      debugPrint('RevenueCat isPro error: $e');
      return false;
    }
  }

  @override
  Future<void> showPaywall() async {
    if (!_isRcInitialized) return;
    try {
      await RevenueCatUI.presentPaywall();
    } catch (e) {
      // Handle or log error
    }
  }

  @override
  Future<void> showCustomerCenter() async {
    if (!_isRcInitialized) return;
    try {
      await RevenueCatUI.presentCustomerCenter();
    } catch (e) {
      // Handle or log error
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
        return _purchaseViaRevenueCat(productId);
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> purchasePremiumAuto({String? productId}) async {
    final installerSource = await InstallerSourceDetector.getInstallerSource();

    if (installerSource == InstallerSource.playStore) {
      return _purchaseViaRevenueCat(productId);
    } else {
      return _purchaseViaRazorpay();
    }
  }

  Future<Either<Failure, void>> _purchaseViaRevenueCat(
    String? productId,
  ) async {
    if (!_isRcInitialized) {
      return const Left(ServerFailure('RevenueCat is not configured.'));
    }
    try {
      final offerings = await Purchases.getOfferings();

      Package? packageToBuy;

      if (productId != null) {
        // Try to find specific product in current offering
        for (final pkg in offerings.current?.availablePackages ?? []) {
          if (pkg.storeProduct.identifier == productId) {
            packageToBuy = pkg;
            break;
          }
        }
      } else {
        // Default to monthly package in current offering
        packageToBuy = offerings.current?.monthly;
      }

      if (packageToBuy == null) {
        return const Left(
          ServerFailure('No applicable subscription package found.'),
        );
      }

      final result = await Purchases.purchasePackage(packageToBuy);
      final customerInfo = result.customerInfo;
      _customerInfoController.add(customerInfo);

      // Check if entitlement 'Tether Plus' is active
      final isEntitled =
          customerInfo.entitlements.all['Tether Plus']?.isActive ?? false;

      if (isEntitled) {
        return const Right(null);
      } else {
        return const Left(
          ServerFailure(
            'Subscription not activated. Please check your payment method.',
          ),
        );
      }
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        return const Left(AuthFailure('Purchase cancelled by user.'));
      }
      return Left(ServerFailure(e.message ?? 'RevenueCat purchase failed.'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> _purchaseViaRazorpay() async {
    if (!EnvConfig.isRazorpayEnabled) {
      return const Left(ServerFailure('Razorpay is not configured.'));
    }
    _razorpay ??= Razorpay();

    final completer = Completer<Either<Failure, void>>();

    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, (
      PaymentSuccessResponse response,
    ) {
      completer.complete(const Right(null));
    });

    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, (
      PaymentFailureResponse response,
    ) {
      completer.complete(
        Left(ServerFailure(response.message ?? 'Razorpay payment failed.')),
      );
    });

    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, (
      ExternalWalletResponse response,
    ) {
      completer.complete(const Right(null));
    });

    final options = {
      'key': EnvConfig.razorpayKeyId,
      'amount': 49900,
      'name': 'Tether Plus',
      'description': 'Monthly Premium Subscription',
      'prefill': {'contact': '', 'email': ''},
    };

    _razorpay!.open(options);
    return completer.future;
  }

  @override
  void dispose() {
    _razorpay?.clear();
    _customerInfoController.close();
  }
}
