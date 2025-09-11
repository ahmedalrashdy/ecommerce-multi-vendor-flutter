import 'package:intl/intl.dart';

extension NumberFormatterExtension on num {
  String formatter(String locale) {
    final formatter = NumberFormat.compact(locale: locale);
    return formatter.format(this);
  }
}
