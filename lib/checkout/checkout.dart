import 'dart:convert';

import 'package:fastcart/consts/colors.dart';
import 'package:fastcart/consts/config.dart';
import 'package:fastcart/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_rich_text/easy_rich_text.dart';

class Mycheckout extends StatefulWidget {
  const Mycheckout({super.key});

  @override
  State<Mycheckout> createState() => _MycheckoutState();
}

class _MycheckoutState extends State<Mycheckout> {
  String product_id = "";
  String productName = "";
  String productPrice = "";
  String productImage = "";

  int quantity = 1;
  void checkoutProduct() async {
    var headersList = {'Accept': '*/*', 'Content-Type': 'application/json'};
    var url = Uri.parse(
        'https://milive.cloud${Config.apiEndPoint}orders?consumer_key=${Config.consumer_key}&consumer_secret=${Config.consumer_secret}');

    var body = {
      "payment_method": "bacs",
      "payment_method_title": "Cash on delivery",
      "set_paid": true,
      "billing": {
        "first_name": "John",
        "last_name": "Doe",
        "address_1": "969 Market",
        "address_2": "",
        "city": "San Francisco",
        "state": "CA",
        "postcode": "94103",
        "country": "US",
        "email": "john.doe@example.com",
        "phone": "(555) 555-5555"
      },
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
      "line_items": [
        {"product_id": 67, "quantity": quantity},
        {"product_id": 66, "quantity": quantity},
        {"product_id": 69, "quantity": quantity},
      ],
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    var productList = Provider.of<ProductsProvider>(context, listen: false);
    product_id = arguments['productId'].toString() ?? "";
    productName = arguments['productName'].toString() ?? "";
    productPrice = arguments['productPrice'].toString() ?? "";
    productImage = arguments['productImage'].toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Checkout"),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height / 10,
        decoration: BoxDecoration(
          color: lighTheme,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "₹ ${int.parse(productPrice) * quantity}",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "View price details",
                  style: TextStyle(color: darkTheme, fontSize: 17),
                ),
              ],
            ),
            SizedBox(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkTheme,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // <-- Radius
                    ),
                  ),
                  onPressed: () => checkoutProduct(),
                  child: Text(
                    "Place Order",
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // padding: EdgeInsets.all(10),
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              10.0), // adjust the radius value as needed
                          child: Image.network(productImage, fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$productName",
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  "MRP $productPrice",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        if (quantity != 1) {
                                          setState(() {
                                            quantity--;
                                          });
                                        }
                                      },
                                      icon: Icon(Icons.remove)),
                                  Text("$quantity"),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          quantity++;
                                        });
                                      },
                                      icon: Icon(Icons.add))
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Price Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Price (1 item)",style: TextStyle(fontSize: 16)),
                Text("$productPrice",style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Discount",style: TextStyle(fontSize: 16)),
                Text("00",style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Delivery Charges",style: TextStyle(fontSize: 16)),
                Text(
                  "Free",
                  style: TextStyle(color: Colors.green,fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            DottedDashedLine(
                height: 0, width: double.infinity, axis: Axis.horizontal),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Customer Price",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                Text("$productPrice"),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text("Address Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(
              height: 14,
            ),
            EasyRichText(
              "Saddam husain \n EasyRichText example with default grey font. bold I want blue font here.\nPincode 497119",
              defaultStyle: TextStyle(color: Colors.black),
              patternList: [
                EasyRichTextPattern(
                  targetString: 'Saddam husain',
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
                EasyRichTextPattern(
                  targetString: 'bold',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20,),
             Text("Payments",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(8)
                ),
                alignment: Alignment.topCenter,
                 child: Text("Cash on delivery",style: TextStyle(fontSize: 20,color: darkTheme),),
              ),
            Spacer(),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              height: 200,
              child: Center(
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
            SizedBox(
              height: 20,
            )
          ],
        ),
      )),
    );
  }

}
