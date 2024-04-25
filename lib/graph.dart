import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Widget buildBarChart(List billMaster) {
  List<String> list = [];
  List<double> list1 = [];
  double tlt = 0;

  for (var i in billMaster) {
    list.add(i['UserId']);
  }

  list = list.toSet().toList();

  for (var j = 0; j < list.length; j++) {
    for (var i in billMaster) {
      if (i['BillDate'].substring(5, 7) ==
          DateTime.now().toString().substring(5, 7)) {
        if (i['UserId'] == list[j]) {
          tlt = tlt + double.parse(i['Amount']);
        }
      }
    }
    list1.add(tlt);
    tlt = 0;
  }

  List<ChartData> chartData = List.generate(
    list.length,
    (index) => ChartData(list[index], list1[index]),
  );

  return SfCartesianChart(
    primaryXAxis: CategoryAxis(),
    series: <ChartSeries>[
      BarSeries<ChartData, String>(
        dataSource: chartData,
        xValueMapper: (ChartData data, _) => data.userType,
        yValueMapper: (ChartData data, _) => data.total,
        dataLabelSettings: DataLabelSettings(isVisible: true),
      ),
    ],
  );
}

class ChartData {
  final String userType;
  final double total;

  ChartData(this.userType, this.total);
}
Widget buildPieChart(List billmaster) {
  List list = [];
  List list1 = [];
  double tlt = 0;

  for (var i in billmaster) {
    list.add(i['UserId']);
  }

  list = list.toSet().toList();
  for (var j = 0; j < list.length; j++) {
    for (var i in billmaster) {
      if (i['BillDate'] == DateTime.now().toString().substring(0, 10)) {
        if (i['UserId'] == list[j]) {
          tlt = tlt + double.parse(i['Amount']);
        }
      }
    }
    list1.add(tlt);
    tlt = 0;
  }

  // Create a list of PieChartSectionData based on list and list1
  List<PieChartSectionData> pieSections = List.generate(
    list.length,
    (int index) {
      return PieChartSectionData(radius: 70,
        color: getRandomColor(),
        showTitle: true,
        title: list[index].toString(),
        titleStyle: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        value: list1[index], // Use list1 values here
      );
    },
  );

  return Column(
    children: <Widget>[
      AspectRatio(
        aspectRatio: 1.5,
        child: PieChart(
          swapAnimationCurve: Curves.easeInOut,
          PieChartData(
            sections: pieSections,
            borderData: FlBorderData(show: false),
            sectionsSpace: 2,
            centerSpaceRadius: 40,
          ),
        ),
      ),
      // Legend
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: pieSections.map((section) {
          return Row(
            children: [
              Container(
                width: 20,
                height: 20,
                color: section.color,
              ),
              SizedBox(width: 8),
              Text('${section.title} - ${section.value.toStringAsFixed(2)}'),
            ],
          );
        }).toList(),
      ),
    ],
  );
}

Color getRandomColor() {
  final random = Random();
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    0.4,
  );
}

Widget buildDailySalesChart(List billMaster) {
  List<Map<String, dynamic>> dailySalesData = [];

  DateTime currentDate = DateTime.now();
  for (int i = 0; i < 7; i++) {
    final day = currentDate.subtract(Duration(days: i));
    final day1 = currentDate.subtract(Duration(days: i)).toString();
    final dayName = DateFormat('EEE').format(day);
    final salesAmount = calculateSalesForDay(day1.substring(8, 10), billMaster);
    dailySalesData.add({'day': dayName, 'sales': salesAmount});
  }

  dailySalesData = dailySalesData.reversed.toList();

  return SfCartesianChart(
    title: ChartTitle(
      text: 'Daily Sales',
      textStyle: TextStyle(fontSize: 15, color: Colors.blue),
    ),
    primaryXAxis: CategoryAxis(),
    series: <ChartSeries<Map<String, dynamic>, String>>[
      LineSeries<Map<String, dynamic>, String>(
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(color: Colors.black, fontSize: 12),
        ),
        dataSource: dailySalesData,
        markerSettings: MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
          width: 4,
          height: 4,
          borderWidth: 2,
          borderColor: Colors.blue,
          color: Colors.blue,
        ),
        dataLabelMapper: (data, index) => data['sales'].toString(),
        xValueMapper: (data, _) => data['day'],
        yValueMapper: (data, _) => data['sales'],
        name: 'Daily Sales',
      ),
    ],
  );
}

double calculateSalesForDay(String dayName, List billMaster) {
  double salesAmount = 0.0;

  for (var bill in billMaster) {
    String billDate = bill['BillDate'];
    String billAmount = bill['Amount'];
    final day = DateFormat('dd').format(DateTime.parse(billDate));

    if (day == dayName) {
      salesAmount += double.parse(billAmount);
    }
  }

  return salesAmount;
}

Widget buildMonthlySalesChart(List billMaster) {
  List<Map<String, dynamic>> monthlySalesData = [];
  String getMonthName(int monthIndex) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[monthIndex - 1];
  }

  monthlySalesData = List.generate(12, (index) {
    return {'month': getMonthName(index + 1), 'sales': 0.0};
  });
  for (var bill in billMaster) {
    String? billDate = bill['BillDate'];
    String? billAmount = bill['Amount'].toString();
    final yearMonth = billDate!.split('-');
    if (yearMonth.length == 3) {
      final month = int.tryParse(yearMonth[1]);
      if (month != null && month >= 1 && month <= 12) {
        final monthIndex = month - 1;
        monthlySalesData[monthIndex]['sales'] += double.parse(billAmount);
      }
    }
  }
  return billMaster.isEmpty
      ? const CircularProgressIndicator()
      : SfCartesianChart(
          title: ChartTitle(
              text: 'Monthly Sales',
              textStyle: TextStyle(fontSize: 15, color: Colors.blue)),
          primaryXAxis: CategoryAxis(
            labelStyle: const TextStyle(fontSize: 8.0),
            maximumLabels: 12,
            labelRotation: -45,
          ),
          series: <ChartSeries<Map<String, dynamic>, String>>[
            LineSeries<Map<String, dynamic>, String>(
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(color: Colors.black, fontSize: 12),
              ),
              dataSource: monthlySalesData,
              xValueMapper: (data, _) => data['month'],
              yValueMapper: (data, _) => data['sales'],
              name: 'Monthly Sales',
            ),
          ],
        );
}
