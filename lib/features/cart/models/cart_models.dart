import 'package:flutter/widgets.dart';

enum OrderType { pickup, delivery }

extension OrderTypeX on OrderType {
  bool get isDelivery => this == OrderType.delivery;
}

extension OrderTypeLabel on OrderType {
  String label(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    switch (this) {
      case OrderType.delivery:
        return isAr ? 'توصيل' : 'Delivery';
      case OrderType.pickup:
        return isAr ? 'استلام' : 'Pickup';
    }
  }
}

enum PaymentMethod { cash, card, applePay }

extension PaymentMethodLabel on PaymentMethod {
  String label(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    switch (this) {
      case PaymentMethod.cash:
        return isAr ? 'كاش' : 'Cash';
      case PaymentMethod.card:
        return isAr ? 'بطاقة' : 'Card';
      case PaymentMethod.applePay:
        return 'Apple Pay';
    }
  }
}

class CartLineItem {
  final String id;
  final String title;
  final double unitPrice;
  final int qty;

  const CartLineItem({
    required this.id,
    required this.title,
    required this.unitPrice,
    required this.qty,
  });

  double get lineTotal => unitPrice * qty;

  CartLineItem copyWith({
    String? id,
    String? title,
    double? unitPrice,
    int? qty,
  }) {
    return CartLineItem(
      id: id ?? this.id,
      title: title ?? this.title,
      unitPrice: unitPrice ?? this.unitPrice,
      qty: qty ?? this.qty,
    );
  }
}
