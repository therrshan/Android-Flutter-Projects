import 'dart:io';

import 'package:corona_tracker/models/country.dart';
import 'package:corona_tracker/pages/setcountry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';

class InitialPage extends StatelessWidget {
  _initialSetup(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String countryID = sharedPreferences.getString('countryID');
    String countryName = sharedPreferences.getString('countryName');
    String lat = sharedPreferences.getString('lat');
    String lng = sharedPreferences.getString('lng');
    if (countryID != null &&
        countryName != null &&
        lat != null &&
        lng != null) {
      Country country = Country(
          countryName: countryName, countryID: countryID, lat: lat, lng: lng);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => MyHomePage(
            preferences: sharedPreferences,
            selectedCountry: country,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => SetCountry(sharedPreferences),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _initialSetup(context);
    return Scaffold(
      body: Container(
          child: Center(
        child: Platform.isIOS
            ? CupertinoActivityIndicator(
                animating: true,
              )
            : CircularProgressIndicator(),
      )),
    );
  }
}
