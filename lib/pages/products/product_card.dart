import 'package:fastcart/utils/strSplitter.dart';
import 'package:flutter/material.dart';
import 'package:fastcart/consts/colors.dart';
import 'package:fastcart/models/products.dart';

class ProductItemCard extends StatelessWidget {
  const ProductItemCard({super.key, required this.item});
  final ProductModel item;
  final double width = 174;
  final double hight = 500;

  @override
  Widget build(BuildContext context) {
   
    return Container(
      padding: EdgeInsets.all(8),
      width: width,
      height: hight,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width,
            // child: Image.network(item.image![0].url.toString(),fit: BoxFit.cover,),
            child:ClipRRect(
        borderRadius: BorderRadius.circular(10.0), // adjust the radius value as needed
        child: Image.network(item.image![0].url.toString(),fit: BoxFit.cover,),
      ),
            
          ),
          SizedBox(height: 10,),
          Text(item.productName!,textAlign:TextAlign.center,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
           SizedBox(height: 5,),
          Text(strSpliter("${item.description}"),textAlign:TextAlign.center,style: TextStyle(fontSize: 12,),),
           Row(
            children: [
            Text("\$${item.price!}",textAlign:TextAlign.center,style: TextStyle(fontSize: 14),),
            Spacer(),
            ],
           )
      
        ]
        ),
    );
  }


 
}