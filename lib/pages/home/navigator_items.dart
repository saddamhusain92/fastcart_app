
import 'package:fastcart/pages/cart/cart_page.dart';
import 'package:fastcart/pages/home/home_page.dart';
import 'package:fastcart/pages/user/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fastcart/pages/categories/categories.dart';

class NavigatorItems{
  final  String label;
  final Widget icon;
  final int index;
  final Widget screen;
NavigatorItems(this.label, this.icon, this.index, this.screen);
}

List<NavigatorItems> navigatorItems = [
  NavigatorItems("Home", Icon(LucideIcons.house), 0, HomePage()),
  NavigatorItems("Categories", Icon(LucideIcons.layout_grid), 1, MyCategories()),
  // NavigatorItems("Cart", Badge(
  //   label: Text("3"),
  //   child: Icon(LucideIcons.shopping_cart),
  // ), 2, MyCartPage()),
  NavigatorItems("Account", Icon(LucideIcons.circle_user), 3, MyProfile()),
];