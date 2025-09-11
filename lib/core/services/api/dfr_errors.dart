
class DrfErrors {
  final Map<String, List<String>> errors;

  DrfErrors._(this.errors);

  factory DrfErrors.fromJson(dynamic json) {
    final Map<String, List<String>> flattenedErrors = {};

    if (json is String) {
      flattenedErrors['detail'] = [json];
    } else if (json is Map<String, dynamic>) {
      if (json.containsKey('detail') &&
          json.length == 1 &&
          json['detail'] is String) {
        flattenedErrors['detail'] = [json['detail'] as String];
      } else {
        _flattenMap(json, flattenedErrors, '');
      }
    } else if (json is List<dynamic>) {
      _flattenList(json, flattenedErrors, '');
    } else {
      flattenedErrors['unknown_error'] = ['Unexpected error format received.'];
    }

    return DrfErrors._(flattenedErrors);
  }

  static void _flattenMap(
    Map<String, dynamic> source,
    Map<String, List<String>> destination,
    String prefix,
  ) {
    source.forEach((key, value) {
      final newKey = prefix.isEmpty ? key : '$prefix.$key';
      if (value is List) {
        destination[newKey] = value.cast<String>();
      } else if (value is Map<String, dynamic>) {
        _flattenMap(value, destination, newKey);
      } else if (value is String) {
        destination[newKey] = [value];
      }
    });
  }

  static void _flattenList(
    List<dynamic> source,
    Map<String, List<String>> destination,
    String prefix,
  ) {
    for (int i = 0; i < source.length; i++) {
      final item = source[i];
      final newPrefix = prefix.isEmpty ? '$i' : '$prefix.$i';

      if (item is Map<String, dynamic>) {
        _flattenMap(item, destination, newPrefix);
      } else if (item is List && item.isNotEmpty) {
        destination[newPrefix] = item.cast<String>();
      } else if (item is String) {
        destination[newPrefix] = [item];
      }
    }
  }

  bool get hasMessages => errors.isNotEmpty;

  String get allMessages {
    if (!hasMessages) return "An unexpected error occurred.";

    // الأولوية لرسائل 'detail' أو 'non_field_errors' كرسالة عامة
    if (errors.containsKey('detail')) {
      return errors['detail']!.join('\n');
    }
    if (errors.containsKey('non_field_errors')) {
      return errors['non_field_errors']!.join('\n');
    }
    if (errors.containsKey('error')) {
      return errors['error']!.join('\n');
    }

    // إذا لم تكن هناك رسائل عامة، اجمع رسائل الحقول
    return errors.entries.map((e) {
      return '${_formatFieldName(e.key)}: ${e.value.join(", ")}';
    }).join('\n');
  }

  // Helper to make field names more readable for display
  String _formatFieldName(String key) {
    return key
        .split('.')
        .map((part) =>
            part.isNotEmpty ? part[0].toUpperCase() + part.substring(1) : '')
        .join(' ');
  }
}
