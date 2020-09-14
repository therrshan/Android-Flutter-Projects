import 'package:corona_tracker/pages/worlddetails.dart';
import 'package:corona_tracker/pages/worldonmap.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String totalCases;
  final String recoveredCases;
  final String fatalCases;
  final List<dynamic> areaList;

  Header({
    @required this.totalCases,
    @required this.recoveredCases,
    @required this.fatalCases,
    @required this.areaList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Total Cases',
            style: Theme.of(context).textTheme.title,
          ),
          Text(
            totalCases,
            style:
                Theme.of(context).textTheme.display2.apply(color: Colors.black),
          ),
          SizedBox(height: 10.0),
          Text(
            'Recovered',
            style: Theme.of(context).textTheme.title,
          ),
          Text(
            recoveredCases,
            style:
                Theme.of(context).textTheme.display2.apply(color: Colors.green),
          ),
          SizedBox(height: 10.0),
          Text(
            'Fatal Cases',
            style: Theme.of(context).textTheme.title,
          ),
          Text(
            fatalCases,
            style:
                Theme.of(context).textTheme.display2.apply(color: Colors.red),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              OutlineButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorldData(areaList),
                  ),
                ),
                child: Text('DETAILS'),
              ),
              OutlineButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorldOnMap(areaList),
                  ),
                ),
                child: Text('EARTH'),
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
