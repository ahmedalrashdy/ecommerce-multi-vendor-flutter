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

enum YemeniCity {
  all("الكل", "all"),
  sanaa("صنعاء", "Sana'a"),
  aden("عدن", "Aden"),
  taiz("تعز", "Taiz"),
  ibb("إب", "Ibb"),
  hodeidah("الحديدة", "Al Hudaydah"),
  hadramout("حضرموت", "Hadhramaut"),
  lahj("لحج", "Lahij"),
  dhale("الضالع", "Al Dhale'e"),
  shabwah("شبوة", "Shabwah"),
  mahd("المهرة", "Al Mahrah"),
  marib("مأرب", "Marib"),
  aljawf("الجوف", "Al Jawf"),
  amran("عمران", "Amran"),
  hajjah("حجة", "Hajjah"),
  sadah("صعدة", "Sa'dah"),
  raymah("ريمة", "Raymah"),
  albaidha("البيضاء", "Al Bayda"),
  dhamar("ذمار", "Dhamar"),
  socotra("سقطرى", "Socotra"),
  almhweet("المحويت", "Al Mahwit"),
  abyan("أبين", "Abyan");

  final String ar;
  final String en;

  const YemeniCity(this.ar, this.en);
}

enum ProductSortBy {
  topRated("الأعلى تقييماً", "Top Rated", 'top-rated'),
  topSale("الأكثر مبيعاً", "Top Sale", 'top-sale'),
  recent("الأحدث", "Recent", 'recent');

  final String ar;
  final String en;
  final String searchValue;
  const ProductSortBy(this.ar, this.en, this.searchValue);
}

enum StoreSortBy {
  topRated("الأعلى تقييماً", "Top Rated", 'top-rated'),
  recent("الأحدث", "Recent", 'recent');

  final String ar;
  final String en;
  final String searchValue;
  const StoreSortBy(this.ar, this.en, this.searchValue);
}
