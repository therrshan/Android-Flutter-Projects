import 'dart:io';

import 'package:corona_tracker/pages/countryspecific.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorldData extends StatelessWidget {
  final List<dynamic> tempList;
  WorldData(this.tempList);

  @override
  Widget build(BuildContext context) {
    List<dynamic> dataList = [];
    dataList.addAll(tempList);
    if (dataList.isNotEmpty) {
      dataList.sort(
        (a, b) => a['displayName'].compareTo(
          b['displayName'],
        ),
      );
    }
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: Text('World'),
              previousPageTitle: 'Home',
            )
          : AppBar(
              title: Text('World'),
            ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return ListTile(
              title: Text(
                dataList[index]['displayName'],
              ),
              trailing: Icon(Icons.navigate_next),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CountrySpecific(
                    dataList[index]['areas'],
                    dataList[index]['displayName'],
                    'Back',
                  ),
                ),
              ),
              subtitle: Row(
                children: <Widget>[
                  dataList[index]['totalConfirmed'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                              vertical: 3.0,
                            ),
                            color: Colors.black,
                            child: Text(
                              dataList[index]['totalConfirmed'].toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .apply(color: Colors.white),
                            ),
                          ),
                        )
                      : Container(),
                  dataList[index]['totalRecovered'] != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 3.0,
                              ),
                              color: Colors.green,
                              child: Text(
                                dataList[index]['totalRecovered'].toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .apply(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  dataList[index]['totalDeaths'] != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 3.0,
                              ),
                              color: Colors.red,
                              child: Text(
                                dataList[index]['totalDeaths'].toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .apply(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            );
          },
          itemCount: dataList.length,
        ),
      ),
    );
  }
}
