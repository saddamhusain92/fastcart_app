import 'dart:convert';

import 'package:fastcart/consts/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class userProvider with ChangeNotifier {
  String _name = '';
  String _avatar = '';
 Map<String,dynamic> _mainAddress = {
      "first_name": "",
    "last_name": "",
    "company": "",
    "address_1": "",
    "address_2": "",
    "city": "",
    "postcode": "",
    "country": "",
    "state": "",
    "phone": ""
 };
  String _address = "";
  int _uid = 0;
  String get getName => _name;
  String get getavatar => _avatar;
  String get getaddress => _address;
  Map<String,dynamic> get getmainAddress => _mainAddress;
  int get getuid => _uid;

  void getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final userResponse = await http.get(
        Uri.parse('https://${Config.apiurl}/wp-json/wp/v2/users/me'),
        headers: {
          'Authorization': 'Bearer $token',
        });
    if (userResponse.statusCode == 200) {
      final userJson = jsonDecode(userResponse.body);
      _uid = userJson['id'];
      _name = userJson['name'];
      _avatar = userJson['avatar_urls']['48'];
      getAddress(_uid);
    } else {
      throw Exception('Failed to retrieve user data');
    }
    notifyListeners();
  }

  void getAddress(int userID) async {
    var url = Uri.parse(
        'https://${Config.apiurl}/wp-json/wc/v3/customers/$userID?consumer_key=${Config.consumer_key}&consumer_secret=${Config.consumer_secret}');
    final addressResponse = await http.get(url);
    if (addressResponse.statusCode >= 200 && addressResponse.statusCode < 300) {
      final addressJson = jsonDecode(addressResponse.body);
      _mainAddress = addressJson['billing'];
      _address =
          "$_name \n${addressJson['billing']['address_1'] + " " + addressJson['billing']['address_1']} \n${addressJson['billing']['city'] + " , Pincode " + addressJson['billing']['postcode'] + " ${addressJson['billing']['state']}  (" + addressJson['billing']['country']})\nmobile ${addressJson['billing']['phone']}";
      print(_mainAddress);
    } else {
      print(addressResponse.reasonPhrase);
    }
  }
}
