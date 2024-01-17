class MyOrderModel {
  dynamic couponDiscount;
  dynamic orderStatus;
  dynamic address;
  dynamic orderId;
  dynamic fcmToken;
  dynamic vendorId;
  dynamic time;
  dynamic userId;
  dynamic total;
  dynamic admin_commission;
  dynamic docid;
  dynamic reasonOfCancel;
  OrderDetails? orderDetails;
  dynamic orderType;
  CustomerData? customerData;

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
      this.total,
      this.admin_commission,
      this.customerData,
      this.docid,
      this.reasonOfCancel,
      this.orderType});

  MyOrderModel.fromJson(Map<String, dynamic> json,docid1) {
    couponDiscount = json['couponDiscount'];
    orderStatus = json['order_status'];
    address = json['address'];
    orderId = json['orderId'];
    fcmToken = json['fcm_token'];
    vendorId = json['vendorId'];
    time = json['time'];
    userId = json['userId'];
    total = json['total'];
    admin_commission = json['admin_commission'];
    orderDetails = json['order_details'] != null ? OrderDetails.fromJson(json['order_details']) : null;
    customerData = json['user_data'] != null ? CustomerData.fromJson(json['user_data']) : null;
    orderType = json['order_type'];
    reasonOfCancel = json['reasonOfCancel'];
    docid = docid1;
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
    data['total'] = total;
    data['admin_commission'] = admin_commission;
    data['reasonOfCancel'] = reasonOfCancel;
    if (orderDetails != null) {
      data['order_details'] = orderDetails!.toJson();
    }
    if (customerData != null) {
      data['user_data'] = customerData!.toJson();
    }
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

class OrderDetails {
  RestaurantInfo? restaurantInfo;
  List<MenuList>? menuList;
  dynamic cartId;
  dynamic vendorId;
  dynamic time;
  dynamic userId;

  OrderDetails({this.restaurantInfo, this.menuList, this.cartId, this.vendorId, this.time, this.userId});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    restaurantInfo = json['restaurantInfo'] != null ? RestaurantInfo.fromJson(json['restaurantInfo']) : null;
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

class MenuList {
  dynamic image;
  dynamic booking;
  dynamic docid;
  dynamic vendorId;
  dynamic description;
  dynamic discount;
  dynamic bookingForDining;
  dynamic price;
  dynamic sellingPrice;
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
      this.sellingPrice,
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
    sellingPrice = json['sellingPrice'];
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
    data['sellingPrice'] = sellingPrice;
    data['qty'] = qty;
    data['bookingForDelivery'] = bookingForDelivery;
    data['menuId'] = menuId;
    data['dishName'] = dishName;
    data['time'] = time;
    data['category'] = category;
    return data;
  }
}
