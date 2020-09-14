import 'package:flutter/foundation.dart';

class Country {
  String countryName;
  String countryID;
  String lat;
  String lng;
  Country({
    @required this.countryName,
    @required this.countryID,
    @required this.lat,
    @required this.lng,
  });
}
