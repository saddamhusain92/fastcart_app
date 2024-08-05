
import 'package:flutter/material.dart';
import 'package:fastcart/api/apiServices.dart';
import 'package:fastcart/models/products.dart';
class SortBy {
  String value, text,sortOrder;
  SortBy(this.value,this.text,this.sortOrder);
}
 
 enum LodeMoreStatus {
    INITIAL,LOADING,STABLE
 }
 
class ProductsProvider with ChangeNotifier{
List<ProductModel> _productsList = [];
SortBy _sortBy = SortBy('popularity','popularity','asc');
int totalPage = 0,pageSize=10;
LodeMoreStatus _lodeMoreStatus = LodeMoreStatus.STABLE;
String _strSearch = "",_categoryId = "";
List<ProductModel> get  allProducts  => _productsList;
double get totalProducts => _productsList.length.toDouble();
LodeMoreStatus getLoadMoreStaus() =>_lodeMoreStatus;
String get strSearch => _strSearch;
String get categoryId => _categoryId;

ProductsProvider(){
resetStreams();
_sortBy = SortBy('popularity','popularity','asc');


}

void resetStreams(){
  _productsList.clear();
  setLoadMoreState(LodeMoreStatus.INITIAL);
}

setLoadMoreState(LodeMoreStatus lodeMoreStatus){
  _lodeMoreStatus = lodeMoreStatus;
  notifyListeners();
}

fetchProducts(
  pageNumber,{
  String ? strSearch,
  String ? categoryId,
  String ? sortBy,
  String ? sortOrder = 'asc',

  }) async{

    setLoadMoreState(LodeMoreStatus.LOADING);
    List<ProductModel>? itemModel = await APIServices.getProducts(
    pageNumber: pageNumber,
    strSearch: _strSearch,
    pageSize: pageSize,
    categoryId: _categoryId,
    sortBy: _sortBy.value,
    sortOrder: _sortBy.sortOrder
    );

  
    if(itemModel!.isNotEmpty) _productsList.addAll(itemModel);
   
    setLoadMoreState(LodeMoreStatus.STABLE);
    notifyListeners();
  }
setSortOrder(SortBy sortBy){
  _sortBy = sortBy;
  resetStreams();

}
setSearchStr(val){
  _strSearch = val;
  resetStreams();
  fetchProducts(1);

}
setProductCategory(val){
  _categoryId = val.toString();
  _strSearch = "";
  resetStreams();
  fetchProducts(1);

}


}


