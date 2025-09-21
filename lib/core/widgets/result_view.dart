import 'package:ecommerce/core/enums/enums.dart'; // افترض وجود هذا الملف
import 'package:flutter/material.dart';

typedef SuccessWidgetBuilder<T> = Widget Function(BuildContext context, T data);
typedef ErrorWidgetBuilder = Widget Function(
    BuildContext context, String? message);
typedef WidgetBuilderFunction = Widget Function(BuildContext context);

class ResultView<T> extends StatelessWidget {
  const ResultView({
    super.key,
    required this.status,
    required this.successBuilder,
    this.data,
    this.errorMessage,
    this.errorBuilder,
    this.emptyBuilder,
    this.idleBuilder,
    this.loadingBuilder,
  });

  final AsyncStatus status;
  final T? data;
  final String? errorMessage;

  final SuccessWidgetBuilder<T> successBuilder;
  final ErrorWidgetBuilder? errorBuilder;
  final WidgetBuilderFunction? idleBuilder;
  final WidgetBuilderFunction? loadingBuilder;
  final WidgetBuilderFunction? emptyBuilder;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case AsyncStatus.idle:
        return idleBuilder?.call(context) ?? const SizedBox.shrink();

      case AsyncStatus.loading:
        return loadingBuilder?.call(context) ??
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            );

      case AsyncStatus.success:
        if (data == null) {
          return emptyBuilder?.call(context) ??
              const Center(
                child: Text('لا توجد بيانات لعرضها'),
              );
        }

        return successBuilder(context, data as T);

      case AsyncStatus.failure:
        return errorBuilder?.call(context, errorMessage) ??
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(errorMessage ?? 'حدث خطأ غير معروف'),
              ),
            );
    }
  }
}
