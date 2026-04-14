import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

enum EntitlementTier { free, plus, family }

class EntitlementStatus {
  final bool isEntitled;
  final EntitlementTier tier;
  final String status;
  final DateTime? expiresAt;

  EntitlementStatus({
    required this.isEntitled,
    required this.tier,
    required this.status,
    this.expiresAt,
  });

  factory EntitlementStatus.free() => EntitlementStatus(
        isEntitled: false,
        tier: EntitlementTier.free,
        status: 'active',
      );
}

abstract class ISubscriptionService {
  Future<bool> checkEntitlement(String featureId);
  Future<EntitlementStatus> getStatus();
  Future<void> syncWithProvider();
}

@Singleton(as: ISubscriptionService)
class SubscriptionService implements ISubscriptionService {
  final SupabaseClient _supabase;
  EntitlementStatus? _cachedStatus;

  SubscriptionService(this._supabase);

  @override
  Future<bool> checkEntitlement(String featureId) async {
    try {
      final response = await _supabase.functions.invoke(
        'verify-entitlement',
        body: {'feature_id': featureId},
      );

      if (response.status == 200) {
        final data = response.data as Map<String, dynamic>;
        _updateCache(data);
        return data['entitled'] as bool;
      }
      return false;
    } catch (e) {
      // Fallback to cache if error
      return _cachedStatus?.isEntitled ?? false;
    }
  }

  @override
  Future<EntitlementStatus> getStatus() async {
    if (_cachedStatus != null) return _cachedStatus!;

    try {
      final response = await _supabase.functions.invoke('verify-entitlement');
      if (response.status == 200) {
        final data = response.data as Map<String, dynamic>;
        return _updateCache(data);
      }
    } catch (e) {
      // Ignore
    }
    return EntitlementStatus.free();
  }

  @override
  Future<void> syncWithProvider() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      // RevenueCat status is the source of truth for the edge function
      // but we can also trigger a sync here if needed.
      _cachedStatus = null; // Invalidate cache
      await getStatus();
    } catch (e) {
      // Ignore
    }
  }

  EntitlementStatus _updateCache(Map<String, dynamic> data) {
    final tierStr = data['tier'] as String? ?? 'free';
    final tier = tierStr == 'family'
        ? EntitlementTier.family
        : (tierStr == 'plus' ? EntitlementTier.plus : EntitlementTier.free);

    _cachedStatus = EntitlementStatus(
      isEntitled: data['entitled'] as bool? ?? false,
      tier: tier,
      status: data['status'] as String? ?? 'active',
      expiresAt: data['expires_at'] != null ? DateTime.parse(data['expires_at']) : null,
    );
    return _cachedStatus!;
  }
}
