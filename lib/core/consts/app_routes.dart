abstract class AppRoutes {
  // Onboarding
  static const String onBoarding = '/onboarding';
  static const String onBoardingName = 'onboarding';

  // Auth
  static const String loginScreen = '/login';
  static const String loginScreenName = 'login';

  static const String registerScreen = '/register';
  static const String registerScreenName = 'register';

  static const String forgotPasswordScreen = '/forgot-password';
  static const String forgotPasswordScreenName = 'forgotPassword';

  static const String verifyOtpScreen = '/verify-otp';
  static const String verifyOtpScreenName = 'verifyOtp';

  static const String resetPassword = '/reset-password';
  static const String resetPasswordName = 'resetPassword';

  //settings
  static const String settingsName = 'settings';
  static const String privacySetting = '/settings/privacy';

  //main
  static const String mainScreen = '/main-screen';
  static const String mainScreenName = 'main-screen-name';

  //wishlist
  static const String wishlist = '/wishlist';
  static const String wishlistName = 'wishlist';

  //cart
  static const String cartScreen = '/cartScreen';
  static const String cartScreenName = 'cartScreenName';

  // Home Features
  static const String homeScreen = '/home';
  static const String homeScreenName = 'home';

  // Offers
  static const String offerDetailsScreen = 'offer-details';
  static const String offerDetailsScreenName = 'offer-details';

  // Stores
  static const String storesListScreen = '/stores';
  static const String storesListScreenName = 'stores';
  static const String storeDetailsScreen = '/store-details/:storeId';
  static const String storeDetailsScreenName = 'store-details';

  // Products
  static const String productsListScreen = '/products';
  static const String productsListScreenName = 'products';
  static const String productDetailsScreen = '/product-details';
  static const String productDetailsScreenName = 'product-details';

  //address
  static const String userAddresses = 'user-addresses';
  static const String userAddressesName = 'user-addresses-name';
  static const String createEditUserAddressScreen = 'create-edit-user-address';
  static const String createEditUserAddressScreenName =
      'create-edit-user-address-name';

  //orders
  static const String orderList = '/orders';
  static const String orderListName = 'orders-list';
  static const String orderSummary = '/orderSummary';
  static const String orderSummaryName = 'orderSummaryName';

  //search
  static const String searchScreen = '/searchScreen';
  static const String searchScreenName = 'searchScreenName';
}
