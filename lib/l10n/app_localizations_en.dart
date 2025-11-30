// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeTitle => 'Home';

  @override
  String get branchLabel => 'Branch:';

  @override
  String get greeting => 'Welcome!';

  @override
  String get greetingSub => 'What would you like to eat today?';

  @override
  String get changeBranch => 'Change branch';

  @override
  String get searchHint => 'Search for meals…';

  @override
  String get viewCart => 'View Cart';

  @override
  String get itemsLabel => 'items';

  @override
  String get youMayAlsoLike => 'You may also like';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get addedToCart => 'Added to cart';

  @override
  String get bottomNavHome => 'Home';

  @override
  String get bottomNavOrders => 'Orders';

  @override
  String get cartTitle => 'Your Cart';

  @override
  String get confirmOrder => 'Confirm order';

  @override
  String get pickup => 'Pickup';

  @override
  String get delivery => 'Delivery';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get cashOnDelivery => 'Cash on delivery';

  @override
  String get cash => 'Cash';

  @override
  String get card => 'Card';

  @override
  String get applePay => 'Apple Pay';

  @override
  String get deliveryOnlyHint => 'Delivery only';

  @override
  String get notes => 'Notes';

  @override
  String get notesHint => 'Any notes?';

  @override
  String get summary => 'Summary';
}
