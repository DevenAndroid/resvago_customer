class ProfileData {
  dynamic userName;
  dynamic userId;
  dynamic email;
  dynamic selected_address;
  dynamic mobileNumber;
  dynamic profile_image;
  dynamic docid;
  dynamic deactivate;

  ProfileData(
      {
        this.userName,
        this.userId,
        this.email,
        this.selected_address,
        this.mobileNumber,
        this.docid,
        this.profile_image,
        this.deactivate,
       });

  ProfileData.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    userId = json['userId'];
    email = json['email'];
    selected_address = json['selected_address'];
    mobileNumber = json['mobileNumber'];
    docid = json['docid'];
    deactivate = json['deactivate'];
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
    return data;
  }
}
