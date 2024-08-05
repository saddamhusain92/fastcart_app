class userModel {
  String? id;
  String? userNicename;
  String? avatarImage;
  userModel(userJson, 
      {this.id, this.userNicename,this.avatarImage});
  userModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userNicename = json['name'];
    avatarImage = json['avatar_urls']['48'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.userNicename;
    data['avatar_urls']['user_display_name'] = this.avatarImage;
    return data;
  }
}