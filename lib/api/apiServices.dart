import 'dart:convert';
import 'dart:developer';
import 'package:fastcart/models/user.dart';
import 'package:fastcart/pages/products/products_details.dart';
import 'package:http/http.dart' as http;
import 'package:fastcart/consts/config.dart';
import 'package:fastcart/models/category.dart';
import 'package:fastcart/models/products.dart';


class APIServices {


 // Get a list of categories from the API
 // Returns a Future that resolves to a list of CategoryModel objects or null if the request fails
 
  static var client = http.Client();
  static Future<List<CategoryModel>?> getCategories () async{
    Map<String,String> requestHeader = {
      "Content-Type": "application/json",
      //  "Authorization": 'Bearer ${base64Encode(utf8.encode('${Config.consumer_key}:${Config.consumer_secret}'))}'
      };
    Map<String,dynamic> queryString = {
      "consumer_key":Config.consumer_key,
      "consumer_secret":Config.consumer_secret,
      "parent":"0",
      '_fields[]':['id','name','image.src'],
      'per_page':"50",
      'page':"1"
    };
    var uri = Uri.https(Config.apiurl,Config.apiEndPoint+Config.productscategories,queryString);
 
    var response = await client.get(uri,headers: requestHeader);
    if(response.statusCode ==200){
      var data = jsonDecode(response.body);

      return categoriesFromJson(data);
    }
    else{
      return null;
    }
  } 


 

 // Get a list of products from the API
 static Future<List<ProductModel>?> getProducts ({
    int? pageNumber,
    int? pageSize,
    String? strSearch,
    String? categoryId,
    String? sortBy,
    List<int>?productIds,
    String? sortOrder = "asc"
    }) async{


    Map<String,String> requestHeader = {
      "Content-Type": "application/json",
      };


    Map<String,dynamic> queryString = {
      "consumer_key":Config.consumer_key,
      "consumer_secret":Config.consumer_secret,
      '_fields[]':['id','name','price','regular_price','sale_price','description','images'],
      'per_page':"50",
      'page':"1",
    };

    if(strSearch!=null){
      queryString['search']=strSearch;
    }
    if(pageSize!=null){
      queryString['per_page']=pageSize.toString();
    }

    if(pageNumber!=null){
      queryString['page']=pageNumber.toString();
    }
    if(categoryId!=null){
      if(strSearch==""||strSearch==null){
        queryString['category']=categoryId;
      }
    }
if(sortBy!=null){
      queryString['orderby']=sortBy;
    }
    queryString['order']=sortOrder;

  if(productIds!=null){
    queryString['include']=productIds.join(",").toString();
  }

    var uri = Uri.https(Config.apiurl,Config.apiEndPoint+Config.productsURL,queryString);
    var response = await client.get(uri,headers: requestHeader);
    if(response.statusCode ==200){
      var data = jsonDecode(response.body);
      return ProductsFromJson(data);
    }
    else{
      return null;
    }
  } 

  // // Get a list of products details from the API
 static Future<ProductModel?> getProductDetails(productIds) async{
   
    Map<String,String> requestHeader = {
      "Content-Type": "application/json"
      };

    Map<String,dynamic> queryString = {
      "consumer_key":Config.consumer_key,
      "consumer_secret":Config.consumer_secret,
      '_fields[]':[
        'id',
        'name',
        'price',
        'regular_price',
        'sale_price'
        ,'description',
        'images',
        'cross_sell_ids'
        ],
      
    };
    var uri = Uri.https(Config.apiurl,"${Config.apiEndPoint+Config.productsURL}/$productIds",queryString);
      //  log(uri.toString());

    var response = await client.get(uri,headers: requestHeader);
    if(response.statusCode ==200){
      var data = jsonDecode(response.body);
      return ProductModel.fromJson(data);
    }
    else{
      return null; 
    }
  } 
 



}