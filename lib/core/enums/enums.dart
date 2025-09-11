enum AsyncStatus {
  idle,
  loading,
  success,
  failure,
}

enum AppExceptionType {
  network,
  server,
  auth,
  validation,
  notFound,
  badResponse,
  cancel,
  unknown,
  cacheException
}

enum SupportedLangs {
  system("system", "لغة النظام"),
  arabic("ar", "العربية"),
  english("en", "الإنجليزية");

  const SupportedLangs(this.value, this.displayName);

  final String value;
  final String displayName;

  static SupportedLangs fromValue(String value) {
    return SupportedLangs.values.firstWhere((e) => e.value == value);
  }
}
