class RegisterData {
  final dynamic userName;
  final dynamic userId;
  final dynamic email;
  final dynamic mobileNumber;
  final dynamic docid;

  RegisterData({required this.userName, this.email, this.userId, this.mobileNumber, this.docid});

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'email': email,
      'userId': userId,
      'mobileNumber': mobileNumber,
      'docid': docid,
    };
  }

  factory RegisterData.fromMap(Map<String, dynamic> map) {
    return RegisterData(
      userName: map['userName'],
      email: map['email'],
      userId: map['userId'],
      mobileNumber: map['mobileNumber'],
      docid: map['docid'],
    );
  }
}
