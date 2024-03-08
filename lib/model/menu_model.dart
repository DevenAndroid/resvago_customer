class MenuData {
  String? menuId;
  int qty = 0;
  String? vendorId;
  String? dishName;
  String? category;
  String? price;
  dynamic sellingPrice;
  dynamic docid;
  String? discount;
  String? description;
  String? image;
  dynamic booking;
  dynamic time;
  bool? bookingForDining;
  bool? bookingForDelivery;
  bool isCheck = false;

  MenuData(
      {this.menuId,
        required this.qty,
        this.vendorId,
        this.dishName,
        this.category,
        this.price,
        this.sellingPrice,
        this.docid,
        this.discount,
        this.description,
        this.image,
        this.booking,
        this.time,
        this.bookingForDining,
        this.bookingForDelivery});

  MenuData.fromJson(Map<String, dynamic> json) {
    menuId = json['menuId'];
    qty = json['qty'] ?? 0;
    vendorId = json['vendorId'];
    dishName = json['dishName'];
    category = json['category'];
    price = json['price'];
    sellingPrice = json['sellingPrice'];
    docid = json['docid'];
    discount = json['discount'];
    description = json['description'];
    image = json['image'];
    booking = json['booking'];
    time = json['time'];
    bookingForDining = json['bookingForDining'];
    bookingForDelivery = json['bookingForDelivery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menuId'] = menuId;
    data['qty'] = qty;
    data['vendorId'] = vendorId;
    data['dishName'] = dishName;
    data['category'] = category;
    data['price'] = price;
    data['sellingPrice'] = sellingPrice;
    data['docid'] = docid;
    data['discount'] = discount;
    data['description'] = description;
    data['image'] = image;
    data['booking'] = booking;
    data['time'] = time;
    data['bookingForDining'] = bookingForDining;
    data['bookingForDelivery'] = bookingForDelivery;
    return data;
  }
}
