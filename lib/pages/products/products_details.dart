import 'package:fastcart/api/apiServices.dart';
import 'package:fastcart/consts/colors.dart';
import 'package:fastcart/models/products.dart';
import 'package:fastcart/pages/products/product_related.dart';
import 'package:fastcart/provider/cart_provider.dart';
import 'package:fastcart/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
 ProductModel? model;
 bool active = true;
 String? productId,productName;
  @override
void didChangeDependencies(){
  super.didChangeDependencies();
  final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
  var productList = Provider.of<ProductsProvider>(context, listen: false);
 productId =arguments['productId'].toString()??"";
 productName = arguments['productName'].toString()??"";
}
  @override
  void initState() {   
    // TODO: implement initState
    super.initState(); 
    model = ProductModel();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(productName.toString()),
        actions: []),
        body: SafeArea(
          child: Container(
            // color: HexColor("#f3f1f6"),
            child: productDetails(),
          ),
        ), 
       
    );
  } 
  Widget productDetails(){
    return FutureBuilder(
      future: APIServices.getProductDetails(productId),
      builder: (BuildContext context,AsyncSnapshot<ProductModel?>data){
        if(data.hasData){
          model = data.data;
          return SingleChildScrollView
          (child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
           
            children: [
              getImage(),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(model!.productName!,style: TextStyle(fontSize: 20,
                fontWeight: FontWeight.bold),),
                buildAddtoCart(),
                productInformation(),
                SizedBox(height: 10),
                ProductRelated(title: "Product Related",products:model!.relatedId!),

                    
                  ],
                ),
              )
            
            ],
          ));
        }
        return Center(
          child: CircularProgressIndicator(
            color: lighTheme,
          ),
        );
      }
       );
  } 
  Widget getImage(){
    return Container(
      padding: EdgeInsets.all(8),
      height: MediaQuery.of(context).size.height/3,
      width: MediaQuery.of(context).size.width,
      child: ClipRRect(
  borderRadius: BorderRadius.circular(10.0), // adjust the radius value as needed
  child: Image.network(model!.image![0].url!,fit: BoxFit.cover),
),
      // child: Image.network(model!.image![0].url!,fit: BoxFit.cover),
    );
  }
  Widget buildAddtoCart(){
     final provider = Provider.of<CartProvider>(context);
    return ListTile(
      contentPadding: EdgeInsets.only(
      top: 10,
      bottom: 10,
      left: 5,
      right: 5,
      ),
      title: Text("Rs \$ ${model!.price}",style: TextStyle(fontSize: 20,color: Colors.grey.shade600),),

      trailing: SizedBox(
        width: 238,
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: (){

              provider.addProducts(model!.productId!, int.parse(model!.price!),"${model!.productName}","${model!.image![0].url}");
          //  provider.addProducts(1, 12, "tes", "kjkjdkjkfj");
            },
            style: ElevatedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: lighTheme
              ),
             child: Text("Add to cart",style: TextStyle(color: Colors.white),)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: lighTheme
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/checkout',arguments: {
                    'productId':model!.productId,
                    'productName':model!.productName,
                    'productPrice':model!.price,
                    'productImage':model!.image![0].url
            
            
                });
              },
              child: Text("Buy now",style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),

    );
  }
    Widget productInformation(){
    return ExpansionPanelList(
      elevation: 0,
      dividerColor: Colors.transparent,
      expandedHeaderPadding: EdgeInsets.symmetric(vertical: 5),
      expansionCallback: (int expendedIndex,bool isExpnaded){
      active = !active;
      setState(() {
        
      });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, isExpanded){
            return ListTile(
              title: Text("Product Information",style: TextStyle(fontSize: 20),),
            );
          },
            body: Align(alignment: Alignment.topLeft,
            child: Text(model!.description!,)
            ,),
            isExpanded: active,
            canTapOnHeader: true
            )
       ],

    );
  }
}