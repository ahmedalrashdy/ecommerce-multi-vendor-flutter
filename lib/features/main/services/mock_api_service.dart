import 'package:ecommerce/core/models/plateform_category_model.dart';
import 'package:ecommerce/features/main/models/offer_model.dart';
import 'package:ecommerce/core/models/product_model.dart';
import 'package:ecommerce/core/models/store_model.dart';

class MockApiService {
  // تأخير مزيف لمحاكاة طلبات API
  Future<void> _delay() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  // الحصول على العروض
  Future<List<OfferModel>> getOffers() async {
    await _delay();
    return [
      OfferModel(
        id: '1',
        title: 'خصم 30% على الملابس',
        description: 'خصم حصري على جميع الملابس الرجالية',
        imageUrl:
            'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=2070',
        discountPercentage: 30,
        storeId: '1',
        validUntil: DateTime.now().add(const Duration(days: 7)),
        couponCode: 'CLOTHES30',
      ),
      OfferModel(
        id: '2',
        title: 'خصم 20% على الإلكترونيات',
        description: 'خصم على جميع الأجهزة الإلكترونية',
        imageUrl:
            'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?q=80&w=2069',
        discountPercentage: 20,
        storeId: '2',
        validUntil: DateTime.now().add(const Duration(days: 5)),
        couponCode: 'ELEC20',
      ),
      OfferModel(
        id: '3',
        title: 'اشتري 1 واحصل على 1 مجاناً',
        description: 'عرض خاص على المنتجات المنزلية',
        imageUrl:
            'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?q=80&w=2070',
        storeId: '3',
        validUntil: DateTime.now().add(const Duration(days: 3)),
        couponCode: 'BUY1GET1',
      ),
      OfferModel(
        id: '4',
        title: 'خصم 15% على الأحذية',
        description: 'خصم على جميع الأحذية الرياضية',
        imageUrl:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=2070',
        discountPercentage: 15,
        storeId: '4',
        validUntil: DateTime.now().add(const Duration(days: 10)),
        couponCode: 'SHOES15',
      ),
    ];
  }

  // الحصول على فئات المنصة
  Future<List<PlatformCategory>> getPlatformCategories() async {
    await _delay();
    return [
      PlatformCategory(
        id: 1,
        name: 'الكل',
        imageUrl:
            'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?q=80&w=2070',
      ),
      PlatformCategory(
        id: 2,
        name: 'ملابس',
        imageUrl:
            'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?q=80&w=2070',
      ),
    ];
  }

  // الحصول على المتاجر
  Future<List<StoreModel>> getStores({String? categoryId}) async {
    await _delay();
    final allStores = [
      StoreModel(
        id: 1,
        name: 'متجر الأناقة',
        description: 'متجر متخصص في الملابس الرجالية والنسائية العصرية.',
        logo:
            'https://images.unsplash.com/photo-1507679799987-c73779587ccf?q=80&w=800',
        coverImage:
            'https://images.unsplash.com/photo-1441986300917-64674bd600d8?q=80&w=1200',
        city: 'صنعاء',
        platformCategoryName: 'ملابس',
        platformCategoryId: 1,
        averageRating: 4.5,
        productCount: 120,
        favoritesCount: 35,
        reviewCount: 18,
        isFavorite: false,
      ),
      StoreModel(
        id: 2,
        name: 'تك ستور',
        description: 'متجر متخصص في الإلكترونيات والأجهزة الذكية.',
        logo:
            'https://images.unsplash.com/photo-1560179707-f14e90ef3623?q=80&w=800',
        coverImage:
            'https://images.unsplash.com/photo-1550009158-94ae76552485?q=80&w=1200',
        city: 'عدن',
        platformCategoryName: 'إلكترونيات',
        platformCategoryId: 2,
        averageRating: 4.8,
        productCount: 85,
        favoritesCount: 20,
        reviewCount: 12,
        isFavorite: false,
      ),
      StoreModel(
        id: 3,
        name: 'المنزل العصري',
        description: 'كل ما يخص المنزل من أثاث وديكور حديث.',
        logo:
            'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=800',
        coverImage:
            'https://images.unsplash.com/photo-1618220179428-22790b461013?q=80&w=1200',
        city: 'تعز',
        platformCategoryName: 'منزل وحديقة',
        platformCategoryId: 3,
        averageRating: 4.2,
        productCount: 150,
        favoritesCount: 40,
        reviewCount: 25,
        isFavorite: false,
      ),
      StoreModel(
        id: 4,
        name: 'شوز لاند',
        description: 'متجر متخصص في الأحذية والحقائب لجميع أفراد العائلة.',
        logo:
            'https://images.unsplash.com/photo-1535043934128-cf0b28d52f95?q=80&w=800',
        coverImage:
            'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?q=80&w=1200',
        city: 'الحديدة',
        platformCategoryName: 'أحذية وحقائب',
        platformCategoryId: 4,
        averageRating: 4.0,
        productCount: 95,
        favoritesCount: 15,
        reviewCount: 9,
        isFavorite: false,
      ),
      StoreModel(
        id: 5,
        name: 'مطعم الشرق',
        description: 'أشهى المأكولات الشرقية والغربية في أجواء رائعة.',
        logo:
            'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=800',
        coverImage:
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1200',
        openingTime: '12:00',
        closingTime: '00:00',
        city: 'صنعاء',
        platformCategoryName: 'مطاعم',
        platformCategoryId: 5,
        averageRating: 4.7,
        productCount: 45,
        favoritesCount: 28,
        isFavorite: false,
        reviewCount: 14,
      ),
    ];

    if (categoryId != null) {
      return allStores
          .where((store) => store.platformCategoryName == categoryId)
          .toList();
    }

    return allStores;
  }

  // الحصول على المنتجات
  Future<List<ProductModel>> getProducts(
      {String? categoryId, String? sortBy}) async {
    await _delay();
    final allProducts = [
      ProductModel(
        id: 1,
        name: 'قميص رجالي كلاسيكي',
        description: 'قميص رجالي كلاسيكي بأكمام طويلة مناسب للمناسبات الرسمية',
        imageUrl:
            'https://images.unsplash.com/photo-1620012253295-c15cc3e65df4?q=80&w=2065',
        price: 120.0,
        discountPercentage: 15,
        finalPrice: 102.0,
        storeId: 1,
        storeName: 'متجر الأناقة',
        categoryId: 1,
        categoryName: 'ملابس',
        rating: 4.5,
      ),
      ProductModel(
        id: 2,
        name: 'سماعات بلوتوث لاسلكية',
        description: 'سماعات بلوتوث لاسلكية عالية الجودة مع إلغاء الضوضاء',
        imageUrl:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=2070',
        price: 250.0,
        discountPercentage: 20,
        finalPrice: 200.0,
        storeId: 2,
        storeName: 'تك ستور',
        categoryId: 2,
        categoryName: 'إلكترونيات',
        rating: 4.8,
      ),
      ProductModel(
        id: 3,
        name: 'طاولة قهوة خشبية',
        description: 'طاولة قهوة خشبية أنيقة للمنزل العصري',
        imageUrl:
            'https://images.unsplash.com/photo-1592078615290-033ee584e267?q=80&w=1964',
        price: 350.0,
        finalPrice: 350.0,
        storeId: 3,
        storeName: 'المنزل العصري',
        categoryId: 3,
        categoryName: 'منزل وحديقة',
        rating: 4.2,
      ),
      ProductModel(
        id: 4,
        name: 'حذاء رياضي',
        description: 'حذاء رياضي مريح مناسب للجري والتمارين الرياضية',
        imageUrl:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=2070',
        price: 180.0,
        discountPercentage: 10,
        finalPrice: 162.0,
        storeId: 4,
        storeName: 'شوز لاند',
        categoryId: 4,
        categoryName: 'أحذية وحقائب',
        rating: 4.0,
      ),
      ProductModel(
        id: 5,
        name: 'وجبة شاورما',
        description: 'وجبة شاورما لذيذة مع البطاطس والمشروبات',
        imageUrl:
            'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?q=80&w=2076',
        price: 45.0,
        finalPrice: 45.0,
        storeId: 5,
        storeName: 'مطعم الشرق',
        categoryId: 5,
        categoryName: 'مطاعم',
        rating: 4.7,
      ),
      ProductModel(
        id: 6,
        name: 'بنطلون جينز',
        description: 'بنطلون جينز عالي الجودة مناسب للاستخدام اليومي',
        imageUrl:
            'https://images.unsplash.com/photo-1542272604-787c3835535d?q=80&w=1926',
        price: 150.0,
        finalPrice: 150.0,
        storeId: 1,
        storeName: 'متجر الأناقة',
        categoryId: 1,
        categoryName: 'ملابس',
        rating: 4.3,
      ),
    ];

    // فلترة حسب القسم
    List<ProductModel> filteredProducts = categoryId != null
        ? allProducts
            .where((product) => product.categoryId == categoryId)
            .toList()
        : allProducts;

    // ترتيب المنتجات
    if (sortBy != null) {
      switch (sortBy) {
        case 'rating':
          filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
          break;

        case 'price_asc':
          filteredProducts.sort((a, b) => a.finalPrice.compareTo(b.finalPrice));
          break;
        case 'price_desc':
          filteredProducts.sort((a, b) => b.finalPrice.compareTo(a.finalPrice));
          break;
      }
    }

    return filteredProducts;
  }
}

// final productsProvider = FutureProvider<List<ProductModel>>((ref) {
//   return MockApiService().getProducts();
// });
