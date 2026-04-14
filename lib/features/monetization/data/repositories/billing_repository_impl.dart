import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/billing_repository.dart';

@LazySingleton(as: IBillingRepository)
class BillingRepositoryImpl implements IBillingRepository {
  Razorpay? _razorpay;
  final _customerInfoController = StreamController<CustomerInfo>.broadcast();

  BillingRepositoryImpl() {
    _initRevenueCat();
  }

  Future<void> _initRevenueCat() async {
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
        
        // Listen for customer info updates
        Purchases.addCustomerInfoUpdateListener((customerInfo) {
          _customerInfoController.add(customerInfo);
        });
        
        // Get initial customer info
        final customerInfo = await Purchases.getCustomerInfo();
        _customerInfoController.add(customerInfo);
      }
    } catch (e) {
      // Log error but don't crash
    }
  }

  @override
  Stream<CustomerInfo> get customerInfoStream => _customerInfoController.stream;

  @override
  Future<void> identify(String userId) async {
    try {
      final customerInfo = await Purchases.logIn(userId);
      _customerInfoController.add(customerInfo.customerInfo);
    } catch (_) {}
  }

  @override
  Future<void> reset() async {
    try {
      final customerInfo = await Purchases.logOut();
      _customerInfoController.add(customerInfo);
    } catch (_) {}
  }

  @override
  Future<bool> isPro() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.all['Oasis Pro']?.isActive ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> showPaywall() async {
    try {
      await RevenueCatUI.presentPaywall();
    } catch (e) {
      // Handle or log error
    }
  }

  @override
  Future<void> showCustomerCenter() async {
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

  Future<Either<Failure, void>> _purchaseViaRevenueCat(String? productId) async {
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
        return const Left(ServerFailure('No applicable subscription package found.'));
      }

      final result = await Purchases.purchasePackage(packageToBuy);
      final customerInfo = result.customerInfo;
      _customerInfoController.add(customerInfo);
      
      // Check if entitlement 'Oasis Pro' is active
      final isEntitled = customerInfo.entitlements.all['Oasis Pro']?.isActive ?? false;
      
      if (isEntitled) {
        return const Right(null);
      } else {
        return const Left(ServerFailure('Subscription not activated. Please check your payment method.'));
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
    _razorpay ??= Razorpay();

    final completer = Completer<Either<Failure, void>>();

    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
      completer.complete(const Right(null));
    });

    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
      completer.complete(Left(ServerFailure(response.message ?? 'Razorpay payment failed.')));
    });

    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse response) {
      completer.complete(const Right(null));
    });

    final options = {
      'key': EnvConfig.razorpayKeyId.isNotEmpty ? EnvConfig.razorpayKeyId : 'YOUR_RAZORPAY_KEY_ID',
      'amount': 49900,
      'name': 'Oasis Pro',
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
