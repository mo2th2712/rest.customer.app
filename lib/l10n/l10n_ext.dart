import 'package:flutter/widgets.dart';
import 'package:restaurant_customer_app/l10n/app_localizations.dart';

extension L10nExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
