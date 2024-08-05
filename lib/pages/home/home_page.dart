import 'package:fastcart/api/apiServices.dart';
import 'package:fastcart/components/categories_widget.dart';
import 'package:fastcart/consts/colors.dart';
import 'package:fastcart/consts/fonts.dart';
import 'package:fastcart/models/category.dart';
import 'package:fastcart/models/products.dart';
import 'package:fastcart/provider/product_provider.dart';
import 'package:fastcart/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
class HomePage extends StatefulWidget {
   HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _slider =  ["slider_1.png","slider_2.png","slider_3.png","slider_4.png"];
  @override
  Widget build(BuildContext context) {
      final provider = Provider.of<userProvider>(context);
      final getuser = provider.getUser();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        
            Shimmer(
               duration: const Duration(seconds: 3), //Default value
            interval: const Duration(microseconds: 10), //Default value: Duration(seconds: 0)
            color: darkTheme, //Default value
            enabled: true, //Default value
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                color: lighTheme,
                height: 45,
                child: Row(
                 children: [
                  Container(
                child: const Icon(LucideIcons.map_pin),
                  ),
                  const SizedBox(width: 10),
                  const Text("Deliver To User Name Address 497119",style: TextStyle(
                  ),),
                  const Icon(LucideIcons.chevron_down,size: 20,)
                 ],
                ),
              ),
            ),
            const SizedBox(height: 3),
            FlutterCarousel(
          options: CarouselOptions(
            autoPlay: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 10),
            height: 170.0, 
            showIndicator: true,
            slideIndicator:CircularSlideIndicator( 
            ),
          ),
          items:_slider.map((i) {
            return Builder(
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: const BoxDecoration(
              // color: Colors.amber,
            ),
            child:ClipRRect(
          borderRadius: BorderRadius.circular(10.0), // adjust the radius value as needed
          child: GestureDetector(
            onTap: () {
        
            },
            child: Image.asset("assets/images/$i",fit: BoxFit.cover,)
            ),
        ) 
            // Image.asset("assets/images/$i",fit: BoxFit.cover,),
          );
        },
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        categoriesList(),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("Latest Products",style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold),),
        ),
        const SizedBox(height: 10),
        _getProducts(),
        Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          child:Image.asset("assets/images/offer.jpg",fit: BoxFit.cover,) ,
        )
          ],
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
        padding: const EdgeInsets.all(10),
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
        padding: const EdgeInsets.all(10),
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

  Widget _getProducts(){
    return FutureBuilder(
      future: APIServices.getProducts(sortBy: "modified"),
    builder:(BuildContext context,AsyncSnapshot<List<ProductModel>?>model){
      if(model .hasData){
        return _buildList(model!.data!);
      }
      return StaggeredGrid.count(
    mainAxisSpacing: 4.0,
    crossAxisSpacing: 1.0,
    crossAxisCount: 4,
    children: [""].asMap().entries.map<Widget>((e) {
      int index = e.key;
     
      return GestureDetector(
      onTap:(){},
      child: Container(
        width: 300,
        height:140,
        padding: const EdgeInsets.all(4),
        child: Shimmer(
          child: Container(
            width: 130,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10)
            ),
         
          )),
      ),
      );

    }).toList(),
    );
    }, );
}
Widget _buildList(List<ProductModel> items){
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    height: 200,
    alignment: Alignment.centerLeft ,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (context,int index){
        var data = items[index];
        return Padding(
          padding: const EdgeInsets.only(right: 5),
          child: GestureDetector(
            onTap: ()=>onProductItemDetails(context, data),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                  _getImage(data),
                  _getName(data),
                  _getPricee(data)
              ],
            ),
             
          ),
        );
      }
    )

  );
}
Widget _getImage(ProductModel data){
  return ClipRRect(
  borderRadius: BorderRadius.circular(8.0), // adjust the radius value as needed
  child: Image.network(data.image![0].url!,height: 120),
);
}
Widget _getName(ProductModel data){
  return Text(data.productName!);
}
Widget _getPricee(ProductModel data){
  return Text(data.price!);
}
 void onProductItemDetails(BuildContext context , ProductModel model){
  Navigator.of(context).pushNamed('/products_details',arguments: {
    'productId':model.productId,
    'productName':model.productName
  });
  }
}