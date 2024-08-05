import 'package:fastcart/auth/userAuth.dart';
import 'package:fastcart/checkout/checkout.dart';
import 'package:fastcart/consts/fonts.dart';
import 'package:fastcart/pages/cart/cart_page.dart';
import 'package:fastcart/pages/login/login.dart';
import 'package:fastcart/pages/products/products_details.dart';
import 'package:fastcart/pages/splashscreen/splash_screen.dart';
import 'package:fastcart/provider/cart_provider.dart';
import 'package:fastcart/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fastcart/pages/home/home.dart';
import 'package:fastcart/provider/product_provider.dart';

import 'pages/products/products_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => ProductsProvider(),
      child: ProductsPage(),
      ),
      ChangeNotifierProvider(create: (context) => CartProvider(),
      child: ProductsPage(),
      ),
      ChangeNotifierProvider(create: (context) => userProvider(),
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      
      routes: <String,WidgetBuilder>{
        '/':(context) =>SplashScreen(),
        '/home':(context) => MyHomePage(),
        '/checkout':(context) => Mycheckout(),
        '/cart':(context) => MyCartPage(),
        // '/':(context) =>isLoggedIn==null?LoginPage(): MyHomePage(),
        '/products':(context) => ProductsPage(),
        '/products_details':(context) => ProductDetails(),
        
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
    ));
  }
}
