import 'package:equatable/equatable.dart';

class FavorCouponEntity extends Equatable {
  final String id;
  final String circleId;
  final String createdBy;
  final String assignedTo;
  final String description;
  final bool redeemed;
  final DateTime? redeemedAt;
  final DateTime createdAt;

  const FavorCouponEntity({
    required this.id,
    required this.circleId,
    required this.createdBy,
    required this.assignedTo,
    required this.description,
    this.redeemed = false,
    this.redeemedAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, circleId, createdBy, assignedTo, description, redeemed, redeemedAt, createdAt];
}
