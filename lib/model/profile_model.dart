class ProfileData {
  dynamic userName;
  dynamic userId;
  dynamic email;
  dynamic mobileNumber;
  dynamic profile_image;
  dynamic docid;

  ProfileData(
      {
        this.userName,
        this.userId,
        this.email,
        this.mobileNumber,
        this.docid,
        this.profile_image,
       });

  ProfileData.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    userId = json['userId'];
    email = json['email'];
    mobileNumber = json['mobileNumber'];
    docid = json['docid'];
    profile_image = json['profile_image'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['docid'] = docid;
    data['mobileNumber'] = mobileNumber;
    data['userId'] = userId;
    data['email'] = email;
    data['profile_image'] = profile_image;
    return data;
  }
}
