List<ProductModel> ProductsFromJson(dynamic str)=>
List<ProductModel>.from((str).map((x)=>ProductModel.fromJson(x)));
class ProductModel{
  int? productId;
  String? productName;
  String? description;
  String? price;
  String? regularPrice;
  String? salePrice;
  List<ImageModel>? image;
  List<int>? relatedId;

  ProductModel({
    this.productId,
    this.productName,
    this.description,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.image,
    this.relatedId
  });
   ProductModel.fromJson(Map<String,dynamic>json){
    productId=json['id'];
    productName=json['name'];
    description=json['description'].toString().replaceAll(RegExp(r'</?p>|[^A-Za-z0-9\s]'), '');
    price=json['price'];
    regularPrice=json['regular_price'];
    salePrice=json['sale_price'];
    if(json['images']!=null){
      image=List<ImageModel>.from(json['images'].map((e)=>ImageModel.fromJson(e)));
    }
    if(json['cross_sell_ids']!=null){
      relatedId=json['cross_sell_ids'].cast<int>();
    }
}
}

class ImageModel {
  String? url;

ImageModel({this.url});

ImageModel.fromJson(Map<String,dynamic>json){
  url = json['src'];
}

}