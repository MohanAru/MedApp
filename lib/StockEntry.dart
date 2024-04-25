/// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockEntry extends StatefulWidget {
  final String username;
  const StockEntry({super.key, required this.username});

  @override
  State<StockEntry> createState() => _StockEntryState();
}

class _StockEntryState extends State<StockEntry> {
  bool isload = false;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  SharedPreferences? sref;
  List? medicineMaster;
  List? stock;
  fetchData() async {
    sref = await SharedPreferences.getInstance();
    String data = sref!.getString('medicineMaster') ?? '[]';
    String data1 = sref!.getString('stock') ?? '[]';
    medicineMaster = jsonDecode(data);
    stock = jsonDecode(data1);
    isload = true;
    setState(() {});
  }

  List<String>? options;
  optionslist() {
    options = [];
    for (var item in medicineMaster!) {
      options!.add(item['Medicine Name']);
    }
  }

  void addMedicine(String newMed, String newBrand) {
    String lowerNewMed = newMed.toLowerCase();

    bool medicineExists = medicineMaster!
        .any((item) => item['Medicine Name'].toLowerCase() == lowerNewMed);

    if (!medicineExists) {
      Map<String, String> newMedicine = {
        'Medicine Name': newMed,
        'Brand': newBrand,
      };
      medicineMaster!.add(newMedicine);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('This Medicine already Exist'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating, // Customize the behavior.
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ));
    }
  }

  void finalUpdate(String medName, String qty, String unt) {
    bool isStockUpdate = false;

    for (var item in stock!) {
      if (item['Medicine Name'] == medName) {
        int totalqty = int.parse(item['quantity']) + int.parse(qty);
        item['quantity'] = totalqty.toString();
        item['Unit Price'] = unt;
        isStockUpdate = true;
      }
    }

    if (!isStockUpdate) {
      setState(() {
        Map<String, dynamic> newItem = {
          'Medicine Name': medName,
          'quantity': qty,
          'Unit Price': unt,
        };
        stock!.add(newItem);
      });
    }

    sref!.setString('stock', jsonEncode(stock));
  }

  TextEditingController textFieldController3 = TextEditingController();
  TextEditingController textFieldController4 = TextEditingController();
  TextEditingController textFieldController5 = TextEditingController();
  TextEditingController textFieldController6 = TextEditingController();
  TextEditingController textFieldController7 = TextEditingController();
  TextEditingController textFieldController8 = TextEditingController();
  void updatedList() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'New Medicine Adding',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: textFieldController7,
                    decoration: InputDecoration(
                        label: Text('Medicine'),
                        hintText: 'Enter Medicinee',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: textFieldController8,
                    decoration: InputDecoration(
                        label: Text('Brand'),
                        hintText: 'Enter The Brand',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (textFieldController7.text.isNotEmpty &&
                          textFieldController8.text.isNotEmpty) {
                        addMedicine(textFieldController7.text,
                            textFieldController8.text);
                        sref!.setString(
                            'medicineMaster', jsonEncode(medicineMaster));
                        textFieldController7.clear();
                        textFieldController8.clear();
                        Navigator.of(context).pop();
                        setState(() {});
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Enter Both fields'),

                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior
                                .floating, // Customize the behavior.
                            action: SnackBarAction(
                              label: 'Ok',
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('+ADD'))
              ],
            )
          ],
        );
      },
    );
  }

  void replaceValues(String medi) {
    for (var element in medicineMaster!) {
      if (element['Medicine Name'] == medi) {
        setState(() {
          textFieldController4.text = element['Brand'];
        });

        break;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return isload
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.30,
                      ),
                      Text(
                        'STOCK ENTRY',
                        style: TextStyle(
                            letterSpacing: 2,
                            color: Colors.blueAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Refill Stock'),
                      ElevatedButton(
                          onPressed: () {
                            updatedList();

                            //! Shared_Preferences
                          },
                          child: Text('+ADD')),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 4.0,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: optionslist(),
                            child: TypeAheadField<String>(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: textFieldController3,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelText: 'Select an item',
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                List<String> filteredOptions = options!
                                    .where((element) => element
                                        .toString()
                                        .toLowerCase()
                                        .contains(pattern.toLowerCase()))
                                    .map((element) => element.toString())
                                    .toList();

                                return filteredOptions;
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  title: Text(suggestion),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                textFieldController3.text = suggestion;
                                if (suggestion.isNotEmpty) {
                                  replaceValues(suggestion);
                                } else {
                                  textFieldController4.clear();
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: textFieldController4,
                            readOnly: true,
                            decoration: InputDecoration(
                              label: Text(
                                'Brand',
                                style: TextStyle(fontSize: 12),
                              ),
                              hintText: 'Enter Value',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: textFieldController5,
                            decoration: InputDecoration(
                              label: Text(
                                'Quantity',
                                style: TextStyle(fontSize: 12),
                              ),
                              hintText: 'Enter Value',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: textFieldController6,
                            decoration: InputDecoration(
                              label: Text(
                                'Unit Price',
                                style: TextStyle(fontSize: 12),
                              ),
                              hintText: 'Enter Value',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (textFieldController3.text.isNotEmpty &&
                                    textFieldController5.text.isNotEmpty &&
                                    textFieldController6.text.isNotEmpty) {
                                  if (int.parse(textFieldController5.text) >
                                          0 &&
                                      double.parse(textFieldController6.text) >
                                          0) {
                                    finalUpdate(
                                        textFieldController3.text,
                                        textFieldController5.text,
                                        textFieldController6.text);
                                    setState(() {
                                      sref!.setString(
                                          'stock', jsonEncode(stock));
                                    });
                                    // print(stock);
                                    textFieldController3.clear();
                                    textFieldController4.clear();
                                    textFieldController5.clear();
                                    textFieldController6.clear();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Stock Updated Successfully'),
                                        // You can customize the duration, behavior, and more.
                                        duration: Duration(
                                            seconds:
                                                2), // Set the duration for how long the SnackBar is displayed.
                                        behavior: SnackBarBehavior
                                            .floating, // Customize the behavior.
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Enter Valid Values Greater Than 0'),

                                        duration: Duration(
                                            seconds:
                                                2), // Set the duration for how long the SnackBar is displayed.
                                        behavior: SnackBarBehavior
                                            .floating, // Customize the behavior.
                                        action: SnackBarAction(
                                          label: 'Ok',
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Enter All fields'),
                                      // You can customize the duration, behavior, and more.
                                      duration: Duration(
                                          seconds:
                                              2), // Set the duration for how long the SnackBar is displayed.
                                      behavior: SnackBarBehavior
                                          .floating, // Customize the behavior.
                                      action: SnackBarAction(
                                        label: 'Ok',
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('UPDATE'))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : Center(child: const CircularProgressIndicator());
  }
}
