import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:medapp/graph.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoard1 extends StatefulWidget {
  const DashBoard1({super.key});

  @override
  State<DashBoard1> createState() => _DashBoard1State();
}

class _DashBoard1State extends State<DashBoard1> {
  bool isLoad = false;
  SharedPreferences? sref;
  String? inventryValue;
  List? billMaster;
  double sales = 0;
  bool isGraph = false;
  double yesterdaysale = 1000.0;
  String lst = '';
  List? medicineMaster;
  List? stock;

  @override
  void initState() {
    super.initState();
    fetchData();
    // lst=getInventryValue();
  }

  fetchData() async {
    sref = await SharedPreferences.getInstance();
    // String data = sref!.getString('inventryValue') ?? '0';
    String data1 = sref!.getString('billMaster') ?? '[]';
    String data2 = sref!.getString('billMaster') ?? '[]';
    String data3 = sref!.getString('stock') ?? '[]';
    stock = jsonDecode(data3);
    if (billMaster == null || billMaster!.isEmpty) {
      billMaster = jsonDecode(data2);
      isLoad = true;
    }

    if (billMaster!.isNotEmpty) {
      for (var i in billMaster!) {
        if (i['BillDate'] == DateTime.now().toString().substring(0, 10)) {
          sales = sales + double.parse(i['Amount']);
        }
      }
    }

    billMaster = jsonDecode(data1);
    isGraph = true;
    // print(billMaster);

    if (data3.isNotEmpty || inventryValue!.isEmpty) {
      inventryValue = getInventryValue();
      sref!.setString('inventryValue', inventryValue!);
    }
    print(billMaster);
    setState(() {});
  }

  String getInventryValue() {
    String lst = '';
    double total = 0;
    if (stock != null) {
      for (var item in stock!) {
        if (item != null &&
            item['quantity'] != null &&
            item['Unit Price'] != null) {
          total +=
              int.parse(item['quantity']) * double.parse(item['Unit Price']);
        }
      }
      lst = '$total';
    }
    return lst;
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
      return const Center(
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
      return Center(
        child: ListView(children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(25),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 4.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white, // Set the background color
                  ),
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
                                  left:
                                      MediaQuery.of(context).size.width * 0.25),
                              child: Row(
                                children: [
                                  Text(
                                    'Rs.$sales',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.blue),
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
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 4.0,
                      ),
                    ],
                    color: Colors.white, // Set the background color
                  ),
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
                        'Current Inventory Value',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      isLoad
                          ? Text('Rs. ${inventryValue!}',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 25))
                          : CircularProgressIndicator(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 132, 166, 194),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Monthly Sales Chart',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      isGraph
                          ? buildMonthlySalesChart(billMaster!)
                          : Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFB99FC0),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Daily Sales Chart',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      isGraph
                          ? buildDailySalesChart(billMaster!)
                          : Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ),
              Text(
                'Pie Chart',
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              SizedBox(
                height: 500,
                child: isGraph
                    ? buildPieChart(billMaster!)
                    : Container(
                        height: 100, child: const CircularProgressIndicator()),
              ),
              Text(
                'Bar Chart For Billers',
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(215, 143, 92, 1),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      isGraph
                          ? buildBarChart(billMaster!)
                          : Container(
                              height: 100,
                              child: const CircularProgressIndicator()),
                    ],
                  ),
                ),
              ),
              // Container(
              //   color: Colors.amber,
              //   width: 500,
              //   height: 300,
              //   child: Container(
              //     // child: Text('Bdbi'),
              //     color: Colors.red,
              //     width: 50,
              //     height: 50,
              //   ),
              // ),
            ],
          ),
        ]),
      );
    }
  }
}
