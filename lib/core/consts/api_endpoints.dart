import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class ApiEndpoint {
  static String APIBaseURL = "${dotenv.env['IP']}/api/v1/";
  //Auth
  static const String login = "auth/login/";
  static const String register = "auth/register/";
  static const String verifyEmail = "auth/verify-email/";
  static const String verifyResetPasswordOTP =
      "auth/verify-reset-password-otp/";
  static const String resendOTP = "auth/resend-otp/";
  static const String resetPassword = "auth/reset-password/";
  static const String changePassword = "auth/change-password/";
  static const String logout = "auth/logout/";
  static const String confirmResetPassword = "auth/confirm-reset-password/";

  //products
  static const String featuredProducts = "products/";
  static const String featuredPlatformCategories =
      "platform-categories/featured/";
  static String productDetails(int productId) => "products/$productId/";

  //wishlist
  ///1---products
  static String removeProductFromWishlist(int productId) =>
      "wishlist/remove-product-from-wishlist/$productId/";
  static const String productWishLists = "wishlist/products/";
  static const String wishlistProductIds = "wishlist/products-ids/";
  static const String addProductToWishlist =
      "wishlist/add-product-to-wishlist/";

  ///1---store
  static String removeStoreFromWishlist(int storeId) =>
      "wishlist/remove-store-from-wishlist/$storeId/";
  static const String storeWishLists = "wishlist/stores/";
  static const String wishlistStoreIds = "wishlist/stores-ids/";
  static const String addStoreToWishlist = "wishlist/add-store-to-wishlist/";

  //stores
  static const String stores = "stores/";
  static String storeDetail(int storeId) => "stores/$storeId/";
  static String storeProductCategories(int storeId) =>
      'stores/$storeId/categories/';
  static String storeProducts(int storeId) => 'stores/$storeId/products/';

  //cart
  static const String cartList = 'cart/';
  static const String cartAddItem = 'cart/add/';
  static String cartUpdateItem(int id) => 'cart/items/$id/';
  static String cartDeleteItem(int id) => 'cart/items/$id/delete/';

  //addresses
  static const String userAddresses = '/auth/addresses/';
  static String setDefaultAddress(int id) => '/auth/addresses/$id/set-default/';
  static String addressDetail(int id) => '/auth/addresses/$id/';

  //search
  static const String productSearch = '/products/search/';
  static const String storeSearch = '/stores/search/';
}
