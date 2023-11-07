class MyOrderModel {
  dynamic couponDiscount;
  dynamic orderStatus;
  dynamic address;
  dynamic orderId;
  dynamic fcmToken;
  dynamic vendorId;
  dynamic time;
  dynamic userId;
  OrderDetails? orderDetails;
  dynamic orderType;

  MyOrderModel(
      {this.couponDiscount,
        this.orderStatus,
        this.address,
        this.orderId,
        this.fcmToken,
        this.vendorId,
        this.time,
        this.userId,
        this.orderDetails,
        this.orderType});

  MyOrderModel.fromJson(Map<String, dynamic> json) {
    couponDiscount = json['couponDiscount'];
    orderStatus = json['order_status'];
    address = json['address'];
    orderId = json['orderId'];
    fcmToken = json['fcm_token'];
    vendorId = json['vendorId'];
    time = json['time'];
    userId = json['userId'];
    orderDetails = json['order_details'] != null
        ? OrderDetails.fromJson(json['order_details'])
        : null;
    orderType = json['order_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['couponDiscount'] = couponDiscount;
    data['order_status'] = orderStatus;
    data['address'] = address;
    data['orderId'] = orderId;
    data['fcm_token'] = fcmToken;
    data['vendorId'] = vendorId;
    data['time'] = time;
    data['userId'] = userId;
    if (orderDetails != null) {
      data['order_details'] = orderDetails!.toJson();
    }
    data['order_type'] = orderType;
    return data;
  }
}

class OrderDetails {
  RestaurantInfo? restaurantInfo;
  List<MenuList>? menuList;
  dynamic cartId;
  dynamic vendorId;
  dynamic time;
  dynamic userId;

  OrderDetails(
      {this.restaurantInfo,
        this.menuList,
        this.cartId,
        this.vendorId,
        this.time,
        this.userId});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    restaurantInfo = json['restaurantInfo'] != null
        ? RestaurantInfo.fromJson(json['restaurantInfo'])
        : null;
    if (json['menuList'] != null) {
      menuList = <MenuList>[];
      json['menuList'].forEach((v) {
        menuList!.add(MenuList.fromJson(v));
      });
    }
    cartId = json['cartId'];
    vendorId = json['vendorId'];
    time = json['time'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (restaurantInfo != null) {
      data['restaurantInfo'] = restaurantInfo!.toJson();
    }
    if (menuList != null) {
      data['menuList'] = menuList!.map((v) => v.toJson()).toList();
    }
    data['cartId'] = cartId;
    data['vendorId'] = vendorId;
    data['time'] = time;
    data['userId'] = userId;
    return data;
  }
}

class RestaurantInfo {
  dynamic aboutUs;
  dynamic image;
  dynamic address;
  dynamic mobileNumber;
  dynamic docid;
  dynamic latitude;
  dynamic userID;
  dynamic password;
  dynamic restaurantName;
  List<String>? restaurantImage;
  dynamic confirmPassword;
  List<String>? menuImage;
  dynamic category;
  dynamic email;
  dynamic longitude;

  RestaurantInfo(
      {this.aboutUs,
        this.image,
        this.address,
        this.mobileNumber,
        this.docid,
        this.latitude,
        this.userID,
        this.password,
        this.restaurantName,
        this.restaurantImage,
        this.confirmPassword,
        this.menuImage,
        this.category,
        this.email,
        this.longitude});

  RestaurantInfo.fromJson(Map<String, dynamic> json) {
    aboutUs = json['aboutUs'];
    image = json['image'];
    address = json['address'];
    mobileNumber = json['mobileNumber'];
    docid = json['docid'];
    latitude = json['latitude'];
    userID = json['userID'];
    password = json['password'];
    restaurantName = json['restaurantName'];
    restaurantImage = json['restaurantImage'].cast<String>();
    confirmPassword = json['confirmPassword'];
    menuImage = json['menuImage'].cast<String>();
    category = json['category'];
    email = json['email'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aboutUs'] = aboutUs;
    data['image'] = image;
    data['address'] = address;
    data['mobileNumber'] = mobileNumber;
    data['docid'] = docid;
    data['latitude'] = latitude;
    data['userID'] = userID;
    data['password'] = password;
    data['restaurantName'] = restaurantName;
    data['restaurantImage'] = restaurantImage;
    data['confirmPassword'] = confirmPassword;
    data['menuImage'] = menuImage;
    data['category'] = category;
    data['email'] = email;
    data['longitude'] = longitude;
    return data;
  }
}

class MenuList {
  dynamic image;
  dynamic booking;
  dynamic docid;
  dynamic vendorId;
  dynamic description;
  dynamic discount;
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
        this.description,
        this.discount,
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
    description = json['description'];
    discount = json['discount'];
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['booking'] = booking;
    data['docid'] = docid;
    data['vendorId'] = vendorId;
    data['description'] = description;
    data['discount'] = discount;
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
