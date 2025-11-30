import 'package:flutter/widgets.dart';
import '../../branch/models/branch_models.dart';
import '../../cart/models/cart_models.dart';

enum OrderStatus {
  pending,
  preparing,
  accepted,
  outForDelivery,
  completed,
  canceled,
}

extension OrderStatusX on OrderStatus {
  String label(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    switch (this) {
      case OrderStatus.pending:
        return isAr ? 'قيد الانتظار' : 'Pending';
      case OrderStatus.preparing:
        return isAr ? 'قيد التحضير' : 'Preparing';
      case OrderStatus.accepted:
        return isAr ? 'تم القبول' : 'Accepted';
      case OrderStatus.outForDelivery:
        return isAr ? 'بالطريق' : 'Out for delivery';
      case OrderStatus.completed:
        return isAr ? 'مكتمل' : 'Completed';
      case OrderStatus.canceled:
        return isAr ? 'ملغي' : 'Canceled';
    }
  }
}

class OrderLine {
  final String id;
  final String title;
  final int qty;
  final double unitPrice;

  const OrderLine({
    required this.id,
    required this.title,
    required this.qty,
    required this.unitPrice,
  });

  double get lineTotal => unitPrice * qty;
}

class RestaurantOrder {
  final String id;
  final DateTime createdAt;

  final Branch branchSnapshot;
  final OrderType type;
  final PaymentMethod paymentMethod;

  final String? deliveryAddress;
  final double? deliveryLat;
  final double? deliveryLng;

  final String? notes;

  final List<OrderLine> lines;
  final double deliveryFee;

  final String? promoCode;
  final double discountAmount;
  final DateTime? scheduledFor;

  final OrderStatus status;

  const RestaurantOrder({
    required this.id,
    required this.createdAt,
    required this.branchSnapshot,
    required this.type,
    required this.paymentMethod,
    required this.lines,
    required this.deliveryFee,
    required this.status,
    this.deliveryAddress,
    this.deliveryLat,
    this.deliveryLng,
    this.notes,
    this.promoCode,
    this.discountAmount = 0.0,
    this.scheduledFor,
  });

  bool get isDelivery => type == OrderType.delivery;

  String get shortId {
    final parts = id.split('-');
    if (parts.length >= 2) return parts.last;
    if (id.length <= 6) return id;
    return id.substring(id.length - 6);
  }

  double get subtotal => lines.fold<double>(0, (s, l) => s + l.lineTotal);

  double get total {
    final t = subtotal + deliveryFee - discountAmount;
    return t < 0 ? 0 : t;
  }
}
