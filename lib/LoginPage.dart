// ignore: file_names
// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:medapp/BillerPage.dart';

import 'package:medapp/details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController textController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String _input = '';
  String input = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  List? history;
  List? login;
  List? medicineMaster;
  List? salesReport;
  List? stock;
  List loginhistory = [];
  SharedPreferences? sref;
  fetchData() async {
    sref = await SharedPreferences.getInstance();
    String data = sref!.getString('login') ?? '[]';
    String data2 = sref!.getString('medicineMaster') ?? '[]';
    String data1 = sref!.getString('stock') ?? '[]';
    String data3 = sref!.getString('login History') ?? '[]';
    String data5 = sref!.getString('loginData') ?? '[]';
    String data6 = sref!.getString('salesReport') ?? '[]';
    if (history == null || history!.isEmpty) {
      history = jsonDecode(data5);
      print(history);
      if (history == null || history!.isEmpty) {
        history = logindata;
        sref!.setString('loginData', jsonEncode(history));
      }
    }
    if (medicineMaster == null || medicineMaster!.isEmpty) {
      medicineMaster = jsonDecode(data2);
      if (medicineMaster == null || medicineMaster!.isEmpty) {
        medicineMaster = medicineMasterList;
        sref!.setString('medicineMaster', jsonEncode(medicineMaster));
      }
    }

    if (stock == null || stock!.isEmpty) {
      stock = jsonDecode(data1);
      if (stock == null || stock!.isEmpty) {
        stock = stockList;
        sref!.setString('stock', jsonEncode(stock));
      }
    }
    if (login == null || login!.isEmpty) {
      login = jsonDecode(data);
      if (login == null || login!.isEmpty) {
        login = logindata;
        sref!.setString('login', jsonEncode(login));
      }
    }
    if (data6.isNotEmpty || salesReport == null) {
      salesReport = jsonDecode(data6);
    }

    if (loginhistory.isEmpty) {
      loginhistory = jsonDecode(data3);
    }
    setState(() {});
  }

  Map author = {
    'UserId': 'vijay',
    'Pass': '123',
  };

  void handleLoginSuccess(String loginTime) {
    BillerPage.setLoginTime(loginTime);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      for (var item in history!) {
        if (_input == item['User Id'] && input == item['password']) {
          final routeName = '/' + item['role'].toLowerCase();
          Navigator.of(context).pushNamed(routeName, arguments: _input);
          return;
        }
      }
      // for (var item in history!) {
      //   if (_input == item['User Id'] &&
      //       item['role'] == 'Manager' &&
      //       input == item['password']) {
      //     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      //       return ManagerPage(
      //         username: _input,
      //       );
      //     }));
      //   }
      //   if (_input == item['User Id'] &&
      //       item['role'] == 'Biller' &&
      //       input == item['password']) {
      //     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      //       return BillerPage(
      //         username: _input,
      //       );
      //     }));
      //   }
      //   if (_input == item['User Id'] &&
      //       item['role'] == 'Inventory' &&
      //       input == item['password']) {
      //     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      //       return Inventry(
      //         username: _input,
      //       );
      //     }));
      //   }
      //   if (_input == item['User Id'] &&
      //       item['role'] == 'System Admin' &&
      //       input == item['password']) {
      //     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      //       return const SystemAd();
      //     }));
      //   }
      // }
    }

    loginhistory.add({
      'User Id ': _input,
      'Type': 'Login',
      'Date': DateTime.now().toString(),
    });

    sref!.setString('login History', jsonEncode(loginhistory));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.25,
                horizontal: MediaQuery.of(context).size.width * 0.1),
            child: Card(
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 50.0,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  _input = value;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter User ID';
                                }
                                if (!history!.any(
                                    (element) => element['User Id'] == value)) {
                                  return 'Invalid User';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  labelText: 'User ID',
                                  labelStyle: TextStyle(color: Colors.black),
                                  hintText: 'Enter User ID'),
                              controller: textController,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.04,
                            ),
                            TextFormField(
                              obscureText: true,
                              onChanged: (value) {
                                setState(() {
                                  input = value;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Valid Password';
                                }
                                if (!history!.any((element) =>
                                    element['password'] == value)) {
                                  return 'Wrong Pasword';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.black),
                                  hintText: 'Enter Password'),
                              controller: passwordController,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.04,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  _submit();
                                },
                                child: Text('Login')),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
