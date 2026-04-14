import '../../domain/entities/favor_coupon.dart';

class FavorCouponModel extends FavorCouponEntity {
  const FavorCouponModel({
    required super.id,
    required super.circleId,
    required super.createdBy,
    required super.assignedTo,
    required super.description,
    super.redeemed = false,
    super.redeemedAt,
    required super.createdAt,
  });

  factory FavorCouponModel.fromJson(Map<String, dynamic> json) {
    return FavorCouponModel(
      id: json['id'] as String,
      circleId: json['circle_id'] as String,
      createdBy: json['created_by'] as String,
      assignedTo: json['assigned_to'] as String,
      description: json['description'] as String,
      redeemed: json['redeemed'] as bool? ?? false,
      redeemedAt: json['redeemed_at'] != null ? DateTime.parse(json['redeemed_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circle_id': circleId,
      'created_by': createdBy,
      'assigned_to': assignedTo,
      'description': description,
      'redeemed': redeemed,
      'redeemed_at': redeemedAt?.toIso8601String(),
    };
  }
}
