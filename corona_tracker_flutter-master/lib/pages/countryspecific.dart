import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountrySpecific extends StatelessWidget {
  final List<dynamic> dData;
  final String title;
  final String backPageTitle;
  CountrySpecific(this.dData, this.title, this.backPageTitle);

  List<Widget> _buildExpansionChild(
      List<dynamic> innerList, BuildContext context) {
    List<Widget> list = [];
    innerList.forEach((f) {
      list.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListTile(
            title: Text(f['displayName']),
            subtitle: Row(
              children: <Widget>[
                f['totalConfirmed'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6.0,
                            vertical: 3.0,
                          ),
                          color: Colors.grey,
                          child: Text(
                            f['totalConfirmed'].toString(),
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .apply(color: Colors.white),
                          ),
                        ),
                      )
                    : Container(),
                f['totalRecovered'] != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                              vertical: 3.0,
                            ),
                            color: Colors.lightGreen,
                            child: Text(
                              f['totalRecovered'].toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .apply(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                f['totalDeaths'] != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                              vertical: 3.0,
                            ),
                            color: Colors.deepOrangeAccent,
                            child: Text(
                              f['totalDeaths'].toString(),
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
          ),
        ),
      );
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> data = [];
    data.addAll(dData);
    data.sort(
      (a, b) => a['displayName'].compareTo(
        b['displayName'],
      ),
    );
    //print(dData);
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: Text(title),
              transitionBetweenRoutes: true,
              previousPageTitle: backPageTitle,
            )
          : AppBar(
              title: Text(title),
            ),
      body: SafeArea(
        child: Container(
          child: data.isNotEmpty
              ? ListView.builder(
                  itemBuilder: (ctx, index) {
                    return ExpansionTile(
                      title: Text(
                        data[index]['displayName'],
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          data[index]['totalConfirmed'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(6.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0,
                                      vertical: 3.0,
                                    ),
                                    color: Colors.black,
                                    child: Text(
                                      data[index]['totalConfirmed'].toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .apply(color: Colors.white),
                                    ),
                                  ),
                                )
                              : Container(),
                          data[index]['totalRecovered'] != null
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
                                        data[index]['totalRecovered']
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .apply(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          data[index]['totalDeaths'] != null
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
                                        data[index]['totalDeaths'].toString(),
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
                      children:
                          _buildExpansionChild(data[index]['areas'], context),
                    );
                  },
                  itemCount: data.length,
                )
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.warning,
                        color: Colors.red,
                      ),
                      SizedBox(height: 5.0),
                      Text('Not enough data!'),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
