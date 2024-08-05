import 'package:fastcart/auth/userAuth.dart';
import 'package:fastcart/consts/colors.dart';
import 'package:fastcart/pages/home/home.dart';
import 'package:fastcart/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
void authcheck()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

  await Future.delayed(Duration(seconds: 2), () {
token!=null?Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage())):Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
  });
}

  @override
  void initState() {
    super.initState();
    authcheck();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lighTheme,
      body:Center(
       
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
              Image.asset(
                          "assets/images/logo.png",
                          height: 50,
                          width: 50,
                        ),
            Text("Fastcart",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}