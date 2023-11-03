class SettingModel {
  dynamic setDelivery;
  dynamic cancellation;
  dynamic averageMealForMember;
  dynamic preparationTime;
  dynamic menuSelection;
  dynamic userID;

  SettingModel(
      {this.setDelivery,
        this.cancellation,
        this.averageMealForMember,
        this.preparationTime,
        this.menuSelection,
        this.userID});

  SettingModel.fromJson(Map<String, dynamic> json) {
    setDelivery = json['setDelivery'];
    cancellation = json['cancellation'];
    averageMealForMember = json['averageMealForMember'];
    preparationTime = json['preparationTime'];
    menuSelection = json['menuSelection'];
    userID = json['userID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['setDelivery'] = setDelivery;
    data['cancellation'] = cancellation;
    data['averageMealForMember'] = averageMealForMember;
    data['preparationTime'] = preparationTime;
    data['menuSelection'] = menuSelection;
    data['userID'] = userID;
    return data;
  }
}
