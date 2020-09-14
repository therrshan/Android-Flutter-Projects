import 'package:corona_tracker/models/country.dart';
import 'package:corona_tracker/pages/choosecountry.dart';
import 'package:corona_tracker/pages/countryspecific.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class CenterWidget extends StatelessWidget {
  final data;
  final Function setCountry;
  final List<dynamic> countriesList;
  CenterWidget({
    @required this.data,
    @required this.setCountry,
    @required this.countriesList,
  });
  @override
  Widget build(BuildContext context) {
    String time = timeago.format(DateTime.parse(data['lastUpdated']).toLocal());
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Corona cases in ${data['displayName']}',
            style: Theme.of(context).textTheme.title,
          ),
          Text(
            'Last updated: $time',
            style: Theme.of(context).textTheme.caption,
          ),
          SizedBox(height: 10.0),
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
                        data['totalConfirmed'].toString(),
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
                        (data['totalConfirmed'] -
                                data['totalRecovered'] -
                                data['totalDeaths'])
                            .toString(),
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
          SizedBox(height: 10.0),
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
                        data['totalRecovered'].toString(),
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
                        data['totalDeaths'].toString(),
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
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              OutlineButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => CountrySpecific(
                        data['areas'], data['displayName'], 'Home'),
                  ),
                ),
                child: Text('DETAILS'),
              ),
              OutlineButton(
                onPressed: () async {
                  Country country = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChooseCountry(
                        areaList: countriesList,
                      ),
                    ),
                  );
                  if (country != null) {
                    this.setCountry(country);
                  }
                },
                child: Text(
                  '${data['displayName']}'.toUpperCase(),
                ),
              ),
            ],
          ),
          SizedBox(height: 5.0),
          Divider(
            thickness: 0.5,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
