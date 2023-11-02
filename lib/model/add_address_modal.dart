class AddressModel {
  dynamic name;
  dynamic streetAddress;
  dynamic flatAddress;
  dynamic AddressType;
  dynamic docid;
  dynamic time;
  dynamic userID;


  AddressModel({
    this.name,
    this.streetAddress,
    this.flatAddress,
    this.docid,
    this.AddressType,
    this.time,
    this.userID,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "streetAddress": streetAddress,
      "flatAddress": flatAddress,
      "AddressType": AddressType,
      "docid": docid,
      "time": time,
      "userID": userID,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map, String menuId) {
    return AddressModel(
      name: map['name'],
      streetAddress: map['streetAddress'],
      flatAddress: map['flatAddress'],
      docid: map['docid'],
      AddressType: map['AddressType'],
      time: map['time'],
      userID: map['userID'],
    );
  }
}
