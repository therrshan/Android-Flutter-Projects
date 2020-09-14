import 'dart:convert';
import 'dart:io';

import 'package:corona_tracker/models/country.dart';
import 'package:corona_tracker/widgets/bottom/bottomwidget.dart';
import 'package:corona_tracker/widgets/center/center.dart';
import 'package:corona_tracker/widgets/header/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  final SharedPreferences preferences;
  final Country selectedCountry;
  MyHomePage(
      {Key key, @required this.preferences, @required this.selectedCountry})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController;
  Country _selectedCountry;
  var loadedData;
  double _elevation = 0.0;
  bool _isLoading = true;

  _setSelectedCountry(Country country) {
    _selectedCountry = country;
    if (mounted) {
      setState(() {});
    }
    widget.preferences.setString('countryID', country.countryID);
    widget.preferences.setString('countryName', country.countryName);
    widget.preferences.setString('lat', country.lat);
    widget.preferences.setString('lng', country.lng);
  }

  _showIOSAlert(String message) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) {
        return CupertinoAlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              child: Text('RETRY'),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
                _getData();
              },
            )
          ],
        );
      },
    );
  }

  _showSnackBar(String message) {
    _globalKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'RETRY',
          onPressed: () => _getData(),
        ),
      ),
    );
  }

  _getData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    const baseURL = 'https://www.bing.com/covid/data';
    try {
      http.Response response = await http.get(baseURL);
      if (response.statusCode == 200) {
        loadedData = jsonDecode(response.body);
        _isLoading = false;
        if (mounted) {
          setState(() {});
        }
      } else {
        _isLoading = false;
        if (mounted) {
          setState(() {});
        }
        print(
            'Response body: ${response.body} || Response Code: ${response.statusCode}');
        if (Platform.isIOS) {
          _showIOSAlert('Failed to retreive latest data!');
        } else {
          _showSnackBar('Failed to retreive latest data!');
        }
      }
    } catch (e) {
      _isLoading = false;
      if (mounted) {
        setState(() {});
      }
      print(e);
      if (Platform.isIOS) {
        _showIOSAlert('Failed to retreive latest data!');
      } else {
        _showSnackBar('Failed to retreive latest data!');
      }
    }
  }

  @override
  void initState() {
    _selectedCountry = widget.selectedCountry;
    _scrollController = ScrollController();
    _scrollController?.addListener(() {
      if (_scrollController.offset >= 15.0) {
        _elevation = 5.0;
        if (mounted) {
          setState(() {});
        }
      } else {
        _elevation = 0.0;
        if (mounted) {
          setState(() {});
        }
      }
    });
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Colors.white,
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              backgroundColor: Colors.white,
              middle: Text(
                'CORONA TRACKER',
                style: TextStyle(color: Colors.black),
              ),
              transitionBetweenRoutes: true,
              trailing: GestureDetector(
                child: Icon(CupertinoIcons.refresh),
                onTap: _getData,
              ),
            )
          : AppBar(
              backgroundColor: Colors.white,
              elevation: _elevation,
              title: Text(
                'CORONA TRACKER',
                style: TextStyle(color: Colors.black),
              ),
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _getData,
                ),
              ],
            ),
      body: SafeArea(
        child: Container(
          child: _isLoading
              ? Center(
                  child: Platform.isIOS
                      ? CupertinoActivityIndicator(
                          animating: true,
                        )
                      : CircularProgressIndicator(),
                )
              : loadedData != null
                  ? ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 10.0,
                      ),
                      children: <Widget>[
                        Header(
                          totalCases: loadedData['totalConfirmed'].toString(),
                          recoveredCases:
                              loadedData['totalRecovered'].toString(),
                          fatalCases: loadedData['totalDeaths'].toString(),
                          areaList: loadedData['areas'],
                        ),
                        CenterWidget(
                          data: loadedData['areas'].singleWhere(
                              (i) => i['id'] == _selectedCountry.countryID),
                          setCountry: (Country country) =>
                              _setSelectedCountry(country),
                          countriesList: loadedData['areas'],
                        ),
                        BottomWidget(loadedData['areas']),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(CupertinoIcons.info),
                          SizedBox(height: 10.0),
                          Text('No Data'),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
