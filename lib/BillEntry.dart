import 'dart:convert';
import 'dart:math';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:medapp/details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillEntry extends StatefulWidget {
  final String userId;
  const BillEntry({super.key, required this.userId});

  @override
  State<BillEntry> createState() => _BillEntryState();
}

class _BillEntryState extends State<BillEntry> {
  String? sales;
  bool isload = false;
  TextEditingController textFieldController1 = TextEditingController();
  TextEditingController textFieldController2 = TextEditingController();
  TextEditingController textFieldController3 = TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  SharedPreferences? sref;
  List? medicineMaster;
  List? salesReport;
  List? stock;
  List? billmaster;
  List? loginHistory;
  List? billDetails;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    sref = await SharedPreferences.getInstance();
    String data = sref!.getString('medicineMaster') ?? '[]';
    String data1 = sref!.getString('stock') ?? '[]';
    String data2 = sref!.getString('Sales') ?? '0';
    String data3 = sref!.getString('salesReport') ?? '[]';
    String data4 = sref!.getString('billMaster') ?? '[]';
    String data5 = sref!.getString('login History') ?? '[]';
    String data6 = sref!.getString('billDetails') ?? '[]';

    billDetails = jsonDecode(data6);

    loginHistory = jsonDecode(data5);

    if (billmaster == null || billmaster!.isEmpty) {
      billmaster = jsonDecode(data4);
      if (billmaster == null || billmaster!.isEmpty) {
        billmaster = billMaster;
        sref!.setString('billMaster', jsonEncode(billmaster));
      }
    }

    if (salesReport == null || salesReport!.isNotEmpty) {
      salesReport = jsonDecode(data3);
      if (salesReport == null || salesReport!.isNotEmpty) {
        salesReport = salesreport;
        sref!.setString('salesReport', jsonEncode(salesReport));
      }
    }

    medicineMaster = jsonDecode(data);
    stock = jsonDecode(data1);

    sales = jsonDecode(data2).toString();

    setState(() {});
  }

  setBillDetails(
      String billno, String medName, double qnt, double unt, double amt) {
    Map map = {
      'BillNo': billno,
      'Medicine Name': medName,
      'Quantity': qnt,
      'UnitPrice': unt,
      'Amount': amt,
    };

    billDetails!.add(map);
    sref!.setString('billDetails', jsonEncode(billDetails));
    // print('Billdetails : $billDetails');
  }

  setbillMaster(String billno, String billdate, double amount, double gst,
      double netprice, String user) {
    Map map = {
      'BillNo': billno,
      'BillDate': billdate,
      'Amount': amount.toString(),
      'Gst': gst,
      'NetPrice': netprice,
      'UserId': user,
    };
    billmaster!.add(map);

    print(billmaster);
    // sref!.setString('billMaster', jsonEncode(billmaster));
    //  print('Billmaster : $billmaster');
  }

  setsalesReport(
      String billNo, String date, String medName, String qnty, int total) {
    Map map = {
      'BillNo': billNo,
      'Date': date,
      'MedName': medName,
      'Quantity': qnty,
      'Total': total.toString(),
    };
    salesReport!.add(map);
    // print('SaleReport : $salesReport');
  }

  String date = '${DateFormat('yyyy-MM-dd').format(DateTime.now())}';
  List<String>? options;
  optionslist() {
    options = [];
    if (medicineMaster != null) {
      for (var item in medicineMaster!) {
        options!.add(item['Medicine Name']);
      }
    }
  }

  void billgenerate() {
    //!  Alert Box for Confirm the sales

    String newBillNo = 'FC#${10000 + Random().nextInt(95680)}';
    String medicineName = textFieldController1.text;
    String quantity = textFieldController2.text;
    double unitPrice = double.parse(stock![stock!.indexWhere((element) {
      return element['Medicine Name'] == medicineName;
    })]['Unit Price']);

    double totalPrice = unitPrice * double.parse(quantity);
    double gst = totalPrice * 0.18;
    double netprice = totalPrice + gst;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Placed',
                  style: TextStyle(color: Color.fromARGB(255, 10, 173, 198)),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'Bill No :',
                            style: TextStyle(color: Colors.red)),
                        TextSpan(text: newBillNo),
                      ])),
                    ),
                    Flexible(
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'Date :',
                            style: TextStyle(color: Colors.red)),
                        TextSpan(text: date),
                      ])),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: 'Medicine:', style: TextStyle(color: Colors.red)),
                  TextSpan(text: medicineName),
                ])),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: 'Quantity  : ',
                      style: TextStyle(color: Colors.blueAccent)),
                  TextSpan(text: quantity),
                ])),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: 'Unit Price  : ',
                      style: TextStyle(color: Colors.blueAccent)),
                  TextSpan(text: unitPrice.toString()),
                ])),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Total Price',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 20),
                ),
                Text(
                  '\$ $totalPrice',
                  style: TextStyle(color: Colors.green, fontSize: 25),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        //!BillDetails
                        setBillDetails(newBillNo, textFieldController1.text,
                            double.parse(quantity), unitPrice, totalPrice);
                        //!BillMaster1
                        setbillMaster(newBillNo, date, totalPrice, gst,
                            netprice, widget.userId);
                        sref!.setString('billMaster', jsonEncode(billmaster));
                        //!SalesReport
                        setsalesReport(
                            newBillNo,
                            date,
                            textFieldController1.text,
                            textFieldController2.text,
                            int.parse(stock![stock!.indexWhere((element) {
                                  return element['Medicine Name'] ==
                                      textFieldController1.text;
                                })]['Unit Price']) *
                                int.parse(textFieldController2.text));
                        //!salesReport
                        sref!.setString('salesReport', jsonEncode(salesReport));
                        billing(textFieldController1.text,
                            textFieldController2.text);
                        Navigator.of(context).pop();
                        textFieldController1.clear();
                        textFieldController2.clear();
                        filterData1();
                        //!stock update
                        sref!.setString('stock', jsonEncode(stock));
                        //!Sales update
                        String data4 = sref!.getString('sales') ?? '0';
                        int pre = jsonDecode(data4);

                        if (totalList.isNotEmpty) {
                          int sum = totalList
                              .reduce((value, element) => value + element);
                          int sum1 = pre + sum;
                          sref!.setString('sales', jsonEncode(sum1));
                        }
                        if (totalList.isEmpty) {
                          sref!.setString('sales', jsonEncode(pre));
                        }
                      },
                      child: Text('Proceed Order',
                          style: TextStyle(color: Colors.white)),
                    )
                  ],
                )
              ],
            )
          ],
        );
      },
    );
    ;
  }

  List medicineData = [];
  List totalList = [];
  void billing(String text, String text1) {
    for (var item in stock!) {
      if (item['Medicine Name'] == text) {
        int tlt = int.parse(item['quantity']) - int.parse(text1);
        item['quantity'] = tlt.toString();
        break;
      }
    }

    if (medicineData.isEmpty || medicineData.isNotEmpty) {
      for (var masterItem in medicineMaster!) {
        for (var stockItem in stock!) {
          if (masterItem['Medicine Name'] == stockItem['Medicine Name']) {
            if (text == stockItem['Medicine Name']) {
              Map<String, dynamic> mergedItem = {
                'Medicine Name': text,
                'Brand': masterItem['Brand'],
                'Quantity': text1,
                'Total Price':
                    (int.parse(text1) * int.parse(stockItem['Unit Price']))
                        .toString(),
              };
              totalList
                  .add((int.parse(text1) * int.parse(stockItem['Unit Price'])));
              medicineData.add(mergedItem);
            }

            break;
          }
        }
      }
    }
  }

  double? net;
  double getNet() {
    net = totalList.fold(0.0, (total, element) => total! + (element * 1.18));
    print(net);
    return net!;
  }

  double? gst;
  double getGst() {
    gst = totalList.fold(0.0, (total, element) => total! + (element * 0.18));
    print(gst);
    return gst!;
  }

  List filteredMedicineData1 = [];
  void filterData1() {
    final searchTerm1 = textFieldController1.text.toLowerCase();
    setState(() {
      filteredMedicineData1 = medicineData.where((data) {
        return data['Medicine Name'].toLowerCase().contains(searchTerm1) ||
            data['Brand'].toLowerCase().contains(searchTerm1) ||
            data['Quantity'].contains(searchTerm1) ||
            data['Total Price'].contains(searchTerm1);
      }).toList();
      isload = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'BILL ENTRY',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: ListView(children: [
                ExpansionTile(
                  title: Text('BILL ENTRY'),
                  tilePadding: EdgeInsets.all(8),
                  collapsedBackgroundColor: Colors.blue,
                  children: [
                    Card(
                      elevation: 4.0,
                      margin: EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.30,
                              height: MediaQuery.of(context).size.height * 0.08,
                              child: InkWell(
                                onTap: optionslist(),
                                child: TypeAheadField<String>(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    controller: textFieldController1,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        labelText: 'Select an item'),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    return options!.where((item) => item
                                        .toLowerCase()
                                        .contains(pattern.toLowerCase()));
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      title: Text(suggestion),
                                    );
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    textFieldController1.text = suggestion;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.30,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                child: TextFormField(
                                  controller: textFieldController2,
                                  decoration: InputDecoration(
                                    label: Text(
                                      'Quantity',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    hintText: 'Enter Value',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                )),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.18,
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (textFieldController1.text.isEmpty ||
                                      textFieldController2.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            ' First Place the Order Correctly...'),
                                        duration: Duration(seconds: 1),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else if (int.parse(
                                          textFieldController2.text) <=
                                      0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Place the Order Correctly...'),
                                        duration: Duration(seconds: 1),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else if (int.parse(
                                          textFieldController2.text) >
                                      0) {
                                    if (int.parse(textFieldController2.text) <=
                                        int.parse(
                                            stock![stock!.indexWhere((element) {
                                          return element['Medicine Name'] ==
                                              textFieldController1.text;
                                        })]['quantity'])) {
                                      billgenerate();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Stock is Not There enough Check the Stock...'),
                                          duration: Duration(seconds: 1),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  'ADD',
                                  style: TextStyle(fontSize: 8),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                if (filteredMedicineData1.isNotEmpty) {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        actions: [
                                          Column(
                                            children: [
                                              Text(
                                                  'GST : ${getGst().toStringAsFixed(2)}'),
                                              Text(
                                                'Total :${totalList.reduce((value, element) => value + element)}',
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                              Text(
                                                  'NetPrice : ${getNet().toStringAsFixed(2)}'),
                                              Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      icon: Icon(
                                                          Icons.arrow_back)),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                  ),
                                                  Text(
                                                    'Preview',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 2,
                                                        fontSize: 20,
                                                        color: Colors.blue),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    'Printing The BIll...'),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            1),
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                              ),
                                                            );
                                                          },
                                                          child: Text('Print'))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                        content: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          child: ListView(
                                            scrollDirection: Axis.vertical,
                                            children: [
                                              DataTable(
                                                dataRowHeight: 30,
                                                columnSpacing:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.05,
                                                columns: [
                                                  DataColumn(
                                                    label: Text(
                                                      'Medicine Name',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .purpleAccent,
                                                          fontSize: 10),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      'Quantity',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .purpleAccent,
                                                          fontSize: 10),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      'Total Price',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .purpleAccent,
                                                          fontSize: 10),
                                                    ),
                                                  ),
                                                ],
                                                rows: List.generate(
                                                    filteredMedicineData1
                                                        .length, (index) {
                                                  return DataRow(cells: [
                                                    DataCell(
                                                      Text(
                                                        filteredMedicineData1[
                                                                index]
                                                            ['Medicine Name'],
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        filteredMedicineData1[
                                                            index]['Quantity'],
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        filteredMedicineData1[
                                                                index]
                                                            ['Total Price'],
                                                      ),
                                                    ),
                                                  ]);
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          ' First Place the Order Correctly...'),
                                      duration: Duration(seconds: 1),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  Colors.red,
                                ),
                              ),
                              child: Text('Preview')),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  medicineData.clear();
                                  filteredMedicineData1.clear();
                                  totalList.clear();
                                });
                                // Navigator.pop(context);
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  Colors.green,
                                ),
                              ),
                              child: Text('Save')),
                        ],
                      ),
                      TextField(
                        controller: textFieldController3,
                      ),
                      isload
                          ? Column(
                              children: [
                                DataTable(
                                    dataRowHeight: 30,
                                    columnSpacing:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    columns: [
                                      DataColumn(
                                          label: Flexible(
                                        child: Text(
                                          'Medicine Name',
                                          style: TextStyle(
                                              fontSize: 10, color: Colors.blue),
                                        ),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Brand',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.blue),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Quantity',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.blue),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Total Price',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.blue),
                                      )),
                                    ],
                                    rows: List.generate(
                                        filteredMedicineData1.length, (index) {
                                      return DataRow(cells: [
                                        DataCell(Text(
                                            filteredMedicineData1[index]
                                                ['Medicine Name'])),
                                        DataCell(Text(
                                            filteredMedicineData1[index]
                                                ['Brand'])),
                                        DataCell(Text(
                                            filteredMedicineData1[index]
                                                ['Quantity'])),
                                        DataCell(Text(
                                            (filteredMedicineData1[index]
                                                ['Total Price']))),
                                      ]);
                                    })),
                              ],
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            )
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
