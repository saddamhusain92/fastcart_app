import 'package:fastcart/api/apiServices.dart';
import 'package:fastcart/models/products.dart';
import 'package:flutter/material.dart';

class ProductRelated extends StatefulWidget {
    
const ProductRelated({super.key, required this.products, this.title="test"});
  final List<int> products; 
  final String title;


  @override
  State<ProductRelated> createState() => _ProductRelatedState();
}

class _ProductRelatedState extends State<ProductRelated> {
  @override
  Widget build(BuildContext context) {
    
    return Container(
      color: Colors.white,
      child: Padding(
        padding:EdgeInsets.only(
          left: 15.0,
          bottom: 8,
          top: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
               Text(widget.title,style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
               ),),
               SizedBox(height: 10,),
               _productList(),

          ],
        ),
        ),
    );
  }
  Widget _productList(){
    return FutureBuilder(
      future: APIServices.getProducts(productIds: widget.products),
    builder:(BuildContext context,AsyncSnapshot<List<ProductModel>?>model){
      if(model .hasData){
        return _buildList(model!.data!);
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    }, );
}
Widget _buildList(List<ProductModel> items){
  return Container(
    height: 230,
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