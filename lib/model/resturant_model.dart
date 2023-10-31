class RestaurantModel {
  List<String>? restaurantImage;
  List<String>? menuGalleryImages;
  dynamic password;
  dynamic address;
  dynamic latitude;
  dynamic longitude;
  dynamic restaurantName;
  dynamic docid;
  dynamic mobileNumber;
  dynamic confirmPassword;
  dynamic category;
  dynamic userID;
  dynamic email;
  dynamic aboutUs;
  dynamic image;

  RestaurantModel(
      {this.restaurantImage,
      this.menuGalleryImages,
      this.password,
      this.image,
      this.address,
      this.latitude,
      this.longitude,
      this.restaurantName,
      this.docid,
      this.mobileNumber,
      this.confirmPassword,
      this.category,
      this.userID,
      this.email,
      this.aboutUs});

  RestaurantModel.fromJson(Map<String, dynamic> json, String docId) {
    restaurantImage = json['restaurantImage'] != null ? json['restaurantImage'].cast<String>() : [];
    menuGalleryImages = json['menuImage'] != null ? json['menuImage'].cast<String>() : [];
    password = json['password'];
    image = json['image'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    restaurantName = json['restaurantName'];
    docid = docId;
    mobileNumber = json['mobileNumber'];
    confirmPassword = json['confirmPassword'];
    category = json['category'];
    userID = json['userID'];
    email = json['email'];
    aboutUs = json['aboutUs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['restaurantImage'] = restaurantImage;
    data['menuImage'] = menuGalleryImages;
    data['password'] = password;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['restaurantName'] = restaurantName;
    data['docid'] = docid;
    data['mobileNumber'] = mobileNumber;
    data['confirmPassword'] = confirmPassword;
    data['category'] = category;
    data['userID'] = userID;
    data['email'] = email;
    data['aboutUs'] = aboutUs;
    return data;
  }
}
