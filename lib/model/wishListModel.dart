class WishListModel {
  dynamic wishlistId;
  dynamic userId;
  dynamic vendorId;
  dynamic time;

  WishListModel({
    this.wishlistId,
    this.userId,
    this.vendorId,
    this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      "wishlistId": wishlistId,
      "userId":userId,
      "vendorId":vendorId,
      "time":time
    };
  }

  factory WishListModel.fromMap(Map<String, dynamic> map,String wishlistId) {
    return WishListModel(
      wishlistId: wishlistId,
      userId: map['userId'],
      vendorId: map['vendorId'],
      time: map['time'],
    );
  }
}
