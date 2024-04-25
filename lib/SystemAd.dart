import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medapp/AddUser.dart';
import 'package:medapp/DashBoard2.dart';
import 'package:medapp/LoginHistory.dart';
import 'package:medapp/LoginPage.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SystemAd extends StatefulWidget {
  const SystemAd({super.key});

  @override
  State<SystemAd> createState() => _SystemAdState();
}

class _SystemAdState extends State<SystemAd> {
  String selectedTabIndex = ''; //!String Declared$$$$$$$$$
  List loginhistory = [];
  SharedPreferences? sref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  fetchData() async {
    sref = await SharedPreferences.getInstance();
    String data3 = sref!.getString('login History') ?? '[]';
    List list = jsonDecode(data3);
    loginhistory = list;
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
            accountName: Text('System Admin'),
            accountEmail: Text('SystemAdmin@gmail.com'),
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
            title: Text('DASH BOARD'),
          ),
          ListTile(
            onTap: () {
              setState(() {
                selectedTabIndex = 'Login History';
                Navigator.pop(context);
              });
            },
            title: Text('LOGIN HISTORY'),
          ),
          ListTile(
            onTap: () {
              setState(() {
                selectedTabIndex = 'Add User';
                Navigator.pop(context);
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => BillerPage(),));
              });
              return null;
            },
            title: Text('ADD USER'),
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
                              'User Id ': 'sysad',
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
        title: Text('System Admin'),
      ),
      drawer: Mydrawer(context),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    //!Drawer Response $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    switch (selectedTabIndex) {
      case 'Login History': //!Stock view %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        return LoginHistory();
      case 'Add User': //!Bill Entry    $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        // print(selectedTabIndex);
        return AddUser();
      case 'Log Out': //! Log Out $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        return const Center(
          child: Text(''),
        );
      default:
        return DashBoard2();
    }
  }
}
