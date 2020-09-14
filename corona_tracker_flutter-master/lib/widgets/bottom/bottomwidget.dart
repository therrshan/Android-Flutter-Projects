import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BottomWidget extends StatelessWidget {
  final data;
  BottomWidget(this.data);

  _initiate(List<charts.Series<dynamic, String>> list) {
    List<dynamic> tempList = [];
    tempList.addAll(data);

    if (tempList.isNotEmpty) {
      tempList.sort(
        (a, b) => b['totalConfirmed'].compareTo(
          a['totalConfirmed'],
        ),
      );
      tempList.removeRange(5, tempList.length);
      list.add(
        charts.Series(
          domainFn: (dynamic element, __) => element['displayName'],
          measureFn: (dynamic element, __) => element['totalConfirmed'],
          id: 'top5graph',
          data: tempList,
          labelAccessorFn: (dynamic element, __) =>
              '${element['totalConfirmed']}',
          fillPatternFn: (_, __) => charts.FillPatternType.solid,
          fillColorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.red),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<dynamic, String>> _series = [];
    _initiate(_series);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Top 5 infected countries',
          style: Theme.of(context).textTheme.title,
        ),
        Container(
          height: 200.0,
          width: double.infinity,
          child: _series.isNotEmpty
              ? charts.BarChart(
                  _series,
                  vertical: false,
                  animate: false,
                  barRendererDecorator: charts.BarLabelDecorator<String>(
                    labelAnchor: charts.BarLabelAnchor.end,
                  ),
                )
              : Center(
                  child: Text('Not enough data!'),
                ),
        ),
      ],
    );
  }
}
