import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoard extends StatefulWidget {
  final String username;
  const DashBoard({super.key, required this.username});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  bool isLoad = false;
  SharedPreferences? sref;
  String? sale;
  List? billMaster;
  double yesterdaysale = 1000.0;
  double sales = 0;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    sref = await SharedPreferences.getInstance();
    // String data = sref!.getString('sales') ?? '0';
    String data1 = sref!.getString('billMaster') ?? '[]';
    if (billMaster == null || billMaster!.isEmpty) {
      billMaster = jsonDecode(data1);
      isLoad = true;
    }
    if (billMaster!.isNotEmpty) {
      for (var i in billMaster!) {
        if (i['UserId'] == widget.username &&
            i['BillDate']==DateTime.now().toString().substring(0,10)
            ) {
          sales = sales + double.parse(i['Amount']);
        }
      }
    }
    setState(() {});
  }

  double percentagecalculation() {
    if (sales == 0) {
      return 0;
    } else {
      return ((sales - yesterdaysale) / yesterdaysale) * 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (sales == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      String percentageText;
      Icon? arrowIcon;

      double percentageChange = percentagecalculation();
      if (percentageChange > 0) {
        percentageText = '${percentageChange.toStringAsFixed(2)}%';
        arrowIcon = Icon(
          size: 12,
          Icons.arrow_upward,
          color: Colors.green,
        );
      } else if (percentageChange < 0) {
        percentageText = '${percentageChange.toStringAsFixed(2)}%';
        arrowIcon = Icon(
          Icons.arrow_downward,
          color: Colors.red,
        );
      } else {
        percentageText = '';
        arrowIcon = null;
      }
      return Padding(
        padding: const EdgeInsets.all(25),
        child: Card(
          elevation: 4.0,
          shadowColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Text(
                  'Your Sales Today',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                isLoad
                    ? Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.25),
                        child: Row(
                          children: [
                            Text(
                              'Rs.$sales',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.blue),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            if (arrowIcon != null) ...[
                              Text(
                                percentageText,
                                style: TextStyle(
                                  color: percentageChange > 0
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 12.0,
                                ),
                              ),
                              arrowIcon,
                            ]
                          ],
                        ),
                      )
                    : CircularProgressIndicator(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
