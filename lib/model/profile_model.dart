class ProfileData {
  dynamic userName;
  dynamic userId;
  dynamic email;
  dynamic selected_address;
  dynamic mobileNumber;
  dynamic profile_image;
  dynamic docid;
  dynamic deactivate;
  dynamic code;
  dynamic country;

  ProfileData({
    this.userName,
    this.userId,
    this.email,
    this.selected_address,
    this.mobileNumber,
    this.docid,
    this.profile_image,
    this.deactivate,
    this.code,
    this.country,
  });

  ProfileData.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    userId = json['userId'];
    email = json['email'];
    selected_address = json['selected_address'];
    mobileNumber = json['mobileNumber'];
    docid = json['docid'];
    deactivate = json['deactivate'];
    code = json['code'];
    country = json['country'];
    profile_image = json['profile_image'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['docid'] = docid;
    data['mobileNumber'] = mobileNumber;
    data['userId'] = userId;
    data['email'] = email;
    data['deactivate'] = deactivate;
    data['selected_address'] = selected_address;
    data['profile_image'] = profile_image;
    data['code'] = code;
    data['country'] = country;
    return data;
  }
}
