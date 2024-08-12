import 'dart:convert';
import 'dart:developer';
import 'package:alert_banner/types/enums.dart';
import 'package:alert_banner/widgets/alert.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:fastcart/consts/colors.dart';
import 'package:fastcart/models/user.dart';
import 'package:fastcart/provider/userProvider.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:fastcart/consts/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    new Future.delayed(const Duration(seconds: 2), () =>isLoading=false );
   
  }
  Widget build(BuildContext context) {
          final provider = Provider.of<userProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SafeArea(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(provider.getavatar),
            radius: 50,
          ),
          SizedBox(height: 10),
          Text("Welcome to the Fastcart",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600)),
          SizedBox(height: 10,),
          Row(
        children: [
            
         Text("Hey!",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
         Text(" ${provider.getName}".toUpperCase(),style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
        ],
          ),
             SizedBox(height: 10,),
             Container(
              height: 50,
              width: MediaQuery.of(context).size.width/2,
             decoration: BoxDecoration(
               color:lighTheme,
               borderRadius: BorderRadius.circular(10),
             ),
             child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.center,
              margin: EdgeInsets.all(4),
               decoration: BoxDecoration(
             color: darkTheme,
               borderRadius: BorderRadius.circular(10),
             ),
              child: Text("Edit Profile",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
             ),
             ),
             SizedBox(height: 10,),
             Text("Orders",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
             SizedBox(height: 10,),
             GestureDetector(
              onTap:(){
                showTopSnackBar(
                  dismissType: DismissType.onSwipe,
                  displayDuration:const Duration(microseconds: 100),
                        Overlay.of(context),
                        const CustomSnackBar.info(
                          backgroundColor:Color.fromARGB(255, 167, 110, 179),
                          message:
                              'There is some information. You need to do something with that',
                        ),
                      );
              },
              child: Text("Address",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
              )),
SizedBox(height: 10,),
         Text("Shipping details",style: TextStyle(fontSize:18,fontWeight: FontWeight.w500)),
     provider.getUpdate?ElevatedButton(
       style: ElevatedButton.styleFrom(
                    backgroundColor: darkTheme,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9), // <-- Radius
                    ),
                  ),
      onPressed: (){
        Navigator.of(context).pushNamed('/update_address');
      }, child: Text("Update Address",style: TextStyle(color: whiteTheme),)):
        EasyRichText(
              "${provider.getaddress}",
              defaultStyle: TextStyle(color: Colors.black),
              
            )
          ],
        )),
      ));
  }
}
