import 'dart:convert';
import 'dart:io';

import 'package:corona_tracker/models/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ChooseCountry extends StatefulWidget {
  final List<dynamic> areaList;
  ChooseCountry({this.areaList});
  @override
  _ChooseCountryState createState() => _ChooseCountryState();
}

class _ChooseCountryState extends State<ChooseCountry>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

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
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                //Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<List<Country>> _getCountries() async {
    List<Country> list = [];
    if (widget.areaList != null) {
      widget.areaList.forEach((f) {
        list.add(
          Country(
            countryName: f['displayName'],
            countryID: f['id'],
            lat: f['lat'].toString(),
            lng: f['long'].toString(),
          ),
        );
      });
      //print(list);
      list.sort((a, b) => a.countryName.compareTo(b.countryName));
      return list;
    } else {
      const baseURL = 'https://www.bing.com/covid/data';
      var loadedData;
      try {
        http.Response response = await http.get(baseURL);
        if (response.statusCode == 200) {
          loadedData = jsonDecode(response.body);
          loadedData['areas'].forEach((f) {
            //print(f);
            list.add(
              Country(
                countryName: f['displayName'],
                countryID: f['id'],
                lat: f['lat'].toString(),
                lng: f['long'].toString(),
              ),
            );
          });
          //print(list);
          list.sort((a, b) => a.countryName.compareTo(b.countryName));
          return list;
        } else {
          print(
              'Response body: ${response.body} || Response Code: ${response.statusCode}');
          if (Platform.isIOS) {
            _showIOSAlert(
                'Failed to get list of available countries! Please try again after some time.');
          } else {
            Navigator.pop(context);
            Fluttertoast.showToast(
                msg:
                    'Failed to get list of available countries! Please try again after some time.');
          }
        }
      } catch (e) {
        print(e);
        if (Platform.isIOS) {
          _showIOSAlert(
              'Failed to get list of available countries! Please try again after some time.');
        } else {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg:
                  'Failed to get list of available countries! Please try again after some time.');
        }
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: Text('Choose country'),
              previousPageTitle: 'Back',
            )
          : AppBar(
              title: Text('Choose country'),
            ),
      body: FutureBuilder<List<Country>>(
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.done) {
            return ListView.builder(
                itemBuilder: (ctx, index) {
                  return ListTile(
                    title: Text(
                      snap.data[index].countryName,
                    ),
                    onTap: () => Navigator.pop(
                      context,
                      Country(
                        countryName: snap.data[index].countryName,
                        countryID: snap.data[index].countryID,
                        lat: snap.data[index].lat,
                        lng: snap.data[index].lng,
                      ),
                    ),
                    trailing: Icon(Icons.navigate_next),
                  );
                },
                itemCount: snap.data.length);
          } else {
            return Container(
              child: Center(
                child: Platform.isIOS
                    ? CupertinoActivityIndicator(
                        animating: true,
                      )
                    : CircularProgressIndicator(),
              ),
            );
          }
        },
        initialData: <Country>[],
        future: _getCountries(),
      ),
    );
  }
}
