import 'package:flutter/material.dart';
import 'cart_models.dart';

extension OrderTypeLabelX on OrderType {
  String label(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    switch (this) {
      case OrderType.pickup:
        return isAr ? 'استلام' : 'Pickup';
      case OrderType.delivery:
        return isAr ? 'توصيل' : 'Delivery';
    }
  }
}

extension PaymentMethodLabelX on PaymentMethod {
  String label(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    switch (this) {
      case PaymentMethod.cash:
        return isAr ? 'كاش' : 'Cash';
      case PaymentMethod.card:
        return isAr ? 'بطاقة' : 'Card';
      case PaymentMethod.applePay:
        return isAr ? 'Apple Pay' : 'Apple Pay';
    }
  }
}
