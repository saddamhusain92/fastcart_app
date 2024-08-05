import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:fastcart/api/apiServices.dart';
import 'package:fastcart/components/categories_widget.dart';
import 'package:fastcart/consts/colors.dart';
import 'package:fastcart/models/category.dart';
import 'package:fastcart/provider/product_provider.dart';
import 'package:fastcart/widgets/text_widget.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class MyCategories extends StatefulWidget {
  const MyCategories({super.key});

  @override
  State<MyCategories> createState() => _MyCategoriesState();
}

class _MyCategoriesState extends State<MyCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children:[
            Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: categoriesList(),
              )
              
              )
          ]
          ),
      ),
    );
  }
Widget getStaggeredGrid(List<CategoryModel> data){
    
  return StaggeredGrid.count(
    mainAxisSpacing: 4.0,
    crossAxisSpacing: 1.0,
    crossAxisCount: 4,
    children: data.asMap().entries.map<Widget>((e) {
      int index = e.key;
      CategoryModel categoryItem = e.value;
      return GestureDetector(
      onTap:()=>onCategoryItem(context,categoryItem),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Cardcategories(item: categoryItem,),
      ),
      );

    }).toList(),
    );
}

Widget categoriesList(){
  return FutureBuilder(future: APIServices.getCategories(),
   builder: (BuildContext context, AsyncSnapshot<List<CategoryModel>?> model){
if(model.hasData){
  return  getStaggeredGrid(model.data!);
}
else{
  return StaggeredGrid.count(
    mainAxisSpacing: 4.0,
    crossAxisSpacing: 1.0,
    crossAxisCount: 4,
    children: ["","","",""].asMap().entries.map<Widget>((e) {
      int index = e.key;
     
      return GestureDetector(
      onTap:(){},
      child: Container(
        padding: EdgeInsets.all(10),
        child: Shimmer(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10)
            ),
            height: 90,
         
          )),
      ),
      );

    }).toList(),
    );
}
  });
}
void onCategoryItem(BuildContext context , CategoryModel categoryItem){
   var productProvide =Provider.of<ProductsProvider>(context,listen: false);
   productProvide.setProductCategory(categoryItem.categoryId);
   Navigator.of(context).pushNamed("/products",arguments: {
 'catId':categoryItem.categoryId,
 'catName':categoryItem.categoryName
   });

}
}