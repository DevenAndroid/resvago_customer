class RestaurantModel {
  List<String>? restaurantImage;
  List<String>? menuGalleryImages;

  double get storeLat => double.tryParse(latitude.toString()) ?? 0;
  double get storeLong => double.tryParse(longitude.toString()) ?? 0;

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
  dynamic fcm;
  dynamic image;
  dynamic preparationTime;
  dynamic averageMealForMember;
  dynamic setDelivery;
  dynamic cancellation;
  dynamic menuSelection;
  dynamic paymentEnabled;
  dynamic order_count = 0;

  RestaurantModel({
    this.restaurantImage,
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
    this.aboutUs,
    this.fcm,
    this.preparationTime,
    this.averageMealForMember,
    this.setDelivery,
    this.cancellation,
    this.menuSelection,
    this.paymentEnabled,
    this.order_count,
  });

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
    fcm = json['fcm'];
    preparationTime = json['preparationTime'];
    averageMealForMember = json['averageMealForMember'];
    setDelivery = json['setDelivery'];
    cancellation = json['cancellation'];
    menuSelection = json['menuSelection'];
    paymentEnabled = json['paymentEnabled'];
    order_count = json['order_count'] ?? 0;
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
    data['fcm'] = fcm;
    data['preparationTime'] = preparationTime;
    data['averageMealForMember'] = averageMealForMember;
    data['setDelivery'] = setDelivery;
    data['cancellation'] = cancellation;
    data['menuSelection'] = menuSelection;
    data['paymentEnabled'] = paymentEnabled;
    data['order_count'] = order_count;
    return data;
  }
}
