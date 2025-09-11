import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/enums/enums.dart';
import 'custom_button.dart';

class ResendOtpTimer extends StatefulWidget {
  final VoidCallback onResend;
  final int initialCooldown; // تغيير الاسم ليكون أوضح
  final AsyncStatus resendStatus;

  const ResendOtpTimer({
    super.key,
    required this.onResend,
    required this.resendStatus,
    this.initialCooldown = 60, // قيمة افتراضية
  });

  @override
  State<ResendOtpTimer> createState() => _ResendOtpTimerState();
}

class _ResendOtpTimerState extends State<ResendOtpTimer> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialCooldown;
    if (_remainingSeconds > 0) {
      _startTimer();
    }
  }

  // يتم استدعاؤه عندما تتغير الخصائص القادمة من الـ parent widget
  @override
  void didUpdateWidget(covariant ResendOtpTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // إذا تغيرت فترة الانتظار (مثلاً بعد استجابة من السيرفر)
    if (widget.initialCooldown != oldWidget.initialCooldown) {
      _resetAndStartTimer(widget.initialCooldown);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel(); // إلغاء المؤقت القديم إذا كان موجودًا
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        if (mounted) {
          setState(() => _remainingSeconds--);
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _resetAndStartTimer(int seconds) {
    if (mounted) {
      setState(() {
        _remainingSeconds = seconds;
      });
      _startTimer();
    }
  }

  void _handleResend() {
    // التأكد من أن الزر غير نشط أثناء التحميل أو العد التنازلي
    if (_remainingSeconds > 0 || widget.resendStatus == AsyncStatus.loading) {
      return;
    }

    // استدعاء دالة إعادة الإرسال من الـ Cubit
    widget.onResend();

    // ملاحظة: المؤقت سيعاد تشغيله من خلال didUpdateWidget عند وصول `cooldownSeconds` جديدة
    // أو يمكننا إعادة تعيينه هنا بقيمة افتراضية
    _resetAndStartTimer(
        widget.initialCooldown > 0 ? widget.initialCooldown : 60);
  }

  String _formatTime(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final bool canResend = _remainingSeconds <= 0;

    // بناء نص الزر بناءً على الحالة
    String buttonTitle;
    if (!canResend) {
      buttonTitle = 'إعادة الإرسال خلال (${_formatTime(_remainingSeconds)})';
    } else {
      buttonTitle = 'إعادة إرسال الرمز';
    }

    return CustomButton(
      onPressed: canResend ? _handleResend : null,
      isLoading: widget.resendStatus == AsyncStatus.loading,
      title: buttonTitle,
    );
  }
}
