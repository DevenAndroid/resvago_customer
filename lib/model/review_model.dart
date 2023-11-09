class ReviewModel {
  dynamic hygieneValue;
  dynamic orderID;
  dynamic fullRating;
  dynamic about;
  dynamic vendorID;
  dynamic foodQualityValue;
  dynamic time;
  dynamic foodQuantityValue;
  dynamic userName;
  dynamic userID;
  dynamic communicationValue;

  ReviewModel(
      {this.hygieneValue,
        this.orderID,
        this.fullRating,
        this.about,
        this.vendorID,
        this.foodQualityValue,
        this.time,
        this.foodQuantityValue,
        this.userName,
        this.userID,
        this.communicationValue});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    hygieneValue = json['hygieneValue'];
    orderID = json['orderID'];
    fullRating = json['fullRating'];
    about = json['about'];
    vendorID = json['vendorID'];
    foodQualityValue = json['foodQualityValue'];
    time = json['time'];
    foodQuantityValue = json['foodQuantityValue'];
    userName = json['userName'];
    userID = json['userID'];
    communicationValue = json['communicationValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hygieneValue'] = hygieneValue;
    data['orderID'] = orderID;
    data['fullRating'] = fullRating;
    data['about'] = about;
    data['vendorID'] = vendorID;
    data['foodQualityValue'] = foodQualityValue;
    data['time'] = time;
    data['foodQuantityValue'] = foodQuantityValue;
    data['userName'] = userName;
    data['userID'] = userID;
    data['communicationValue'] = communicationValue;
    return data;
  }
}
