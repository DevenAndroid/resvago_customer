class MyDiningOrderModel {
  dynamic date;
  List<MenuList>? menuList;
  dynamic orderId;
  dynamic vendorId;
  dynamic slot;
  dynamic userId;
  RestaurantInfo? restaurantInfo;
  dynamic offer;
  dynamic orderStatus;
  dynamic fcmToken;
  dynamic guest;
  dynamic time;
  dynamic total;
  dynamic orderType;
  dynamic docid;
  CustomerData? customerData;
  MyDiningOrderModel(
      {this.date,
      this.menuList,
      this.orderId,
      this.vendorId,
      this.slot,
      this.userId,
      this.restaurantInfo,
      this.offer,
      this.orderStatus,
      this.fcmToken,
      this.guest,
      this.time,
      this.total,
      this.orderType,
      this.docid,
      this.customerData});

  MyDiningOrderModel.fromJson(Map<String, dynamic> json,String docid) {
    date = json['date'];
    if (json['menuList'] != null) {
      menuList = <MenuList>[];
      json['menuList'].forEach((v) {
        menuList!.add(new MenuList.fromJson(v));
      });
    }
    orderId = json['orderId'];
    vendorId = json['vendorId'];
    slot = json['slot'];
    userId = json['userId'];
    restaurantInfo = json['restaurantInfo'] != null ? RestaurantInfo.fromJson(json['restaurantInfo']) : null;
    customerData = json['user_data'] != null ? CustomerData.fromJson(json['user_data']) : null;
    offer = json['offer'];
    orderStatus = json['order_status'];
    fcmToken = json['fcm_token'];
    guest = json['guest'];
    time = json['time'];
    orderType = json['order_type'];
    total = json['total'];
    docid = docid;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = date;
    if (menuList != null) {
      data['menuList'] = menuList!.map((v) => v.toJson()).toList();
    }
    data['orderId'] = orderId;
    data['vendorId'] = vendorId;
    data['slot'] = slot;
    data['userId'] = userId;
    if (restaurantInfo != null) {
      data['restaurantInfo'] = restaurantInfo!.toJson();
    }
    if (customerData != null) {
      data['user_data'] = customerData!.toJson();
    }
    data['offer'] = offer;
    data['order_status'] = orderStatus;
    data['fcm_token'] = fcmToken;
    data['guest'] = guest;
    data['time'] = time;
    data['order_type'] = orderType;
    return data;
  }
}

class CustomerData {
  dynamic userName;
  dynamic userId;
  dynamic docid;
  dynamic mobileNumber;
  dynamic email;


  CustomerData(
      {this.userId,
        this.userName,
        this.email,
        this.mobileNumber,
        this.docid,
      });

  CustomerData.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    docid = json['docid'];
    email = json['email'];
    mobileNumber = json['mobileNumber'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userName'] = userName;
    data['docid'] = docid;
    data['email'] = email;
    return data;
  }
}


class MenuList {
  dynamic image;
  dynamic booking;
  dynamic docid;
  dynamic vendorId;
  dynamic discount;
  dynamic description;
  dynamic bookingForDining;
  dynamic price;
  dynamic qty;
  dynamic bookingForDelivery;
  dynamic menuId;
  dynamic dishName;
  dynamic time;
  dynamic category;

  MenuList(
      {this.image,
      this.booking,
      this.docid,
      this.vendorId,
      this.discount,
      this.description,
      this.bookingForDining,
      this.price,
      this.qty,
      this.bookingForDelivery,
      this.menuId,
      this.dishName,
      this.time,
      this.category});

  MenuList.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    booking = json['booking'];
    docid = json['docid'];
    vendorId = json['vendorId'];
    discount = json['discount'];
    description = json['description'];
    bookingForDining = json['bookingForDining'];
    price = json['price'];
    qty = json['qty'];
    bookingForDelivery = json['bookingForDelivery'];
    menuId = json['menuId'];
    dishName = json['dishName'];
    time = json['time'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = image;
    data['booking'] = booking;
    data['docid'] = docid;
    data['vendorId'] = vendorId;
    data['discount'] = discount;
    data['description'] = description;
    data['bookingForDining'] = bookingForDining;
    data['price'] = price;
    data['qty'] = qty;
    data['bookingForDelivery'] = bookingForDelivery;
    data['menuId'] = menuId;
    data['dishName'] = dishName;
    data['time'] = time;
    data['category'] = category;
    return data;
  }
}

class RestaurantInfo {
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
  dynamic image;
  dynamic preparationTime;
  dynamic averageMealForMember;
  dynamic setDelivery;
  dynamic cancellation;
  dynamic menuSelection;
  dynamic order_count = 0;

  RestaurantInfo({
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
    this.preparationTime,
    this.averageMealForMember,
    this.setDelivery,
    this.cancellation,
    this.menuSelection,
    this.order_count,
  });

  RestaurantInfo.fromJson(Map<String, dynamic> json,) {
    restaurantImage = json['restaurantImage'] != null ? json['restaurantImage'].cast<String>() : [];
    menuGalleryImages = json['menuImage'] != null ? json['menuImage'].cast<String>() : [];
    password = json['password'];
    image = json['image'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    restaurantName = json['restaurantName'];
    mobileNumber = json['mobileNumber'];
    confirmPassword = json['confirmPassword'];
    category = json['category'];
    userID = json['userID'];
    email = json['email'];
    aboutUs = json['aboutUs'];
    preparationTime = json['preparationTime'];
    averageMealForMember = json['averageMealForMember'];
    setDelivery = json['setDelivery'];
    cancellation = json['cancellation'];
    menuSelection = json['menuSelection'];
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
    data['preparationTime'] = preparationTime;
    data['averageMealForMember'] = averageMealForMember;
    data['setDelivery'] = setDelivery;
    data['cancellation'] = cancellation;
    data['menuSelection'] = menuSelection;
    data['order_count'] = order_count;
    return data;
  }
}
