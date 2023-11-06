class MyOrderModel {
  RestaurantInfo? restaurantInfo;
  dynamic orderStatus;
  dynamic couponDiscount;
  dynamic address;
  dynamic orderId;
  dynamic fcmToken;
  dynamic vendorId;
  dynamic time;
  dynamic userId;
  dynamic orderType;

  MyOrderModel(
      {this.restaurantInfo,
        this.orderStatus,
        this.couponDiscount,
        this.address,
        this.orderId,
        this.fcmToken,
        this.vendorId,
        this.time,
        this.userId,
        this.orderType});

  MyOrderModel.fromJson(Map<String, dynamic> json) {
    restaurantInfo = json['restaurantInfo'] != null
        ? RestaurantInfo.fromJson(json['restaurantInfo'])
        : null;
    orderStatus = json['order_status'];
    couponDiscount = json['couponDiscount'];
    address = json['address'];
    orderId = json['orderId'];
    fcmToken = json['fcm_token'];
    vendorId = json['vendorId'];
    time = json['time'];
    userId = json['userId'];
    orderType = json['order_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (restaurantInfo != null) {
      data['restaurantInfo'] = restaurantInfo!.toJson();
    }
    data['order_status'] = orderStatus;
    data['couponDiscount'] = couponDiscount;
    data['address'] = address;
    data['orderId'] = orderId;
    data['fcm_token'] = fcmToken;
    data['vendorId'] = vendorId;
    data['time'] = time;
    data['userId'] = userId;
    data['order_type'] = orderType;
    return data;
  }
}

class RestaurantInfo {
  RestaurantInfo? restaurantInfo;
  List<MenuList>? menuList;
  dynamic cartId;
  dynamic vendorId;
  dynamic time;
  dynamic userId;

  RestaurantInfo(
      {this.restaurantInfo,
        this.menuList,
        this.cartId,
        this.vendorId,
        this.time,
        this.userId});

  RestaurantInfo.fromJson(Map<String, dynamic> json) {
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


class MenuList {
  dynamic image;
  dynamic booking;
  dynamic docid;
  dynamic discount;
  dynamic vendorId;
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
        this.discount,
        this.vendorId,
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
    discount = json['discount'];
    vendorId = json['vendorId'];
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['booking'] = booking;
    data['docid'] = docid;
    data['discount'] = discount;
    data['vendorId'] = vendorId;
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
