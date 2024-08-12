import 'dart:convert';
import 'package:fastcart/consts/colors.dart';
import 'package:fastcart/consts/config.dart';
import 'package:fastcart/models/user.dart';
import 'package:fastcart/provider/userProvider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading =false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();   
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Image.asset(
                        "assets/images/logo.png",
                        height: 50,
                        width: 50,
                      )
                    ],
                  ),
                  Text(
                    "Woocommerce",
                    style: TextStyle(fontSize: 50),
                  ),
                ],
              ),
              Column(
                children: [
                  TextFormField(
                     controller: usernameController,

                    decoration: InputDecoration(
                      focusedBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: darkTheme,width: 2),
                        borderRadius:
                              const BorderRadius.all(Radius.circular(10))
                      ),
                        hintText: "Email",
                        isDense: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: lighTheme,width: 2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        )),
                    maxLines: 1, // controller: cpfcontroller,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                     controller: passwordController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: darkTheme,width: 2),
                        borderRadius:
                              const BorderRadius.all(Radius.circular(10))
                      ),
                        hintText: "password",
                        isDense: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: lighTheme,width: 2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        )),
                    maxLines: 1, // controller: cpfcontroller,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkTheme,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set the radius to 20.0
                            ), // background
                          ),
                          onPressed: () => userLogin(context,
                          username: usernameController.text,
                          password: passwordController.text,
                              // username: "john.doe@example.com",
                              // password: "Husain25@"
                              ),
                          child:isLoading?
                          CircularProgressIndicator(color: whiteTheme,strokeWidth: 8,):Text(
                            "Login",
                            style: TextStyle(color: whiteTheme, fontSize: 20),
                          )))
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Don't have an account ?"),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lighTheme,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set the radius to 20.0
                            ), // background
                          ),
                          onPressed: () async {
                          Navigator.of(context).pushNamed('/home');

                            
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: whiteTheme, fontSize: 20),
                          )))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future userLogin(BuildContext context, {username, password}) async {
    setState(() {
      isLoading = true;
    });
// Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = 'https://${Config.apiurl}/wp-json/jwt-auth/v1/token';
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final body = {
      'username': username,
      'password': password,
    };

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final token = jsonData['token'];
      await prefs.setString('token', token);
        Navigator.of(context).pushNamed('/home');
         setState(() {
      isLoading = false;
    });
    } else {
      setState(() {
      isLoading = false;
    });
    }
  }
}
