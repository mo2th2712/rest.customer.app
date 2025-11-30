import 'package:flutter/widgets.dart';

class MenuCategory {
  final String id;
  final String nameAr;
  final String nameEn;
  final int sortOrder;

  const MenuCategory({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.sortOrder,
  });

  String nameFor(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return lang == 'ar' ? nameAr : nameEn;
  }
}

class MenuItem {
  final String id;
  final String categoryId;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final double price;
  final bool isAvailable; // للمستقبل
  final String imageUrl; // للمستقبل

  const MenuItem({
    required this.id,
    required this.categoryId,
    required this.nameAr,
    required this.nameEn,
    this.descriptionAr = '',
    this.descriptionEn = '',
    required this.price,
    this.isAvailable = true,
    this.imageUrl = '',
  });

  String nameFor(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return lang == 'ar' ? nameAr : nameEn;
  }

  String descFor(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final v = lang == 'ar' ? descriptionAr : descriptionEn;
    return v.trim();
  }

  bool matchesQuery(BuildContext context, String q) {
    final query = q.trim().toLowerCase();
    if (query.isEmpty) return true;

    final lang = Localizations.localeOf(context).languageCode;
    final hay = (lang == 'ar'
            ? '$nameAr $descriptionAr'
            : '$nameEn $descriptionEn')
        .toLowerCase();

    return hay.contains(query);
  }
}
