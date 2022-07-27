import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'BloodPressurePage.dart';

class LineChartPage extends StatefulWidget {
  final String title;
  final List<dynamic> data;
  final String fullName;
  final double? minimum;
  final double? maximum;

  final dynamic series;

  // ignore: prefer_const_constructors_in_immutables
  LineChartPage(this.data, this.fullName, this.title, {required this.series, this.maximum, this.minimum, Key? key}) : super(key: key){
    data.sort((value1, value2) {
      return value1.date.millisecondsSinceEpoch - value2.date.millisecondsSinceEpoch;
    });
  }

  @override
  _LineChartPageState createState() => _LineChartPageState();
}

class _LineChartPageState extends State<LineChartPage> {
  late DateTime minDisplayTime;
  late DateTime maxDisplayTime;
  final redTriangle = MarkerSettings(shape: DataMarkerType.triangle, borderColor: Colors.red, color: Colors.red, isVisible: true, width: 10);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.data.isNotEmpty){
      minDisplayTime = widget.data.first.date;
      maxDisplayTime = widget.data.last.date;
    }
    else{
      minDisplayTime = DateTime.now();
      maxDisplayTime = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd MMM yy', "th");
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.fullName),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  TextButton(child: Text(dateFormatter.format(minDisplayTime)), onPressed: () async {
                    final chosenDate = await showDatePicker(
                      context: context,
                      locale: const Locale("th", "TH"),
                      initialDate: minDisplayTime,
                      initialDatePickerMode: DatePickerMode.day,
                      firstDate: widget.data.first.date,
                      lastDate: widget.data.last.date,
                    );
                    if (chosenDate != null){
                      setState(() {
                        minDisplayTime = chosenDate;
                      });
                    }
                  },),
                  Text('-'),
                  TextButton(child: Text(dateFormatter.format(maxDisplayTime)), onPressed: () async {
                    final chosenDate = await showDatePicker(
                      context: context,
                      locale: const Locale("th", "TH"),
                      initialDate: maxDisplayTime,
                      initialDatePickerMode: DatePickerMode.day,
                      firstDate: widget.data.first.date,
                      lastDate: widget.data.last.date,
                    );
                    if (chosenDate != null){
                      setState(() {
                        maxDisplayTime = chosenDate.add(Duration(hours: 23, minutes: 59, seconds: 59));
                      });
                    }
                  },),
                ],
                mainAxisSize: MainAxisSize.min,
              ),
            ),
            //Initialize the chart widget
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SfCartesianChart(
                  primaryXAxis: DateTimeAxis(
                    minimum: minDisplayTime,
                    maximum: maxDisplayTime,
                  ),
                  primaryYAxis: NumericAxis(
                    maximum: (widget.maximum ?? 0.0) + 10.0,
                    minimum: (widget.minimum ?? 0.0) - 10.0,
                  ),
                  // Chart title
                  title: ChartTitle(text: widget.title),
                  // Enable legend
                  legend: Legend(isVisible: true, position: LegendPosition.bottom),
                  // Enable tooltip
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: widget.series,
                  zoomPanBehavior: ZoomPanBehavior(enablePinching: true, enablePanning: true, enableDoubleTapZooming: true),
              ),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.end,),
        ));
  }

  calculateOffsetTime(DateTime minDate, DateTime maxDate) {
    final difference = 0.05*(maxDate.millisecondsSinceEpoch - minDate.millisecondsSinceEpoch);
    // return Duration(milliseconds: difference.toInt());
    return Duration(days: 0);
  }

}
