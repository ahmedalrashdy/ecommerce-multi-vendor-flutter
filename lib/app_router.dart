import 'package:ecommerce/features/cart/screens/cart_screen.dart';
import 'package:ecommerce/features/search/screens/search_screen.dart';
import 'package:ecommerce/features/stores/screens/store_screen.dart';
import 'package:ecommerce/features/wishlist/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce/main_screen.dart';
import 'package:ecommerce/core/consts/simple_cache_keys.dart';
import 'package:ecommerce/core/helpers/AppHelper.dart';
import 'core/blocs/auth/auth_notifiyer.dart';
import 'core/blocs/auth/auth_state.dart';
import 'core/consts/app_routes.dart';
import 'error_screen.dart';
import 'features/auth/auths_routes.dart';
import 'features/main/screens/home_screen.dart';
import 'features/main/screens/offer_details_screen.dart';
import 'features/orders/orders_routes.dart';
import 'features/stores/screens/stores_list_screen.dart';
import 'features/products/screens/product_details_screen.dart';
import 'features/products/screens/products_list_screen.dart';
import 'features/onboarding/views/onboarding_screen.dart';
import 'features/settings/settings_routes.dart';

class AppRouter {
  final SharedPreferences simpleCacheService = AppHelper.sharedPref;

  String? checkVerifyOTP() {
    final String? registerEmail =
        simpleCacheService.getString(SimpleCacheKeys.registerEmail);
    if (registerEmail != null) {
      return '${AppRoutes.verifyOtpScreen}?email=${Uri.encodeComponent(registerEmail)}';
    }
    return null;
  }

  String? _onBoardingGuard(bool seenOnboarding, String subloc, bool loggedIn) {
    if (!seenOnboarding && subloc != AppRoutes.onBoarding) {
      return AppRoutes.onBoarding;
    }
    if (seenOnboarding && subloc == AppRoutes.onBoarding) {
      print("Already seen onboarding, redirecting based on login status.");
      return loggedIn ? AppRoutes.mainScreen : AppRoutes.loginScreen;
    }
    return null;
  }

  String? _authRoutesGuard(String currentLocation, bool loggedIn) {
    if (loggedIn && authRoutes.contains(currentLocation)) {
      final String? registerEmail =
          simpleCacheService.getString(SimpleCacheKeys.registerEmail);
      if (currentLocation == AppRoutes.verifyOtpScreen &&
          registerEmail != null) {
        return null;
      }

      return AppRoutes.mainScreen;
    }
    return null;
  }

  String? _protectedRouteGuard(String subloc, bool loggedIn) {
    bool accessingShellRoute =
        protectedRoutes.any((shellRoute) => subloc.startsWith(shellRoute));

    if (!loggedIn && accessingShellRoute) {
      return AppRoutes.loginScreen;
    }
    return null;
  }

  final Set protectedRoutes = {
    AppRoutes.mainScreen,
  };

  final authRoutes = {
    AppRoutes.loginScreen,
    AppRoutes.registerScreen,
    AppRoutes.forgotPasswordScreen,
    AppRoutes.verifyOtpScreen,
    AppRoutes.resetPassword,
  };

  GoRouter get appRouter {
    return GoRouter(
      refreshListenable: AuthRouterNotifier(AppHelper.authBloc),
      initialLocation: AppRoutes.mainScreen,
      navigatorKey: AppHelper.rootNavigatorKey,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (BuildContext context, GoRouterState state,
              StatefulNavigationShell navigationShell) {
            return MainScreen(navigationShell: navigationShell);
          },
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoutes.mainScreen,
                  name: AppRoutes.mainScreenName,
                  builder: (BuildContext context, GoRouterState state) =>
                      HomeScreen(),
                  routes: [
                    GoRoute(
                      path: AppRoutes.homeScreen,
                      name: AppRoutes.homeScreenName,
                      builder: (BuildContext context, GoRouterState state) =>
                          const HomeScreen(),
                    ),
                    GoRoute(
                      path: '${AppRoutes.offerDetailsScreen}/:offerId',
                      name: AppRoutes.offerDetailsScreenName,
                      builder: (BuildContext context, GoRouterState state) {
                        final offerId = state.pathParameters['offerId'] ?? '';
                        return OfferDetailsScreen(offerId: offerId);
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoutes.cartScreen,
                  name: AppRoutes.cartScreenName,
                  builder: (BuildContext context, GoRouterState state) =>
                      CartScreen(),
                  routes: [],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoutes.wishlist,
                  name: AppRoutes.wishlistName,
                  builder: (BuildContext context, GoRouterState state) =>
                      WishlistScreen(),
                  routes: [],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoutes.orderList,
                  name: AppRoutes.orderListName,
                  builder: (BuildContext context, GoRouterState state) =>
                      Container(
                    child: Text("chats"),
                  ),
                  routes: [],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                    path: "/notification",
                    builder: (BuildContext context, GoRouterState state) =>
                        Container(
                          child: Text('notifaction'),
                        )),
              ],
            ),
          ],
        ),
        ...settingsRoutes,
        ...ordersRoutes,
        GoRoute(
          path: AppRoutes.storesListScreen,
          name: AppRoutes.storesListScreenName,
          builder: (BuildContext context, GoRouterState state) =>
              const StoresListScreen(),
        ),
        GoRoute(
          path: AppRoutes.storeDetailsScreen,
          name: AppRoutes.storeDetailsScreenName,
          builder: (BuildContext context, GoRouterState state) {
            String storeId = state.pathParameters['storeId']!;
            return StoreScreen(storeId: int.parse(storeId));
          },
        ),
        GoRoute(
          path: AppRoutes.productsListScreen,
          name: AppRoutes.productsListScreenName,
          builder: (BuildContext context, GoRouterState state) =>
              const ProductListScreen(),
        ),
        GoRoute(
          path: '${AppRoutes.productDetailsScreen}/:productId',
          name: AppRoutes.productDetailsScreenName,
          builder: (BuildContext context, GoRouterState state) {
            final productId = int.parse(state.pathParameters['productId']!);
            return ProductDetailScreen(
              productId: productId,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.searchScreen,
          name: AppRoutes.searchScreenName,
          builder: (BuildContext context, GoRouterState state) =>
              SearchScreen(),
        ),
        GoRoute(
          path: AppRoutes.onBoarding,
          name: AppRoutes.onBoardingName,
          builder: (context, state) => const OnboardingScreen(),
        ),
        ...authsRoutes,
      ],
      redirect: (context, state) {
        final bool seenOnboarding =
            simpleCacheService.getBool(SimpleCacheKeys.seenOnboarding) ?? false;
        final authBloc = AppHelper.authBloc;
        final bool loggedIn = authBloc.state is AuthAuthenticated;
        final String currentLocation = state.matchedLocation;
        final String subloc = state.uri.toString();
        return _onBoardingGuard(seenOnboarding, subloc, loggedIn) ??
            _protectedRouteGuard(subloc, loggedIn) ??
            _authRoutesGuard(currentLocation, loggedIn);
      },
      errorBuilder: (context, state) {
        return ErrorScreen(
            error: state.error?.toString() ?? "Unknown routing error");
      },
    );
  }
}
