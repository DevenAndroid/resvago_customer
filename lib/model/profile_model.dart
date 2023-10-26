class ProfileData {
  dynamic userName;
  dynamic userId;
  dynamic email;
  dynamic mobileNumber;
  dynamic docid;

  ProfileData(
      {
        this.userName,
        this.userId,
        this.email,
        this.mobileNumber,
        this.docid,
       });

  ProfileData.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    userId = json['userId'];
    email = json['email'];
    mobileNumber = json['mobileNumber'];
    docid = json['docid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['docid'] = docid;
    data['mobileNumber'] = mobileNumber;
    data['userId'] = userId;
    data['email'] = email;
    return data;
  }
}
