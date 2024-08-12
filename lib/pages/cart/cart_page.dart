import 'dart:convert';

import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:fastcart/consts/colors.dart';
import 'package:fastcart/consts/config.dart';
import 'package:fastcart/consts/const.dart';
import 'package:fastcart/provider/cart_provider.dart';
import 'package:fastcart/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class MyCartPage extends StatefulWidget {
  const MyCartPage({super.key});

  @override
  State<MyCartPage> createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  
    void checkoutProduct(List<Map<String, dynamic>> cartItems,Map<String, dynamic> address) async {
     
    var headersList = {'Accept': '*/*', 'Content-Type': 'application/json'};
    var url = Uri.parse(
        'https://milive.cloud${Config.apiEndPoint}orders?consumer_key=${Config.consumer_key}&consumer_secret=${Config.consumer_secret}');

    var body = {
      "payment_method": "bacs",
      "payment_method_title": "Cash on delivery",
      "set_paid": true,
      "billing": address,
      "shipping": {
        "first_name": "John",
        "last_name": "Doe",
        "address_1": "969 Market",
        "address_2": "",
        "city": "San Francisco",
        "state": "CA",
        "postcode": "94103",
        "country": "US"
      },
      "line_items":cartItems,
      "shipping_lines": [
        {
          "method_id": "flat_rate",
          "method_title": "Flat Rate",
          "total": "10.00"
        }
      ]
    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);
    var res = await req.send();
    final resBody = await res.stream.bytesToString();
    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
    } else {
      print(res.reasonPhrase);
    }
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);
    final useprovider = Provider.of<userProvider>(context);
    return Scaffold(
      appBar: AppBar
        (title: Text("My Cart"),
      leading: IconButton(
        onPressed: (){
          Navigator.of(context).pushNamed('/home');
        },
        icon: Icon(Icons.arrow_back),
      ),
      ),
      backgroundColor: Colors.grey.shade300,
      body:Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          Expanded(
            child:provider.cart.isEmpty?Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.shopping_cart,size: 100,color: darkTheme,),
                  Text("Your cart is empty",style: TextStyle(fontSize: 20),)
              
                ],
              ),
            ): ListView.separated(
                itemBuilder: (context,index)=>Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,borderRadius: BorderRadius.circular(20)
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Image.network(provider.cart[index]['image'],fit: BoxFit.contain),
                          ),
                          SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${provider.cart[index]['title']}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                              SizedBox(height: 10,),
                              Text("Quantity ${provider.cart[index]['quantity']}",style: TextStyle(fontSize: 14),),
                              SizedBox(height: 10,),
                              Text("MRP Rs ${provider.cart[index]['price']}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
            
                            ],
            
                          )
                        ]),
            
                  ),
                ),
                Positioned(
                    right: 5,
                    top: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(onPressed: (){}, icon: Icon(Icons.delete),),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1,color: Colors.grey.shade500),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                                children: [
                                  IconButton(onPressed: (){
                                    provider.decreaseQuantity(provider.cart[index]['id']);
                                  }, icon: Icon(Icons.remove),),
                                  Text(provider.cart[index]['quantity'].toString(),style: TextStyle(fontSize:15,fontWeight: FontWeight.bold),),
                                  IconButton(onPressed: (){
                                    provider.increaseQuantity(provider.cart[index]['id']);
                                  }, icon: Icon(Icons.add),),
                                ]
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            )
                , separatorBuilder: (context,index){
                  return SizedBox(height:4,);
                }, itemCount: provider.cart.length
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              height: 100,
              child:provider.cartItems.isEmpty?null:Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 35,
                      child: Icon(LucideIcons.shield_check),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "safe and secure payments. easy returns. \n100% Authentic Products",
                      style: TextStyle(color: Colors.grey.shade500),
                    )
                  ],
                ),
              ),
            ),
          Expanded(
            child:provider.cart.isEmpty?SizedBox():Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Price Details",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Price (${provider.cart.length} items)",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
                        Text("${provider.totalAmount}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
                      ],
                    ),
                    SizedBox(height: 6,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Discount",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
                        Text("Rs 00",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
                      ],
                    ),
                    SizedBox(height: 6,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Delivery Charges",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
                        Text("FREE Delivery",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color:HexColor("#388E3C")),),
                      ],
                    ),
                    SizedBox(height: 8,),
                     DottedDashedLine(
                height: 0, width: double.infinity, axis: Axis.horizontal,dashColor: Colors.grey.shade500,),
                SizedBox(height: 8,),
                 Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${provider.totalAmount}",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold),),
                     useprovider.getUpdate?ElevatedButton(
                      style: ElevatedButton.styleFrom(
                    backgroundColor: darkTheme,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // <-- Radius
                    ),
                  ),  
                      onPressed: (){
                         Navigator.of(context).pushNamed('/update_address');
                      }, child: Text("Address Update",style: TextStyle(color: Colors.white,fontSize: 18),)):ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkTheme,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // <-- Radius
                    ),
                  ),
                  onPressed: (){
                        checkoutProduct(provider.cartItems,useprovider.getmainAddress);
                        new Future.delayed(const Duration(seconds: 2), () => provider.clearCart());
                  },
                  child: Text(
                    "Place Order",
                    style: TextStyle(color: Colors.white,fontSize: 18),
                  )),
                      ],
                    ),
                  ]
                ),
              ),
            )
            )
        ],
      ),
    );
  }
}
