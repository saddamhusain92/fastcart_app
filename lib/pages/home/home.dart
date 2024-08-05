import 'package:fastcart/consts/const.dart';
import 'package:fastcart/pages/login/login.dart';
import 'package:fastcart/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fastcart/consts/colors.dart';
import 'package:fastcart/pages/home/navigator_items.dart';
import 'package:fastcart/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);
    return Scaffold(

      appBar:AppBar(
        backgroundColor: darkTheme,
        title: TextWidget(lable: "Fastcart",color:whiteTheme),
        actions: [
        IconButton(onPressed: (){
          
        }, icon: Icon(LucideIcons.search,color: Colors.white,)),
       Center(
         child: Badge(
          label: Text(provider.cart.length.toString()),
          child:GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/cart');
            },
            child: Icon(LucideIcons.shopping_cart,color: whiteTheme,))
         ),
       ),
       SizedBox(width: 12,)
        ],
        ),
        drawer:currentIndex==2?null: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('John Doe'),
              accountEmail: Text('johndoe@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage:NetworkImage("https://asset.brandfetch.io/id0HloHs0j/iduo_Gkbmg.jpeg"),
              radius: 40,
          ),
              decoration: BoxDecoration(
                color:lighTheme,
              ),
            ),
            ListTile(
              title: Text('Home'),
              leading: Icon(Icons.home),
              onTap: () {
                // Handle tap on Home
              Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Cart'),
              leading: Icon(Icons.shopping_cart_checkout),
              onTap: () {
                // Handle tap on Home
              Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings),
              onTap: () {
                // Handle tap on Settings
              },
            ),
            ListTile(
              title: Text('About'),
              leading: Icon(Icons.info),
              onTap: () {
                // Handle tap on About
              },
            ),
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.logout_outlined),
              onTap: logoutUser,
            ),
          ],
        ),
      ),
      body: navigatorItems[currentIndex].screen,
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
  BottomNavigationBar buildBottomNavigationBar(){
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex:currentIndex ,
      onTap: (index)=>setState(()=>currentIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: darkTheme,
      unselectedItemColor: grayTheme,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      items: navigatorItems.map((e) => getNavigatorBarItem(e)).toList());
  }
  BottomNavigationBarItem getNavigatorBarItem(NavigatorItems item){
   Color iconcolor = item.index ==currentIndex ?darkTheme:grayTheme;
   return BottomNavigationBarItem(label: item.label,icon: item.icon,);
  }
  void logoutUser()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));

  }
}

