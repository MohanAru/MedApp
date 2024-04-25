import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  TextEditingController textFieldController1 = TextEditingController();
  TextEditingController textFieldController2 = TextEditingController();
  TextEditingController textFieldController3 = TextEditingController();

  List? loginData;
  SharedPreferences? sref;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    sref = await SharedPreferences.getInstance();
    String data5 = sref!.getString('loginData') ?? '[]';
    loginData = jsonDecode(data5);
    setState(() {});
  }

  List<String>? option;
  optionlist() {
    option = [];
    if (loginData != null) {
      for (var item in loginData!) {
        if (item['role'] != null) {
          option!.add(item['role']);
        }
      }
    }
    setState(() {});
  }

  void savenewuser(String txt, String txt1, String txt2) {
    bool userExists = false;

    for (var item in loginData!) {
      if (item['User Id'] == txt) {
        userExists = true;
        break;
      }
    }

    if (!userExists) {
      Map newUser = {'User Id': txt, 'password': txt1, 'role': txt2};
      loginData!.add(newUser);
      sref!.setString('loginData', jsonEncode(loginData));
      print(loginData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User added successfully'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User ID already exists. Try another one.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Text(
            'ADD USER',
            style: TextStyle(
                letterSpacing: 2,
                color: Colors.blueAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          ExpansionTile(
            title: Text('ADD USER'),
            tilePadding: EdgeInsets.all(8),
            collapsedBackgroundColor: Colors.blue,
            children: [
              Card(
                elevation: 4.0,
                margin: EdgeInsets.all(16.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.30,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: TextField(
                          controller: textFieldController1,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              labelText: 'Select an item'),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.30,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: TextField(
                          controller: textFieldController2,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              labelText: 'Select an item'),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.30,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: InkWell(
                          onTap: optionlist(),
                          child: TypeAheadField<String>(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: textFieldController3,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  labelText: 'Select an item'),
                            ),
                            suggestionsCallback: (pattern) {
                              return option!.where((item) => item
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase()));
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              textFieldController3.text = suggestion;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.18,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: ElevatedButton(
                          onPressed: () {
                            if (textFieldController1.text.isNotEmpty &&
                                textFieldController2.text.isNotEmpty &&
                                textFieldController3.text.isNotEmpty) {
                              savenewuser(
                                  textFieldController1.text,
                                  textFieldController2.text,
                                  textFieldController3.text);

                              print(loginData);
                            }
                            if (textFieldController1.text.isEmpty ||
                                textFieldController2.text.isEmpty ||
                                textFieldController3.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(' Enter All The Fields...'),
                                  duration: Duration(seconds: 5),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                            textFieldController1.clear();
                            textFieldController2.clear();
                            textFieldController3.clear();
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
        ],
      ),
    );
  }
}
