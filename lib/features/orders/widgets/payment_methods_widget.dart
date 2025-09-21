import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PaymentMethod { cod, card, paypal, applepay, googlepay, wallet }

class PaymentMethodsWidget extends ConsumerStatefulWidget {
  const PaymentMethodsWidget({super.key});

  @override
  ConsumerState<PaymentMethodsWidget> createState() =>
      _PaymentMethodsWidgetState();
}

class _PaymentMethodsWidgetState extends ConsumerState<PaymentMethodsWidget> {
  PaymentMethod _selectedPayment = PaymentMethod.card;
  // Card fields
  final _cardNumberCtl = TextEditingController();
  final _cardNameCtl = TextEditingController();
  final _cardExpiryCtl = TextEditingController();
  final _cardCvvCtl = TextEditingController();

  // Form key (simple validation)
  final _formKey = GlobalKey<FormState>();

  Widget _paymentCard(PaymentMethod method, String label, {Widget? trailing}) {
    final selected = _selectedPayment == method;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent)),
      child: ListTile(
        onTap: () => setState(() => _selectedPayment = method),
        leading: Radio<PaymentMethod>(
          value: method,
          groupValue: _selectedPayment,
          onChanged: (v) => setState(() => _selectedPayment = v!),
        ),
        title: Text(label),
        trailing: trailing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('طريقة الدفع',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _paymentCard(PaymentMethod.cod, 'الدفع عند الاستلام (COD)'),
            _paymentCard(PaymentMethod.card, 'بطاقة دفع (Visa / MasterCard)',
                trailing: const Icon(Icons.credit_card)),
            _paymentCard(PaymentMethod.paypal, 'PayPal',
                trailing: const Icon(Icons.account_balance_wallet)),
            _paymentCard(PaymentMethod.applepay, 'Apple Pay',
                trailing: const Icon(Icons.phone_iphone)),
            _paymentCard(PaymentMethod.googlepay, 'Google Pay',
                trailing: const Icon(Icons.android)),
            _paymentCard(PaymentMethod.wallet, 'رصيد المحفظة/بطاقة افتراضية',
                trailing: const Icon(Icons.account_balance)),
            if (_selectedPayment == PaymentMethod.card) ...[
              const SizedBox(height: 8),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _cardNumberCtl,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'رقم البطاقة'),
                      maxLength: 19,
                      validator: (v) => (v == null || v.trim().length < 12)
                          ? 'رقم البطاقة غير صالح'
                          : null,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cardNameCtl,
                            decoration: const InputDecoration(
                                labelText: 'اسم حامل البطاقة'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _cardExpiryCtl,
                            decoration:
                                const InputDecoration(labelText: 'MM/YY'),
                            maxLength: 5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 100,
                          child: TextFormField(
                            controller: _cardCvvCtl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'CVV'),
                            maxLength: 4,
                            validator: (v) => (v == null || v.trim().length < 3)
                                ? 'CVV غير صالح'
                                : null,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
