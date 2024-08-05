import 'package:fastcart/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fastcart/models/products.dart';
import 'package:fastcart/pages/products/product_card.dart';
import 'package:fastcart/provider/product_provider.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  String? categoryId, categoryName;
final _sortOption = [
  SortBy('popularity', 'Popularity', 'asc'),
  SortBy('modified', 'Latest', 'asc'),
  SortBy('price', 'High to low', 'desc'),
  SortBy('price', 'Low to high', 'asc'),
];
@override
void didChangeDependencies(){
  super.didChangeDependencies();
  final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
  categoryId = arguments['catId'].toString();
  categoryName = arguments['catName'].toString();
  var productList = Provider.of<ProductsProvider>(context, listen: false);
  // _scrollController.addListener(() {
  //   if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
  //     productList.setLoadMoreState(LodeMoreStatus.LOADING);
  //     productList.fetchProducts(++_page,strSearch: "", categoryId: categoryId.toString());
  //   }
  // });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child:Container(
            child: Padding(padding: EdgeInsets.only(left: 25),
            child:  Icon(Icons.arrow_back_ios_new,color: Colors.black,),
            ),
           
          ),
        ),
        actions: [
        _productFilter()
        ],
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Text(categoryName!,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        ),
      ),
      body: _productsList(),
    );
  }
  Widget _productsList(){
    return Consumer<ProductsProvider>(builder:(context,productModel,child){
          if(productModel.allProducts.isNotEmpty && productModel.getLoadMoreStaus()!=LodeMoreStatus.INITIAL){
        return Column(
          children: [
            Flexible(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                controller:_scrollController,
                shrinkWrap: true,
                childAspectRatio: (150/193),
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(1),
            children: productModel.allProducts.map((ProductModel item){
              return GestureDetector(
                onTap:()=>onProductItemDetails(context, item),
                child: ProductItemCard(item: item,),
              ) ;
            }).toList(),
            )),
            Visibility(
              visible: productModel.getLoadMoreStaus()==LodeMoreStatus.INITIAL,
              child: Container(
                padding: EdgeInsets.all(5),
                height: 35,
                width: 35,
                child: CircularProgressIndicator(),
              ),
            )
          ],
        );
      }
      if(productModel.allProducts.isEmpty && productModel.getLoadMoreStaus()==LodeMoreStatus.STABLE){
        return Center(child: Text("No Products Found"),);
      }
      return Center(child: CircularProgressIndicator());
    });
  }
  Widget _productFilter(){
    return PopupMenuButton(
      color:lighTheme,
      onSelected: (SortBy){
    var productsProvider = Provider.of<ProductsProvider>(context,listen: false);
    productsProvider.resetStreams();
    productsProvider.setSortOrder(SortBy);
    productsProvider.fetchProducts(_page,categoryId: categoryId.toString());
      },
      itemBuilder: (BuildContext context){
        return _sortOption.map((item){
          return PopupMenuItem(value: item,child: Container(
            child: Text(item.text),
          ),);
        }).toList();
      },
      icon: Icon(Icons.sort,color: Colors.black,),
      );
  }

 void onProductItemDetails(BuildContext context , ProductModel model){
  Navigator.of(context).pushNamed('/products_details',arguments: {
    'productId':model.productId,
    'productName':model.productName
  });
  }
}