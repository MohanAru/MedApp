import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medapp/DashBoard2.dart';
import 'package:medapp/LoginPage.dart';
import 'package:medapp/StockEntry.dart';
import 'package:medapp/StockView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Inventry extends StatefulWidget {
  final String username;
  const Inventry({super.key, required this.username});

  @override
  State<Inventry> createState() => _InventryState();
}

class _InventryState extends State<Inventry> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  String selectedTabIndex = ''; //!String Declared$$$$$$$$$
  List loginhistory = [];
  SharedPreferences? sref;

  fetchData() async {
    sref = await SharedPreferences.getInstance();
    String data3 = sref!.getString('login History') ?? '[]';
    // List list = jsonDecode(data3);
    loginhistory = jsonDecode(data3);
  }

  // String sales=await getData('sales');
  Widget Mydrawer(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      elevation: 2.0,
      shape: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.username),
            accountEmail: Text('Inventry@gmail.com'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            onTap: () {
              setState(() {
                selectedTabIndex = 'Dash Board';
                Navigator.pop(context);
              });
            },
            title: Text('Dash Board'),
          ),
          ListTile(
            onTap: () {
              setState(() {
                selectedTabIndex = 'Stock View';
                Navigator.pop(context);
              });
            },
            title: Text('Stock View'),
          ),
          ListTile(
            onTap: () {
              setState(() {
                selectedTabIndex = 'Stock Entry';
                Navigator.pop(context);
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => BillerPage(),));
              });
              return null;
            },
            title: Text('Stock Entry'),
          ),
          ListTile(
            //!Log Out Button
            titleTextStyle: TextStyle(color: Colors.red),
            onTap: () {
              setState(() {
                selectedTabIndex = 'Log Out';
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.blueGrey.withOpacity(0.8),
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: Text('Alert '),
                      content: Text('Do You Want to LogOut ?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            loginhistory.add({
                              'User Id ': 'Inventry',
                              'Type': 'Logout',
                              'Date': DateTime.now().toString(),
                            });

                            sref!.setString(
                                'login History', jsonEncode(loginhistory));
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            )); // Close the dialog
                          },
                          child:
                              Text('OK', style: TextStyle(color: Colors.green)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    );
                  },
                );
              });
            },
            title: Text('Log Out'),
            leading: Icon(
              Icons.logout_outlined,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventry Log'),
      ),
      drawer: Mydrawer(context),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    //!Drawer Response $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    switch (selectedTabIndex) {
      case 'Stock View': //!Stock view %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        return StockView();
      case 'Stock Entry': //!Bill Entry    $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        // print(selectedTabIndex);
        return StockEntry(
          username: widget.username,
        );
      case 'Log Out': //! Log Out $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        return const Center(
          child: Text(''),
        );
      default:
        return DashBoard2();
    }
  }
}
