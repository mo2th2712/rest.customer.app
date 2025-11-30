import '../models/menu_models.dart';

class LocalMenuRepository {
  const LocalMenuRepository();

  List<MenuCategory> getCategories() {
    return const [
      MenuCategory(
        id: 'shawarma_meals',
        nameAr: 'وجبات الشاورما',
        nameEn: 'Shawarma Meals',
        sortOrder: 10,
      ),
      MenuCategory(
        id: 'shawarma_sandwiches',
        nameAr: 'ساندويشات الشاورما',
        nameEn: 'Shawarma Sandwiches',
        sortOrder: 20,
      ),
      MenuCategory(
        id: 'zinger',
        nameAr: 'الزنجر',
        nameEn: 'Zinger',
        sortOrder: 30,
      ),
      MenuCategory(
        id: 'family_shawarma',
        nameAr: 'صدر شاورما عائلي',
        nameEn: 'Family Shawarma Tray',
        sortOrder: 40,
      ),
      MenuCategory(
        id: 'broasted',
        nameAr: 'بروستد',
        nameEn: 'Broasted',
        sortOrder: 50,
      ),
      MenuCategory(
        id: 'sides_extras',
        nameAr: 'إضافات',
        nameEn: 'Extras',
        sortOrder: 60,
      ),
    ];
  }

  List<MenuItem> getItems() {
    return const [
      // =========================
      // Shawarma Meals
      // =========================
      MenuItem(
        id: 'sm_arabic_chicken',
        categoryId: 'shawarma_meals',
        nameAr: 'عربي دجاج',
        nameEn: 'Arabic Chicken',
        price: 1.90,
      ),
      MenuItem(
        id: 'sm_arabic_regular_cheese',
        categoryId: 'shawarma_meals',
        nameAr: 'عربي عادي + جبنة',
        nameEn: 'Arabic Regular + Cheese',
        price: 2.25,
      ),
      MenuItem(
        id: 'sm_arabic_super',
        categoryId: 'shawarma_meals',
        nameAr: 'عربي سوبر',
        nameEn: 'Arabic Super',
        price: 2.40,
      ),
      MenuItem(
        id: 'sm_arabic_super_cheese',
        categoryId: 'shawarma_meals',
        nameAr: 'عربي سوبر + جبنة',
        nameEn: 'Arabic Super + Cheese',
        price: 2.65,
      ),
      MenuItem(
        id: 'sm_arabic_double',
        categoryId: 'shawarma_meals',
        nameAr: 'عربي دبل',
        nameEn: 'Arabic Double',
        price: 3.25,
      ),
      MenuItem(
        id: 'sm_arabic_double_cheese',
        categoryId: 'shawarma_meals',
        nameAr: 'عربي دبل + جبنة',
        nameEn: 'Arabic Double + Cheese',
        price: 3.70,
      ),
      MenuItem(
        id: 'sm_halabi_regular',
        categoryId: 'shawarma_meals',
        nameAr: 'حلبي عادي',
        nameEn: 'Halabi Regular',
        price: 3.00,
      ),
      MenuItem(
        id: 'sm_halabi_super',
        categoryId: 'shawarma_meals',
        nameAr: 'حلبي سوبر',
        nameEn: 'Halabi Super',
        price: 3.75,
      ),
      MenuItem(
        id: 'sm_french',
        categoryId: 'shawarma_meals',
        nameAr: 'فرنسي',
        nameEn: 'French',
        price: 1.95,
      ),
      MenuItem(
        id: 'sm_italian',
        categoryId: 'shawarma_meals',
        nameAr: 'إيطالي',
        nameEn: 'Italian',
        price: 3.00,
      ),
      MenuItem(
        id: 'sm_half_deek_halabi_no_fries',
        categoryId: 'shawarma_meals',
        nameAr: '1/2 دك حلبي بدون بطاطا',
        nameEn: 'Half Deek Halabi (No Fries)',
        price: 5.50,
      ),
      MenuItem(
        id: 'sm_half_deek_halabi_with_fries',
        categoryId: 'shawarma_meals',
        nameAr: '1/2 دك حلبي مع بطاطا',
        nameEn: 'Half Deek Halabi (With Fries)',
        price: 6.50,
      ),

      // =========================
      // Shawarma Sandwiches
      // =========================
      MenuItem(
        id: 'ss_regular',
        categoryId: 'shawarma_sandwiches',
        nameAr: 'ساندويش عادي',
        nameEn: 'Regular Sandwich',
        price: 0.60,
      ),
      MenuItem(
        id: 'ss_regular_cheese',
        categoryId: 'shawarma_sandwiches',
        nameAr: 'ساندويش عادي + جبنة',
        nameEn: 'Regular + Cheese',
        price: 0.90,
      ),
      MenuItem(
        id: 'ss_super',
        categoryId: 'shawarma_sandwiches',
        nameAr: 'ساندويش سوبر',
        nameEn: 'Super Sandwich',
        price: 1.25,
      ),
      MenuItem(
        id: 'ss_super_cheese',
        categoryId: 'shawarma_sandwiches',
        nameAr: 'ساندويش سوبر + جبنة',
        nameEn: 'Super + Cheese',
        price: 1.50,
      ),
      MenuItem(
        id: 'ss_kaak_cheese',
        categoryId: 'shawarma_sandwiches',
        nameAr: 'ساندويش كعك + جبنة',
        nameEn: 'Kaak + Cheese',
        price: 1.40,
      ),

      // =========================
      // Zinger
      // =========================
      MenuItem(
        id: 'z_meal_saj',
        categoryId: 'zinger',
        nameAr: 'وجبة زنجر صاج',
        nameEn: 'Zinger Meal (Saj)',
        price: 2.50,
      ),
      MenuItem(
        id: 'z_meal_french',
        categoryId: 'zinger',
        nameAr: 'وجبة زنجر فرنسي',
        nameEn: 'Zinger Meal (French)',
        price: 2.60,
      ),
      MenuItem(
        id: 'z_sandwich_saj',
        categoryId: 'zinger',
        nameAr: 'ساندويش زنجر صاج',
        nameEn: 'Zinger Sandwich (Saj)',
        price: 1.90,
      ),
      MenuItem(
        id: 'z_sandwich_french',
        categoryId: 'zinger',
        nameAr: 'ساندويش زنجر فرنسي',
        nameEn: 'Zinger Sandwich (French)',
        price: 1.60,
      ),
      MenuItem(
        id: 'z_fries_saj',
        categoryId: 'zinger',
        nameAr: 'ساندويش بطاطا صاج',
        nameEn: 'Fries Sandwich (Saj)',
        price: 1.00,
      ),

      // =========================
      // Family Shawarma (صدر شاورما عائلي)
      // =========================
      MenuItem(
        id: 'fs_3',
        categoryId: 'family_shawarma',
        nameAr: 'صدر شاورما عائلي - 3 أشخاص',
        nameEn: 'Family Shawarma - 3 Persons',
        descriptionAr: 'بطاطا، متومة، مخلل',
        descriptionEn: 'Fries, garlic, pickles',
        price: 6.00,
      ),
      MenuItem(
        id: 'fs_4',
        categoryId: 'family_shawarma',
        nameAr: 'صدر شاورما عائلي - 4 أشخاص',
        nameEn: 'Family Shawarma - 4 Persons',
        descriptionAr: 'بطاطا، متومة، مخلل',
        descriptionEn: 'Fries, garlic, pickles',
        price: 7.75,
      ),
      MenuItem(
        id: 'fs_5',
        categoryId: 'family_shawarma',
        nameAr: 'صدر شاورما عائلي - 5 أشخاص',
        nameEn: 'Family Shawarma - 5 Persons',
        descriptionAr: 'بطاطا، متومة، مخلل',
        descriptionEn: 'Fries, garlic, pickles',
        price: 9.50,
      ),
      MenuItem(
        id: 'fs_6',
        categoryId: 'family_shawarma',
        nameAr: 'صدر شاورما عائلي - 6 أشخاص',
        nameEn: 'Family Shawarma - 6 Persons',
        descriptionAr: 'بطاطا، متومة، مخلل',
        descriptionEn: 'Fries, garlic, pickles',
        price: 11.25,
      ),
      MenuItem(
        id: 'fs_7',
        categoryId: 'family_shawarma',
        nameAr: 'صدر شاورما عائلي - 7 أشخاص',
        nameEn: 'Family Shawarma - 7 Persons',
        descriptionAr: 'بطاطا، متومة، مخلل',
        descriptionEn: 'Fries, garlic, pickles',
        price: 13.00,
      ),
      MenuItem(
        id: 'fs_8',
        categoryId: 'family_shawarma',
        nameAr: 'صدر شاورما عائلي - 8 أشخاص',
        nameEn: 'Family Shawarma - 8 Persons',
        descriptionAr: 'بطاطا، متومة، مخلل',
        descriptionEn: 'Fries, garlic, pickles',
        price: 15.00,
      ),
      MenuItem(
        id: 'fs_9',
        categoryId: 'family_shawarma',
        nameAr: 'صدر شاورما عائلي - 9 أشخاص',
        nameEn: 'Family Shawarma - 9 Persons',
        descriptionAr: 'بطاطا، متومة، مخلل',
        descriptionEn: 'Fries, garlic, pickles',
        price: 17.00,
      ),
      MenuItem(
        id: 'fs_10',
        categoryId: 'family_shawarma',
        nameAr: 'صدر شاورما عائلي - 10 أشخاص',
        nameEn: 'Family Shawarma - 10 Persons',
        descriptionAr: 'بطاطا، متومة، مخلل',
        descriptionEn: 'Fries, garlic, pickles',
        price: 19.00,
      ),

      // =========================
      // Broasted
      // =========================
      MenuItem(
        id: 'b_4',
        categoryId: 'broasted',
        nameAr: 'وجبة بروستد 4 قطع',
        nameEn: 'Broasted Meal (4 pcs)',
        descriptionAr: 'متومة، كاتشب، خبز، بطاطا',
        descriptionEn: 'Garlic, ketchup, bread, fries',
        price: 2.90,
      ),
      MenuItem(
        id: 'b_12',
        categoryId: 'broasted',
        nameAr: 'وجبة بروستد 12 قطعة',
        nameEn: 'Broasted Meal (12 pcs)',
        descriptionAr: 'متومة، كاتشب، خبز، 3 بطاطا، لتر كولا',
        descriptionEn: 'Garlic, ketchup, bread, 3 fries, 1L cola',
        price: 9.20,
      ),
      MenuItem(
        id: 'b_16',
        categoryId: 'broasted',
        nameAr: 'وجبة بروستد 16 قطعة',
        nameEn: 'Broasted Meal (16 pcs)',
        descriptionAr: 'متومة، كاتشب، خبز، 4 بطاطا، 2 لتر كولا',
        descriptionEn: 'Garlic, ketchup, bread, 4 fries, 2L cola',
        price: 12.60,
      ),
      MenuItem(
        id: 'b_20',
        categoryId: 'broasted',
        nameAr: 'وجبة بروستد 20 قطعة',
        nameEn: 'Broasted Meal (20 pcs)',
        descriptionAr: 'متومة، كاتشب، خبز، 5 بطاطا، لتر كولا',
        descriptionEn: 'Garlic, ketchup, bread, 5 fries, 1L cola',
        price: 15.00,
      ),
      MenuItem(
        id: 'b_24',
        categoryId: 'broasted',
        nameAr: 'وجبة بروستد 24 قطعة',
        nameEn: 'Broasted Meal (24 pcs)',
        descriptionAr: 'متومة، كاتشب، خبز، 6 بطاطا، لتر كولا',
        descriptionEn: 'Garlic, ketchup, bread, 6 fries, 1L cola',
        price: 17.90,
      ),
      MenuItem(
        id: 'ms_5',
        categoryId: 'broasted',
        nameAr: 'وجبة مسحب 5 قطع',
        nameEn: 'Strips Meal (5 pcs)',
        descriptionAr: 'متومة، كاتشب، خبز، بطاطا',
        descriptionEn: 'Garlic, ketchup, bread, fries',
        price: 3.00,
      ),
      MenuItem(
        id: 'wings_7',
        categoryId: 'broasted',
        nameAr: 'أجنحة الدجاج العملاقة 7 قطع',
        nameEn: 'Giant Wings (7 pcs)',
        descriptionAr: 'متومة، كاتشب، خبز، بطاطا',
        descriptionEn: 'Garlic, ketchup, bread, fries',
        price: 3.00,
      ),

      // =========================
      // Extras
      // =========================
      MenuItem(
        id: 'ex_cola_300',
        categoryId: 'sides_extras',
        nameAr: 'كولا 300 مل',
        nameEn: 'Cola 300ml',
        price: 0.35,
      ),
      MenuItem(
        id: 'ex_cola_1l',
        categoryId: 'sides_extras',
        nameAr: 'كولا 1 لتر',
        nameEn: 'Cola 1L',
        price: 0.60,
      ),
      MenuItem(
        id: 'ex_cola_2l',
        categoryId: 'sides_extras',
        nameAr: 'كولا 2 لتر',
        nameEn: 'Cola 2L',
        price: 1.00,
      ),
      MenuItem(
        id: 'ex_matrix_can',
        categoryId: 'sides_extras',
        nameAr: 'علبة ماتريكس',
        nameEn: 'Matrix Can',
        price: 0.30,
      ),
      MenuItem(
        id: 'ex_chili_sauce',
        categoryId: 'sides_extras',
        nameAr: 'سويت تشيلي صوص',
        nameEn: 'Sweet Chili Sauce',
        price: 0.25,
      ),
      MenuItem(
        id: 'ex_coleslaw_200',
        categoryId: 'sides_extras',
        nameAr: 'كولسلو 200 غم',
        nameEn: 'Coleslaw 200g',
        price: 0.50,
      ),
      MenuItem(
        id: 'ex_garlic_cup',
        categoryId: 'sides_extras',
        nameAr: 'علبة متومة',
        nameEn: 'Garlic Cup',
        price: 0.15,
      ),
      MenuItem(
        id: 'ex_fries_200',
        categoryId: 'sides_extras',
        nameAr: 'بطاطا 200 غم',
        nameEn: 'Fries 200g',
        price: 0.50,
      ),
    ];
  }
}
