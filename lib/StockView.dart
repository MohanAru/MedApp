import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockView extends StatefulWidget {
  const StockView({super.key});

  @override
  State<StockView> createState() => _StockViewState();
}

class _StockViewState extends State<StockView> {
  TextEditingController textFieldController = TextEditingController();
  bool isLoad = false;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  SharedPreferences? sref;
  List? medicineMaster;
  List? stock;
  List? medicineData;
  String? inventryValue;
  fetchData() async {
    sref = await SharedPreferences.getInstance();
    String data = sref!.getString('medicineMaster') ?? '[]';
    String data1 = sref!.getString('stock') ?? '[]';
    String data3 = sref!.getString('inventryValue') ?? '0';
    medicineMaster = jsonDecode(data);
    stock = jsonDecode(data1);
    medicineData = [];
    if (medicineData == null ||
        medicineData!.isEmpty ||
        medicineData!.isNotEmpty) {
      medicineData = getmedicinedata();
      isLoad = true;
    }
    if (data3.isNotEmpty || inventryValue!.isEmpty) {
      inventryValue = jsonDecode(data3).toString();
      if (inventryValue == null ||
          inventryValue == '0' ||
          inventryValue!.isNotEmpty) {
        inventryValue = getInventryValue();
        sref!.setString('inventryValue', inventryValue!);
      }
    }
    setState(() {});
  }

  String getInventryValue() {
    String lst = '';
    double total = 0;
    if (medicineData != null) {
      for (var item in medicineData!) {
        if (item != null &&
            item['Quantity'] != null &&
            item['Unit Price'] != null) {
          total +=
              int.parse(item['Quantity']) * double.parse(item['Unit Price']);
        }
      }
      lst = '$total';
    }
    return lst;
  }

  List getmedicinedata() {
    if (medicineData != null) {
      for (var masterItem in medicineMaster!) {
        for (var stockItem in stock!) {
          if (masterItem['Medicine Name'] == stockItem['Medicine Name']) {
            Map<String, dynamic> mergedItem = {
              'Medicine Name': masterItem['Medicine Name'],
              'Brand': masterItem['Brand'],
              'Quantity': stockItem['quantity'],
              'Unit Price': stockItem['Unit Price'],
            };
            medicineData!.add(mergedItem);
            break;
          }
        }
      }
    }
    setState(() {});
    return medicineData!;
  }

  List filteredMedicineData = [];

  void filterData() {
    // Filter the data based on the text entered in the textFieldController.
    final searchTerm = textFieldController.text.toLowerCase();
    setState(() {
      filteredMedicineData = medicineData!.where((data) {
        return data['Medicine Name'].toLowerCase().contains(searchTerm) ||
            data['Brand'].toLowerCase().contains(searchTerm) ||
            data['Quantity'].toString().contains(searchTerm) ||
            data['Unit Price'].toString().contains(searchTerm);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          'STOCK VIEW',
          style: TextStyle(
              letterSpacing: 2,
              color: Colors.blueAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: textFieldController,
          onChanged: (value) {
            filterData(); // Call the function to update the filtered data.
          },
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.search),
            hintText: 'Search.....',
          ),
        ),
        SizedBox(height: 10),
        //!dropdown *******************************
        Expanded(
          child: ListView(children: [
            textFieldController.text.isEmpty
                ? Center(
                    child: isLoad
                        ? DataTable(
                            columnSpacing:
                                MediaQuery.of(context).size.width * 0.05,
                            columns: [
                              const DataColumn(
                                  label: Text(
                                'Medicine Name',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              )),
                              const DataColumn(
                                  label: Text(
                                'Brand',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              )),
                              const DataColumn(
                                  label: Text(
                                'Quantity',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              )),
                              const DataColumn(
                                  label: Text(
                                'Unit Price',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              )),
                            ],
                            rows: List.generate(medicineData!.length, (index) {
                              return DataRow(cells: [
                                DataCell(Text(
                                    medicineData![index]['Medicine Name'])),
                                DataCell(Text(medicineData![index]['Brand'])),
                                DataCell(Text(medicineData![index]['Quantity']
                                    .toString())),
                                DataCell(Text(medicineData![index]['Unit Price']
                                    .toString())),
                              ]);
                            }))
                        : CircularProgressIndicator(),
                  )
                : DataTable(
                    columnSpacing: MediaQuery.of(context).size.width * 0.02,
                    columns: [
                      const DataColumn(
                          label: Text(
                        'Medicine Name',
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      )),
                      const DataColumn(
                          label: Text(
                        'Brand',
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      )),
                      const DataColumn(
                          label: Text(
                        'Quantity',
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      )),
                      const DataColumn(
                          label: Text(
                        'Unit Price',
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      )),
                    ],
                    rows: List.generate(filteredMedicineData.length, (index) {
                      return DataRow(cells: [
                        DataCell(
                            Text(filteredMedicineData[index]['Medicine Name'])),
                        DataCell(Text(filteredMedicineData[index]['Brand'])),
                        DataCell(Text(filteredMedicineData[index]['Quantity']
                            .toString())),
                        DataCell(Text(filteredMedicineData[index]['Unit Price']
                            .toString())),
                      ]);
                    })),
          ]),
        ),
      ],
    ));
  }
}
