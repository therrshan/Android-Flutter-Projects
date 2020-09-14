import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WorldOnMap extends StatefulWidget {
  final List<dynamic> areasList;
  WorldOnMap(this.areasList);
  @override
  _WorldOnMapState createState() => _WorldOnMapState();
}

class _WorldOnMapState extends State<WorldOnMap> {
  List<Circle> _circles = [];
  List<EarthModel> _data = [];
  bool _isLoading = true;
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(39.495914459228516, -98.98998260498047),
    zoom: 5,
  );

  _prepareData() {
    widget.areasList.forEach((f) {
      _data.add(EarthModel(
        id: f['id'],
        name: f['displayName'],
        lat: f['lat'].toString(),
        lng: f['long'].toString(),
        isCountry: true,
        confirmed: f['totalConfirmed'].toString(),
        recovered: f['totalRecovered'].toString(),
        deaths: f['totalDeaths'].toString(),
      ));
      f['areas'].forEach((g) {
        _data.add(EarthModel(
          id: g['id'],
          name: g['displayName'],
          lat: g['lat'].toString(),
          lng: g['long'].toString(),
          isCountry: false,
          confirmed: g['totalConfirmed'].toString(),
          recovered: g['totalRecovered'].toString(),
          deaths: g['totalDeaths'].toString(),
        ));
      });
    });
    _prepareCircles();
  }

  _prepareCircles() {
    _data.forEach((f) {
      _circles.add(
        Circle(
          circleId: CircleId(f.id),
          center: LatLng(
            double.parse(f.lat),
            double.parse(f.lng),
          ),
          fillColor: f.isCountry ? Colors.red : Colors.orange,
          consumeTapEvents: true,
          strokeColor: f.isCountry ? Colors.redAccent : Colors.orangeAccent,
          radius: f.isCountry ? 40000 : 20000,
          onTap: () {
            _showBottomSheet(f);
          },
        ),
      );
    });
    _isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  _showBottomSheet(EarthModel f) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (ctx) => CupertinoPopupSurface(
          child: Material(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(230),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 10.0,
                right: 10.0,
                bottom: 30.0,
              ),
              child: Wrap(
                children: <Widget>[
                  Text(
                    f.name,
                    style: Theme.of(context).textTheme.title,
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                              colors: [Colors.black, Colors.black54],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Total Cases',
                                style: Theme.of(context)
                                    .textTheme
                                    .title
                                    .apply(color: Colors.white),
                              ),
                              Text(
                                f.confirmed != 'null' ? f.confirmed : '-',
                                style: Theme.of(context)
                                    .textTheme
                                    .display1
                                    .apply(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.blueGrey],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Active Cases',
                                style: Theme.of(context)
                                    .textTheme
                                    .title
                                    .apply(color: Colors.white),
                              ),
                              Text(
                                f.confirmed != 'null' &&
                                        f.deaths != 'null' &&
                                        f.recovered != 'null'
                                    ? (int.parse(f.confirmed) -
                                            int.parse(f.recovered) -
                                            int.parse(f.deaths))
                                        .toString()
                                    : '-',
                                style: Theme.of(context)
                                    .textTheme
                                    .display1
                                    .apply(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  //SizedBox(height: 10.0),
                  Container(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                              colors: [Colors.green, Colors.lightGreen],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Recovered',
                                style: Theme.of(context)
                                    .textTheme
                                    .title
                                    .apply(color: Colors.white),
                              ),
                              Text(
                                f.recovered != 'null' ? f.recovered : '-',
                                style: Theme.of(context)
                                    .textTheme
                                    .display1
                                    .apply(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                              colors: [Colors.red, Colors.redAccent],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Fatal Cases',
                                style: Theme.of(context)
                                    .textTheme
                                    .title
                                    .apply(color: Colors.white),
                              ),
                              Text(
                                f.deaths != 'null' ? f.deaths : '-',
                                style: Theme.of(context)
                                    .textTheme
                                    .display1
                                    .apply(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(230),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: Wrap(
              children: <Widget>[
                Text(
                  f.name,
                  style: Theme.of(context).textTheme.title,
                ),
                Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: LinearGradient(
                            colors: [Colors.black, Colors.black54],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Total Cases',
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .apply(color: Colors.white),
                            ),
                            Text(
                              f.confirmed != 'null' ? f.confirmed : '-',
                              style: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .apply(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: LinearGradient(
                            colors: [Colors.blue, Colors.blueGrey],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Active Cases',
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .apply(color: Colors.white),
                            ),
                            Text(
                              f.confirmed != 'null' &&
                                      f.deaths != 'null' &&
                                      f.recovered != 'null'
                                  ? (int.parse(f.confirmed) -
                                          int.parse(f.recovered) -
                                          int.parse(f.deaths))
                                      .toString()
                                  : '-',
                              style: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .apply(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //SizedBox(height: 10.0),
                Container(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: LinearGradient(
                            colors: [Colors.green, Colors.lightGreen],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Recovered',
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .apply(color: Colors.white),
                            ),
                            Text(
                              f.recovered != 'null' ? f.recovered : '-',
                              style: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .apply(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: LinearGradient(
                            colors: [Colors.red, Colors.redAccent],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Fatal Cases',
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .apply(color: Colors.white),
                            ),
                            Text(
                              f.deaths != 'null' ? f.deaths : '-',
                              style: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .apply(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _prepareData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialCamera,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              circles: Set.from(_circles),
              buildingsEnabled: true,
              compassEnabled: false,
              mapToolbarEnabled: false,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
            ),
            Positioned(
              top: 50.0,
              left: 10.0,
              child: SizedBox(
                height: 40.0,
                width: 40.0,
                child: FloatingActionButton(
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: Colors.white,
                  child: Icon(Icons.arrow_back, color: Colors.blue),
                ),
              ),
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class EarthModel {
  String name;
  String id;
  String lat;
  String lng;
  String confirmed;
  String recovered;
  String deaths;
  bool isCountry;
  EarthModel({
    @required this.name,
    @required this.id,
    @required this.lat,
    @required this.lng,
    @required this.isCountry,
    this.confirmed,
    this.recovered,
    this.deaths,
  });
}
