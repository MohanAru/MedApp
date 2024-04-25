import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginHistory extends StatefulWidget {
  const LoginHistory({super.key});

  @override
  State<LoginHistory> createState() => _LoginHistoryState();
}

class _LoginHistoryState extends State<LoginHistory> {
  TextEditingController textFieldController = TextEditingController();
  bool isload = false;
  SharedPreferences? sref;
  List loginhistory = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  fetchData() async {
    sref = await SharedPreferences.getInstance();
    String data = sref!.getString('login History') ?? '[]';

    loginhistory = jsonDecode(data);
    isload = true;
    setState(() {});
  }

  List filteredMedicineData = [];

  void filterData() {
    // Filter the data based on the text entered in the textFieldController.
    final searchTerm = textFieldController.text.toLowerCase();
    setState(() {
      filteredMedicineData = loginhistory.where((data) {
        return data['User Id '].toLowerCase().contains(searchTerm) ||
            data['Type'].toLowerCase().contains(searchTerm) ||
            data['Date'].toLowerCase().contains(searchTerm);
      }).toList();
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Text(
          'LOGIN HISTORY',
          style: TextStyle(
              letterSpacing: 2,
              color: Colors.blueAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        TextField(
          controller: textFieldController,
          onChanged: (value) {
            filterData();
          },
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.search),
            hintText: 'Search.....',
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              textFieldController.text.isEmpty
                  ? DataTable(
                      dataRowHeight: 30,
                      columnSpacing: MediaQuery.of(context).size.width * 0.05,
                      columns: [
                        DataColumn(
                          label: Text(
                            'USER',
                            style: TextStyle(color: Colors.blue, fontSize: 15),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Type',
                            style: TextStyle(color: Colors.blue, fontSize: 15),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Date',
                            style: TextStyle(color: Colors.blue, fontSize: 15),
                          ),
                        ),
                      ],
                      rows: List.generate(loginhistory.length, (index) {
                        return DataRow(cells: [
                          DataCell(
                            Text(
                              loginhistory[index]['User Id '],
                            ),
                          ),
                          DataCell(
                            Text(
                              loginhistory[index]['Type'],
                            ),
                          ),
                          DataCell(
                            Text(
                              loginhistory[index]['Date'],
                            ),
                          ),
                        ]);
                      }),
                    )
                  : Center(
                      child: DataTable(
                        dataRowHeight: 30,
                        columnSpacing: MediaQuery.of(context).size.width * 0.05,
                        columns: [
                          DataColumn(
                            label: Text(
                              'USER',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 15),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Quantity',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 15),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Total Price',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 15),
                            ),
                          ),
                        ],
                        rows:
                            List.generate(filteredMedicineData.length, (index) {
                          return DataRow(cells: [
                            DataCell(
                              Text(
                                filteredMedicineData[index]['User Id '],
                              ),
                            ),
                            DataCell(
                              Text(
                                filteredMedicineData[index]['Type'],
                              ),
                            ),
                            DataCell(
                              Text(
                                filteredMedicineData[index]['Date'],
                              ),
                            ),
                          ]);
                        }),
                      ),
                    )
            ],
          ),
        )
      ]),
    );
  }
}
