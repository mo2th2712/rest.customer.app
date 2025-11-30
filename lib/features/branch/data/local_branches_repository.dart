import '../models/branch_models.dart';

class LocalBranchesRepository {
  const LocalBranchesRepository();

  // المصدر الأساسي للفروع
  static const List<Branch> _branches = [
    Branch(
      id: 1,
      nameAr: 'فرع اربد',
      nameEn: '7th Circle Branch',
      addressAr: 'عمّان - الدوار السابع، شارع زهران',
      addressEn: 'Amman - 7th Circle, Zahran St.',
      distanceKm: 2.3,
      openMinute: 10 * 60,
      closeMinute: 1 * 60, // 01:00 (cross-midnight)
    ),
    Branch(
      id: 2,
      nameAr: 'فرع خلدا',
      nameEn: 'Khalda Branch',
      addressAr: 'عمّان - خلدا، قرب الإشارة',
      addressEn: 'Amman - Khalda, near the lights',
      distanceKm: 4.7,
      openMinute: 11 * 60,
      closeMinute: 2 * 60, // 02:00
    ),
    Branch(
      id: 3,
      nameAr: 'فرع طبربور',
      nameEn: 'Tabarbour Branch',
      addressAr: 'عمّان - طبربور، شارع الرئيسي',
      addressEn: 'Amman - Tabarbour, Main St.',
      distanceKm: 6.1,
      openMinute: 9 * 60 + 30,
      closeMinute: 0 * 60 + 30, // 00:30
    ),
  ];

  // للتماشي مع الكود القديم لو كان يستخدم getBranches()
  List<Branch> getBranches() => _branches;

  // getter جديد عشان main.dart يستخدمه
  List<Branch> get branches => List.unmodifiable(_branches);
}