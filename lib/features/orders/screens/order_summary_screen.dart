import 'package:ecommerce/features/orders/widgets/payment_methods_widget.dart';
import 'package:ecommerce/features/orders/widgets/products_summary_list.dart';
import 'package:flutter/material.dart';

import '../widgets/order_shipping_address.dart';

// Single-file Flutter UI: Order Summary (Arabic, modern & elegant)
// Save as `main.dart` and run with `flutter run`.

class Product {
  final String name;
  final String image;
  int qty;
  final double price;

  Product({
    required this.name,
    required this.image,
    required this.qty,
    required this.price,
  });
}

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  final List<Product> _cart = [
    Product(
      name: 'قميص قطن أنيق',
      image: 'https://picsum.photos/seed/shirt/200/200',
      qty: 1,
      price: 29.99,
    ),
    Product(
      name: 'سماعة لاسلكية',
      image: 'https://picsum.photos/seed/headset/200/200',
      qty: 2,
      price: 49.50,
    ),
  ];

  // Pricing rules (example)
  double shipping = 5.0;
  double taxRate = 0.07; // 7%

  // Coupon
  String appliedCoupon = '';
  double couponValue = 0; // absolute discount

  // Address
  String shippingAddress = 'شارع النصر، صنعاء، اليمن';

  // Payment

  // Promo
  final _promoCtl = TextEditingController();

  // Note
  final _noteCtl = TextEditingController();

  bool _processing = false;

  double get subtotal => _cart.fold(0.0, (p, e) => p + e.price * e.qty);

  double get discount => couponValue;

  double get tax => (subtotal - discount) * taxRate;

  double get total => subtotal - discount + shipping + tax;

  String money(double v) => '${v.toStringAsFixed(2)} \$';

  @override
  void dispose() {
    _promoCtl.dispose();
    _noteCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مراجعة الطلب'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Products list
              ProductsSummaryList(),
              const SizedBox(height: 12),

              // Shipping Address
              OrderShippingAddress(),
              const SizedBox(height: 12),
              PaymentMethodsWidget(),
              const SizedBox(height: 12),

              // Price breakdown
              Card(
                color: Colors.grey[50],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('ملخص السعر',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800])),
                      const SizedBox(height: 12),
                      _buildPriceRow('المجموع الجزئي', money(subtotal)),
                      const SizedBox(height: 6),
                      _buildPriceRow('الخصم', '- ${money(discount)}'),
                      const SizedBox(height: 6),
                      _buildPriceRow('الشحن', money(shipping)),
                      const SizedBox(height: 6),
                      _buildPriceRow('الضرائب', money(tax)),
                      const Divider(height: 20, thickness: 1.2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('الإجمالي النهائي',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(money(total),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                          'سيُخصم من البطاقة أو يُدفع عند الاستلام حسب طريقة الدفع المختارة',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Place Order
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: _processing
                      ? const CircularProgressIndicator.adaptive()
                      : const Text('تأكيد الدفع / Place Order',
                          style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Text(value, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  void _showTerms() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('شروط الخدمة'),
        content:
            const Text('هذه أمثلة لشروط الخدمة. ضع نص شروطك الحقيقية هنا.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إغلاق'))
        ],
      ),
    );
  }

  void _showRefund() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('سياسة الاسترجاع'),
        content: const Text(
            'مثال: يمكنك استرجاع المنتج خلال 14 يوماً بشرط الحالة الأصلية.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إغلاق'))
        ],
      ),
    );
  }
}

class OrderSuccessPage extends StatelessWidget {
  final double total;
  const OrderSuccessPage({super.key, required this.total});

  String money(double v) => '${v.toStringAsFixed(2)} \$';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('نجاح الطلب'), automaticallyImplyLeading: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 84, color: Colors.green),
              const SizedBox(height: 12),
              const Text('تم إنشاء طلبك بنجاح!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('الإجمالي المدفوع: ${''}' + money(total),
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  child: const Text('العودة إلى المتجر'))
            ],
          ),
        ),
      ),
    );
  }
}
