import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

List logindata = [
  {'User Id': 'vijay', 'password': '123', 'role': 'biller'},
  {'User Id': 'manager', 'password': '123', 'role': 'manager'},
  {'User Id': 'inventry', 'password': '123', 'role': 'inventory'},
  {'User Id': 'sysad', 'password': '123', 'role': 'systemAdmin'},
];

List<Map<String, dynamic>> medicineMasterList = [
  {'Medicine Name': 'Med1', 'Brand': 'brand1'},
  {'Medicine Name': 'Med2', 'Brand': 'brand2'},
  {'Medicine Name': 'Med3', 'Brand': 'brand3'},
  {'Medicine Name': 'Med4', 'Brand': 'brand4'},
  {'Medicine Name': 'Med5', 'Brand': 'brand5'},
  {'Medicine Name': 'Med6', 'Brand': 'brand6'},
  {'Medicine Name': 'Med7', 'Brand': 'brand7'},
  {'Medicine Name': 'Med8', 'Brand': 'brand8'}, 
  {'Medicine Name': 'Med9', 'Brand': 'brand9'},
  {'Medicine Name': 'Med10', 'Brand': 'brand10'},
];
List stockList = [
  {'Medicine Name': 'Med1', 'quantity': '20', 'Unit Price': '20'},
  {'Medicine Name': 'Med2', 'quantity': '24', 'Unit Price': '50'},
  {'Medicine Name': 'Med3', 'quantity': '13', 'Unit Price': '60'},
  {'Medicine Name': 'Med4', 'quantity': '46', 'Unit Price': '10'},
  {'Medicine Name': 'Med5', 'quantity': '43', 'Unit Price': '40'},
  {'Medicine Name': 'Med6', 'quantity': '54', 'Unit Price': '70'},
  {'Medicine Name': 'Med7', 'quantity': '87', 'Unit Price': '23'},
  {'Medicine Name': 'Med8', 'quantity': '21', 'Unit Price': '26'},
  {'Medicine Name': 'Med9', 'quantity': '54', 'Unit Price': '28'},
  {'Medicine Name': 'Med10', 'quantity': '63', 'Unit Price': '65'},
];
List salesreport = [
  {
    'BillNo': 'FC#51935',
    'Date': '2023-10-27',
    'MedName': 'Med1',
    'Quantity': '11',
    'Total': '231',
  },
  {
    'BillNo': 'FC#51935',
    'Date': '2023-10-26',
    'MedName': 'Med1',
    'Quantity': '11',
    'Total': '231',
  },
  {
    'BillNo': 'FC#51935',
    'Date': '2023-10-27',
    'MedName': 'Med4',
    'Quantity': '15',
    'Total': '378',
  },
  {
    'BillNo': 'FC#51935',
    'Date': '2023-10-26',
    'MedName': 'Med9',
    'Quantity': '13',
    'Total': '345',
  },
];
List billMaster = [
  {
    'BillNo': 'FC#51935',
    'BillDate': '2023-10-27',
    'Amount': '21',
    'Gst': 3.78,
    'NetPrice': 24.78,
    'UserId': 'v'
  },
  {
    'BillNo': 'FC#51935',
    'BillDate': '2023-10-26',
    'Amount': '21',
    'Gst': 3.78,
    'NetPrice': 1000.0,
    'UserId': 'v'
  },
  {
    'BillNo': 'FC#98759',
    'BillDate': '2023-10-27',
    'Amount': '45',
    'Gst': 8.1,
    'NetPrice': 53.1,
    'UserId': 'v'
  },
  {
    'BillNo': 'FC#87502',
    'BillDate': '2023-10-26',
    'Amount': '65',
    'Gst': '11.7',
    'NetPrice': 76.7,
    'UserId': 'v'
  },
  {
    'BillNo': 'FC#87502',
    'BillDate': '2023-10-27',
    'Amount': '1500',
    'Gst': '11.7',
    'NetPrice': 76.7,
    'UserId': 'v'
  },
  {
    'BillNo': 'FC#77028',
    'BillDate': '2023-10-26',
    'Amount': '21',
    'Gst': 3.78,
    'NetPrice': 24.78,
    'UserId': 'v'
  },
  {
    'BillNo': 'FC#51935',
    'BillDate': '2023-10-31',
    'Amount': '21',
    'Gst': 3.78,
    'NetPrice': 24.78,
    'UserId': 'v'
  },
  {
    'BillNo': 'FC#51935',
    'BillDate': '2023-10-31',
    'Amount': '2185',
    'Gst': 3.78,
    'NetPrice': 24.78,
    'UserId': 'v'
  },
  {
    'BillNo': 'FC#51935',
    'BillDate': '2023-10-31',
    'Amount': '2950',
    'Gst': 3.78,
    'NetPrice': 24.78,
    'UserId': 'v'
  }
];

List loginHistory = [];
List billformat = [
  {
    'Bill No ': '',
    'Bill Date ': '',
    'Bill Amount ': '',
    'Bill Gst ': '',
    'Net Price ': '',
    'User Id ': ''
  },
];

class BillItem {
  final String name;
  final String brand;
  final int quantity;
  final double unitPrice;

  BillItem(this.name, this.brand, this.quantity, this.unitPrice);

  double get amount => quantity * unitPrice;
}

class BillItemDetails {
  final String billno;
  final billdate;
  final double amount;
  final double gst;
  final String id;

  BillItemDetails(this.billdate, this.amount, this.gst, this.id, this.billno);
  double get price => amount * gst;
}

getotalValue(List list) {
  for (var item in list) {}
}

//!1
class Login {
  final String userId;
  final String password;
  final String role;

  Login({
    required this.userId,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'password': password,
      'role': role,
    };
  }

  factory Login.fromMap(Map<String, dynamic> map) {
    return Login(
      userId: map['userId'],
      password: map['password'],
      role: map['role'],
    );
  }
  static Future<void> saveLoginList(List<Login> loginList) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(loginList.map((item) => item.toMap()).toList());
    prefs.setString('loginList', jsonData);
  }
}

//!2
class LoginHistory {
  final String userId;
  final String type;
  final String date;

  LoginHistory({
    required this.userId,
    required this.type,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'date': date,
    };
  }

  factory LoginHistory.fromMap(Map<String, dynamic> map) {
    return LoginHistory(
      userId: map['userId'],
      type: map['type'],
      date: map['date'],
    );
  }

  static Future<void> saveLoginHistoryList(
      List<LoginHistory> historyList) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData =
        jsonEncode(historyList.map((item) => item.toMap()).toList());
    prefs.setString('loginHistoryList', jsonData);
  }
}

//!5
class BillMaster {
  final String billNo;
  final String billDate;
  final double billAmount;
  final double billGst;
  final double netPrice;
  final String userId;

  BillMaster({
    required this.billNo,
    required this.billDate,
    required this.billAmount,
    required this.billGst,
    required this.netPrice,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'billNo': billNo,
      'billDate': billDate,
      'billAmount': billAmount,
      'billGst': billGst,
      'netPrice': netPrice,
      'userId': userId,
    };
  }

  factory BillMaster.fromMap(Map<String, dynamic> map) {
    return BillMaster(
      billNo: map['billNo'],
      billDate: map['billDate'],
      billAmount: map['billAmount'],
      billGst: map['billGst'],
      netPrice: map['netPrice'],
      userId: map['userId'],
    );
  }
  static Future<void> saveBillMasterList(List<BillMaster> billList) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(billList.map((item) => item.toMap()).toList());
    prefs.setString('BillMaster', jsonData);
  }
}

//!4
class Stock {
  String medicineName;
  int quantity;
  double unitPrice;

  Stock({
    required this.medicineName,
    required this.quantity,
    required this.unitPrice,
  });

  // Convert the StockItem to a Map
  Map<String, dynamic> toMap() {
    return {
      'medicineName': medicineName,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  // Create a StockItem from a Map
  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      medicineName: map['medicineName'],
      quantity: map['quantity'],
      unitPrice: map['unitPrice'],
    );
  }
  static saveStockData(List<Stock> stockList) async {
    final prefs = await SharedPreferences.getInstance();
    final stockData = stockList.map((item) => item.toMap()).toList();
    final jsonData = jsonEncode(stockData);
    prefs.setString('stock', jsonData);
  }
}

//!3
class MedicineMaster {
  String medicineName;
  String brand;

  MedicineMaster({
    required this.medicineName,
    required this.brand,
  });

  // Convert the MedicineMaster to a Map
  Map<String, dynamic> toMap() {
    return {
      'medicineName': medicineName,
      'brand': brand,
    };
  }

  // Create a MedicineMaster from a Map
  factory MedicineMaster.fromMap(Map<String, dynamic> map) {
    return MedicineMaster(
      medicineName: map['medicineName'],
      brand: map['brand'],
    );
  }

  static Future<void> saveMedicineMasterList(
      List<MedicineMaster> medicineList) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData =
        jsonEncode(medicineList.map((item) => item.toMap()).toList());
    print('Mohan $jsonData');
    prefs.setString('medicineMaster', jsonData);
  }
}

//!6
class BillDetails {
  final String billNo;
  final String medicineName;
  final int quantity;
  final double unitPrice;
  final double amount;

  BillDetails({
    required this.billNo,
    required this.medicineName,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'billNo': billNo,
      'medicineName': medicineName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'amount': amount,
    };
  }

  factory BillDetails.fromMap(Map<String, dynamic> map) {
    return BillDetails(
      billNo: map['billNo'],
      medicineName: map['medicineName'],
      quantity: map['quantity'],
      unitPrice: map['unitPrice'],
      amount: map['amount'],
    );
  }

  static Future<void> saveBillDetailsList(List<BillDetails> detailsList) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData =
        jsonEncode(detailsList.map((item) => item.toMap()).toList());
    prefs.setString('billDetailsList', jsonData);
  }
}
