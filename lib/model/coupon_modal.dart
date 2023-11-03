class CouponData {
  final dynamic promoCodeName;
  final dynamic code;
  final dynamic discount;
  final dynamic startDate;
  final dynamic endDate;
  final dynamic maxDiscount;
  final dynamic? docid;
  final bool deactivate;


  CouponData(
      {required this.promoCodeName,
        this.code,
        this.discount,
        this.startDate,
        this.maxDiscount,
        required this.deactivate,
        this.endDate,
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
    );
  }
}
