import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fastcart/consts/colors.dart';
import 'package:fastcart/models/category.dart';
import 'package:fastcart/widgets/text_widget.dart';

class Cardcategories extends StatelessWidget {
const Cardcategories({super.key, required this.item});
final CategoryModel item;
final double height = 150.0;
final double width = 175.0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
       Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(.1),
            borderRadius: BorderRadius.circular(18.0)
          ),
          child: Column(
            children: [
              Container(
                height: 90,
                width: 100,
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child:(item.image?.url)!= null? ClipRRect(
  borderRadius: BorderRadius.circular(15.0), // adjust the radius value as needed
  child: Image.network(item.image!.url!,fit: BoxFit.cover,),
):Center(child: TextWidget(lable: "No Image",size: 10.0))
                 
                ),
              )
            ],
          ),
        ),
       ),
       SizedBox(
        height: 30,
        child: TextWidget(lable: item.categoryName,size: 12.0),
       )
      ],
    );
  }
}