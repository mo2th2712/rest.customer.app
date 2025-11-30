import 'package:flutter/widgets.dart';

class Branch {
  final int id;

  final String nameAr;
  final String nameEn;

  final String addressAr;
  final String addressEn;

  /// Placeholder until we connect real location.
  final double distanceKm;

  /// Minutes since midnight (local time).
  final int openMinute;
  final int closeMinute;

  /// For temporary closures (maintenance, etc).
  final bool forceClosed;

  const Branch({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.addressAr,
    required this.addressEn,
    required this.distanceKm,
    required this.openMinute,
    required this.closeMinute,
    this.forceClosed = false,
  });

  String nameFor(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return isAr ? nameAr : nameEn;
  }

  String addressFor(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return isAr ? addressAr : addressEn;
  }

  String distanceText(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final n = distanceKm.toStringAsFixed(1);
    return isAr ? '$n كم' : '$n km';
  }

  String hoursText(BuildContext context) {
    return '${_fmt(openMinute)} - ${_fmt(closeMinute)}';
  }

  bool isOpenAt(DateTime now) {
    if (forceClosed) return false;

    final m = now.hour * 60 + now.minute;

    // Same-day range
    if (closeMinute > openMinute) {
      return m >= openMinute && m < closeMinute;
    }

    // Cross-midnight (e.g. 10:00 -> 01:00)
    return m >= openMinute || m < closeMinute;
  }

  String openBadgeText(BuildContext context, DateTime now) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final open = isOpenAt(now);
    return open ? (isAr ? 'مفتوح' : 'Open') : (isAr ? 'مغلق' : 'Closed');
  }

  static String _fmt(int minute) {
    String two(int v) => v.toString().padLeft(2, '0');
    final h = minute ~/ 60;
    final m = minute % 60;
    return '${two(h)}:${two(m)}';
  }
}
