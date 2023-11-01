class SettingModel {
  dynamic fullRating;
  dynamic about;
  bool? foodQualityValue;
  bool? foodQuantityValue;
  bool? communicationValue;
  bool? hygieneValue;
  dynamic docid;
  dynamic time;
  dynamic userID;
  dynamic userName;

  SettingModel({
    this.fullRating,
    this.foodQualityValue,
    this.foodQuantityValue,
    this.communicationValue,
    this.docid,
    this.hygieneValue,
    this.about,
    this.time,
    this.userID,
    this.userName
  });

  Map<String, dynamic> toMap() {
    return {
      "fullRating": fullRating,
      "foodQualityValue": foodQualityValue,
      "foodQuantityValue": foodQuantityValue,
      "communicationValue": communicationValue,
      "hygieneValue": hygieneValue,
      "docid": docid,
      "about": about,
      "time": time,
      "userID": userID,
      "userName": userName,
    };
  }

  factory SettingModel.fromMap(Map<String, dynamic> map, String menuId) {
    return SettingModel(
      fullRating: map['fullRating'],
      foodQualityValue: map['foodQualityValue'],
      foodQuantityValue: map['foodQuantityValue'],
      communicationValue: map['communicationValue'],
      docid: map['docid'],
      hygieneValue: map['hygieneValue'],
      about: map['about'],
      time: map['time'],
      userID: map['userID'],
      userName: map['userName'],
    );
  }
}
