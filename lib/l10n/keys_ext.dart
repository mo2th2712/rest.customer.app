import 'package:flutter/widgets.dart';
import 'package:restaurant_customer_app/l10n/app_localizations.dart';

extension AppLocalizationsKeysExt on AppLocalizations {
  bool get _isAr {
    final d = this as dynamic;
    String? name;

    try {
      name = d.localeName as String?;
    } catch (_) {}

    if (name == null) {
      try {
        final Locale? loc = d.locale as Locale?;
        name = loc?.languageCode;
      } catch (_) {}
    }

    return (name ?? '').toLowerCase().startsWith('ar');
  }

  String get bottomNavHome => _isAr ? 'الرئيسية' : 'Home';
  String get bottomNavOrders => _isAr ? 'الطلبات' : 'Orders';

  String get cartTitle => _isAr ? 'السلة' : 'Cart';
  String get confirmOrder => _isAr ? 'تأكيد الطلب' : 'Confirm order';

  String get pickup => _isAr ? 'استلام' : 'Pickup';
  String get delivery => _isAr ? 'توصيل' : 'Delivery';

  String get paymentMethod => _isAr ? 'طريقة الدفع' : 'Payment method';
  String get cashOnDelivery => _isAr ? 'كاش عند الاستلام' : 'Cash on delivery';
  String get cash => _isAr ? 'كاش' : 'Cash';
  String get card => _isAr ? 'بطاقة' : 'Card';
  String get applePay => _isAr ? 'Apple Pay' : 'Apple Pay';
  String get deliveryOnlyHint =>
      _isAr ? 'متاح للتوصيل فقط' : 'Available for delivery only';

  String get notes => _isAr ? 'ملاحظات' : 'Notes';
  String get notesHint => _isAr
      ? 'أي ملاحظات خاصة؟ مثال: من فضلك لا تضف المايونيز'
      : "Any special requests? e.g., Please don't add mayonnaise";

  String get summary => _isAr ? 'ملخص الطلب' : 'Summary';
  String get subtotal => _isAr ? 'المجموع الفرعي' : 'Subtotal';
  String get deliveryFee => _isAr ? 'رسوم التوصيل' : 'Delivery fee';
  String get total => _isAr ? 'الإجمالي' : 'Total';

  String get viewCart => _isAr ? 'عرض السلة' : 'View cart';
}
