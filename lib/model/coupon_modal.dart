class CouponData {
  final dynamic promoCodeName;
  final dynamic code;
  final dynamic discount;
  final dynamic startDate;
  final dynamic endDate;
  final dynamic maxDiscount;
  final dynamic docid;
  final dynamic userID;
  final bool deactivate;

  double get maximumDiscount => (double.tryParse(discount.toString()) ?? 0) / 100;
  double get maximumDiscountAmount => double.tryParse(maxDiscount.toString()) ?? 0;


  CouponData(
      {required this.promoCodeName,
        this.code,
        this.discount,
        this.startDate,
        this.maxDiscount,
        required this.deactivate,
        this.endDate,
        this.userID,
        this.docid});

  Map<String, dynamic> toMap() {
    return {
      'promoCodeName': promoCodeName,
      'code': code,
      'discount': discount,
      'startDate': startDate,
      'endDate': endDate,
      'maxDiscount': maxDiscount,
      'docid': docid,
      'userID': userID,
      'deactivate': deactivate,
    };
  }

  factory CouponData.fromMap(Map<String, dynamic> map) {
    return CouponData(
      promoCodeName: map['promoCodeName'],
      deactivate: map['deactivate'],
      code: map['code'],
      discount: map['discount'],
      maxDiscount: map['maxDiscount'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      docid: map['docid'],
      userID: map['userID'],
    );
  }
}
