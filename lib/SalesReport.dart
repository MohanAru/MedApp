import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesReport extends StatefulWidget {
  const SalesReport({super.key});

  @override
  State<SalesReport> createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {
  TextEditingController textFieldController = TextEditingController();
  TextEditingController textFieldController1 = TextEditingController();
  TextEditingController textFieldController3 = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isFromDate ? fromDate ?? DateTime.now() : toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fromDate = DateTime.now();
    toDate = DateTime.now();
    fetchData();
  }

  bool isload = false;
  SharedPreferences? sref;
  List? salesReport;

  fetchData() async {
    sref = await SharedPreferences.getInstance();
    String data = sref!.getString('salesReport') ?? '[]';
    salesReport = jsonDecode(data);
    isload = true;
  }

  List<Map<String, dynamic>> getFilteredSalesReport() {
    if (salesReport == null) {
      return [];
    }

    List<Map<String, dynamic>> filteredSalesReport = [];

    for (int index = 0; index < salesReport!.length; index++) {
      DateTime saleDate = DateTime.parse(salesReport![index]['Date']);
      if (saleDate.isAfter(fromDate!) && saleDate.isBefore(toDate!)) {
        filteredSalesReport.add(salesReport![index]);
      }
    }

    return filteredSalesReport;
  }

  List filteredMedicineData = [];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredSalesReport = getFilteredSalesReport();
    void filterData() {
      // Filter the data based on the text entered in the textFieldController.
      final searchTerm = textFieldController3.text.toLowerCase();
      setState(() {
        filteredMedicineData = filteredSalesReport.where((data) {
          return data['BillNo'].toLowerCase().contains(searchTerm) ||
              data['Date'].toLowerCase().contains(searchTerm) ||
              data['MedName'].toString().contains(searchTerm) ||
              data['Quantity'].toString().contains(searchTerm) ||
              data['Total'].toString().contains(searchTerm);
        }).toList();
      });
    }

    return Center(
      child: ListView(children: [
        Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'SALES REPORT',
              style: TextStyle(
                  letterSpacing: 2,
                  color: Colors.blueAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 4.0,
                  ),
                ],
                color: Colors.white, // Set the background color
              ),
              margin: EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: TextFormField(
                      readOnly: true,
                      onTap: () => _selectDate(context, true),
                      decoration: InputDecoration(
                        labelText: 'From Date',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      controller: TextEditingController(
                        text: fromDate != null
                            ? "${fromDate!.toLocal()}".split(' ')[0]
                            : "",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: TextFormField(
                      readOnly: true,
                      onTap: () => _selectDate(context, false),
                      decoration: InputDecoration(
                        labelText: 'To Date',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      controller: TextEditingController(
                        text: toDate != null
                            ? "${toDate!.toLocal()}".split(' ')[0]
                            : "",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.18,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text(
                        'Search',
                        style: TextStyle(fontSize: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextField(
                    controller: textFieldController3,
                    onChanged: (value) {
                      filterData(); // Call the function to update the filtered data.
                    },
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      hintText: 'Search.....',
                    ),
                  ),
                  textFieldController3.text.isEmpty
                      ? isload
                          ? DataTable(
                              dataRowHeight: 30,
                              columnSpacing:
                                  MediaQuery.of(context).size.width * 0.02,
                              columns: [
                                const DataColumn(
                                  label: Flexible(
                                    child: Text(
                                      'Bill NO',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                const DataColumn(
                                  label: Flexible(
                                    child: Text(
                                      'Bill Date',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                const DataColumn(
                                  label: Flexible(
                                    child: Text(
                                      'Medicine Name',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                const DataColumn(
                                  label: Text(
                                    'Quantity',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                const DataColumn(
                                  label: Text(
                                    'Amount',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                              rows: List.generate(filteredSalesReport.length,
                                  (index) {
                                return DataRow(cells: [
                                  DataCell(
                                    Text(filteredSalesReport[index]['BillNo']),
                                  ),
                                  DataCell(
                                      Text(filteredSalesReport[index]['Date'])),
                                  DataCell(
                                    Text(filteredSalesReport[index]['MedName']),
                                  ),
                                  DataCell(
                                    Text(
                                        filteredSalesReport[index]['Quantity']),
                                  ),
                                  DataCell(
                                    Text(
                                      filteredSalesReport[index]['Total']
                                          .toString(),
                                    ),
                                  ),
                                ]);
                              }),
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            )
                      : isload
                          ? DataTable(
                              dataRowHeight: 30,
                              columnSpacing:
                                  MediaQuery.of(context).size.width * 0.02,
                              columns: [
                                const DataColumn(
                                  label: Flexible(
                                    child: Text(
                                      'Bill NO',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                const DataColumn(
                                  label: Flexible(
                                    child: Text(
                                      'Bill Date',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                const DataColumn(
                                  label: Flexible(
                                    child: Text(
                                      'Medicine Name',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                const DataColumn(
                                  label: Text(
                                    'Quantity',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                const DataColumn(
                                  label: Text(
                                    'Amount',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                              rows: List.generate(filteredMedicineData.length,
                                  (index) {
                                return DataRow(cells: [
                                  DataCell(
                                    Text(filteredMedicineData[index]['BillNo']),
                                  ),
                                  DataCell(
                                    Text(filteredMedicineData[index]['Date']),
                                  ),
                                  DataCell(
                                    Text(
                                        filteredMedicineData[index]['MedName']),
                                  ),
                                  DataCell(
                                    Text(filteredMedicineData[index]
                                        ['Quantity']),
                                  ),
                                  DataCell(
                                    Text(
                                      filteredMedicineData[index]['Total']
                                          .toString(),
                                    ),
                                  ),
                                ]);
                              }),
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                ],
              ),
            )
          ],
        ),
      ]),
    );
  }
}
