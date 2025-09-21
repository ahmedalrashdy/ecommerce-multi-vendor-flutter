import 'package:google_maps_flutter/google_maps_flutter.dart';

enum YemeniCity {
  sanaa("صنعاء", LatLng(15.3694, 44.1910)),
  aden("عدن", LatLng(12.7794, 45.0367)),
  taiz("تعز", LatLng(13.5785, 44.0226)),
  hodeidah("الحديدة", LatLng(14.8021, 42.9520)),
  ibb("إب", LatLng(13.9667, 44.1833)),
  mukalla("المكلا", LatLng(14.5424, 49.1281)),
  dhamar("ذمار", LatLng(14.5500, 44.4000)),
  amran("عمران", LatLng(15.6594, 43.9439)),
  hajjah("حجة", LatLng(15.6900, 43.5990)),
  mahdah("المحويت", LatLng(15.4700, 43.5500)),
  sadah("صعدة", LatLng(16.9400, 43.7630)),
  aljawf("الجوف", LatLng(16.6100, 44.4000)),
  maarib("مأرب", LatLng(15.4700, 45.3200)),
  shabwa("شبوة", LatLng(14.5417, 46.8333)),
  albaidha("البيضاء", LatLng(14.3586, 45.4519)),
  raymah("ريمة", LatLng(14.6731, 43.5990)),
  lahj("لحج", LatLng(13.0567, 44.8819)),
  abyann("أبين", LatLng(13.6000, 46.0833)),
  aldhale("الضالع", LatLng(13.6957, 44.7306)),
  hadramout("حضرموت", LatLng(15.9500, 48.7830)),
  socotra("سقطرى", LatLng(12.4634, 53.8236));

  // يمكنك إضافة مراكز أصغر لاحقًا (مدن ثانوية مثل يريم، رداع، عتق...)

  const YemeniCity(this.arabicName, this.coordinates);
  final String arabicName;
  final LatLng coordinates;

  /// دالة مساعدة للبحث عن مدينة بالاسم العربي
  static YemeniCity? fromString(String cityName) {
    for (var city in YemeniCity.values) {
      if (cityName.contains(city.arabicName)) {
        return city;
      }
    }
    return null;
  }
}
