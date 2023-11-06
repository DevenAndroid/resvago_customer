class MenuData {
  dynamic dishName;
  dynamic menuId;
  dynamic vendorId;
  dynamic category;
  dynamic price;
  dynamic docid;
  dynamic discount;
  dynamic description;
  dynamic image;
  dynamic booking;
  dynamic time;
  dynamic bookingForDining;
  dynamic bookingForDelivery;
  dynamic qty = 0;
  bool isCheck = false;

  MenuData({this.dishName, this.category, this.price, this.docid, this.discount, this.description, this.image, this.booking,this.time,this.menuId,this.vendorId,this.bookingForDelivery,this.bookingForDining,required this.qty});

  Map<String, dynamic> toMap() {
    return {
      "menuId": menuId,
      "qty":qty,
      "vendorId": vendorId,
      "dishName": dishName,
      "category": category,
      "price": price,
      "docid": docid,
      "discount": discount,
      "description": description,
      "image": image,
      "booking": booking,
      "time": time,
      "bookingForDining": bookingForDining,
      "bookingForDelivery": bookingForDelivery
    };
  }

  factory MenuData.fromMap(Map<String, dynamic> map, String menuId) {
    return MenuData(
      dishName: map['dishName'],
      qty: map['qty'] ?? 0,
      vendorId: map['vendorId'],
      menuId: menuId,
      category: map['category'],
      price: map['price'],
      discount: map['discount'],
      docid: map['docid'],
      description: map['description'],
      image: map['image'],
      booking: map['booking'],
      time: map['time'],
      bookingForDining: map['bookingForDining'],
      bookingForDelivery: map['bookingForDelivery'],
    );
  }
}
