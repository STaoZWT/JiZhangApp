import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../../chart_material.dart';


class SubscriberChart extends StatelessWidget {
  final List<BarData> data;

  SubscriberChart({@required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<BarData, String>> series = [  ///返回值
      charts.Series(
          id: "Subscribers",
          data: data,
          domainFn: (BarData series, _) => series.category,
          measureFn: (BarData series, _) => series.sales,
          colorFn: (BarData series, _) => series.color),
    ];

    return Container(
      height: double.infinity,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              /*Text(
                "World of Warcraft Subscribers by Year",
                style: Theme.of(context).textTheme.body2,
              ),*/
              Expanded(
                child: charts.BarChart(series, animate: true), ///BarChart返回值为String
              )
            ],
          ),
        ),
      ),
    );
  }
}