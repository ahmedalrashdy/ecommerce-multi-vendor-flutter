import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecommerce/core/extensions/app_theme_extension.dart';

class OTPInput extends StatefulWidget {
  final int length;
  final Function(String otp) onSubmit;
  final bool hasError;

  const OTPInput({
    super.key,
    this.length = 6, // الطول الافتراضي 6
    required this.onSubmit,
    this.hasError = false,
  });

  @override
  State<OTPInput> createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _controllers =
        List.generate(widget.length, (index) => TextEditingController());

    for (int i = 0; i < widget.length; i++) {
      _controllers[i].addListener(() => _onInputChanged(i));
    }
  }

  void _onInputChanged(int index) {
    if (_controllers[index].text.length == 1 && index < widget.length - 1) {
      // الانتقال إلى الحقل التالي
      _focusNodes[index + 1].requestFocus();
    }

    // تجميع الكود عند اكتمال الإدخال
    if (_controllers.every((controller) => controller.text.isNotEmpty)) {
      final otp = _controllers.map((c) => c.text).join();
      widget.onSubmit(otp);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Widget _buildPinBox(int index) {
    // تحديد لون الحدود بناءً على الحالة
    Color borderColor;
    if (widget.hasError) {
      borderColor = context.colors.error;
    } else if (_focusNodes[index].hasFocus) {
      borderColor = context.colors.primary;
    } else {
      borderColor = context.colors.onSurface.withOpacity(0.2);
    }

    return Container(
      width: 50,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: _focusNodes[index].hasFocus || widget.hasError ? 2.0 : 1.5,
        ),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        // السماح بحرف واحد فقط
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: TextStyle(
          fontSize: 22,
          color: context.colors.onSurface,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: "", // إخفاء عداد الأحرف
        ),
        onChanged: (value) {
          if (value.isEmpty && index > 0) {
            // الرجوع إلى الحقل السابق عند الحذف
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(widget.length, (index) => _buildPinBox(index)),
      ),
    );
  }
}
