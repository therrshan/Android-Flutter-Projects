import 'package:corona_tracker/models/country.dart';
import 'package:corona_tracker/pages/choosecountry.dart';
import 'package:corona_tracker/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetCountry extends StatefulWidget {
  final SharedPreferences preferences;
  SetCountry(this.preferences);
  @override
  _SetCountryState createState() => _SetCountryState();
}

class _SetCountryState extends State<SetCountry>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Text(
                'CORONA TRACKER',
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .apply(color: Colors.black54, fontFamily: 'Exo2'),
              ),
              Expanded(
                child: Container(
                  child: Image.asset(
                    'assets/doctors.jpg',
                    width: 350,
                    height: 200,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  _selectedCountry = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => ChooseCountry(),
                    ),
                  );
                  if (mounted) {
                    setState(() {});
                  }
                },
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.0,
                        color: _selectedCountry != null
                            ? Colors.blue
                            : Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _selectedCountry != null
                              ? _selectedCountry.countryName
                              : 'Tap here to choose your country...',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: _selectedCountry != null
                                  ? Colors.black
                                  : Colors.black38),
                        ),
                      ),
                      _selectedCountry != null
                          ? GestureDetector(
                              onTap: () {
                                widget.preferences.setString(
                                    'countryID', _selectedCountry.countryID);
                                widget.preferences.setString('countryName',
                                    _selectedCountry.countryName);
                                widget.preferences
                                    .setString('lat', _selectedCountry.lat);
                                widget.preferences
                                    .setString('lng', _selectedCountry.lng);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => MyHomePage(
                                      selectedCountry: _selectedCountry,
                                      preferences: widget.preferences,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 50.0,
                                width: 50.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5.0),
                                      bottomRight: Radius.circular(5.0),
                                    ),
                                    color: Colors.blue),
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
