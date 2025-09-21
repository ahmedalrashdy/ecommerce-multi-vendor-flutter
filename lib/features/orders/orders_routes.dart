import 'package:ecommerce/core/consts/app_routes.dart';
import 'package:ecommerce/features/orders/screens/order_summary_screen.dart';
import 'package:go_router/go_router.dart';

final ordersRoutes = [
  GoRoute(
      path: AppRoutes.orderSummary,
      name: AppRoutes.orderSummaryName,
      builder: (ctx, state) {
        return OrderSummaryPage();
      }),
];
