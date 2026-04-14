import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';

class PricingDisplay {
  static Future<String> getFormattedPrice(String productId) async {
    try {
      final offerings = await Purchases.getOfferings();
      final package = offerings.all.values
          .expand((offering) => offering.availablePackages)
          .firstWhere((p) => p.storeProduct.identifier == productId);
      
      if (package != null) {
        return package.storeProduct.priceString;
      }
    } catch (e) {
      // Fallback to PPP tier estimates if offline
      return _getPPPFallback(productId);
    }
    return "---";
  }

  static String _getPPPFallback(String productId) {
    final countryCode = Platform.localeName.split('_').last;
    
    // Tier 3 countries (India, Brazil, etc) - 50% approx
    const tier3 = ['IN', 'BR', 'MX', 'ID'];
    // Tier 4 countries - 35% approx
    const tier4 = ['PK', 'NG', 'BD'];

    final isPlus = productId.contains('plus');
    final isFamily = productId.contains('family');
    final isAnnual = productId.contains('annual');

    double basePrice = isPlus ? 4.99 : (isFamily ? 7.99 : 4.99);
    if (isAnnual) basePrice *= 8; // approx 33% discount on annual

    if (tier4.contains(countryCode)) return "${(basePrice * 0.35).toStringAsFixed(2)} (est)";
    if (tier3.contains(countryCode)) return "${(basePrice * 0.50).toStringAsFixed(2)} (est)";
    
    return "\$${basePrice.toStringAsFixed(2)}";
  }
}
