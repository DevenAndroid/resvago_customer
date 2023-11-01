import 'dart:convert';

class CreateSlotData {
  int? createdTime;
  int? slotDate;
  String? noOfGuest;
  Map<String, int>? morningSlots;
  String? vendorId;
  DateTime? slotId;
  Map<String, int>? eveningSlots;
  String? setOffer;

  CreateSlotData({
    this.createdTime,
    this.slotDate,
    this.noOfGuest,
    this.morningSlots,
    this.vendorId,
    this.slotId,
    this.eveningSlots,
    this.setOffer,
  });

  factory CreateSlotData.fromJson(String str) => CreateSlotData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CreateSlotData.fromMap(Map<String, dynamic> json) => CreateSlotData(
    createdTime: json["created_time"],
    slotDate: json["slot_date"],
    noOfGuest: json["noOfGuest"],
    morningSlots: Map.from(json["morning_slots"]!).map((k, v) => MapEntry<String, int>(k, v)),
    vendorId: json["vendorId"],
    slotId: json["slotId"] == null ? null : DateTime.parse(json["slotId"]),
    eveningSlots: Map.from(json["evening_slots"]!).map((k, v) => MapEntry<String, int>(k, v)),
    setOffer: json["setOffer"],
  );

  Map<String, dynamic> toMap() => {
    "created_time": createdTime,
    "slot_date": slotDate,
    "noOfGuest": noOfGuest,
    "morning_slots": Map.from(morningSlots!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "vendorId": vendorId,
    "slotId": slotId?.toIso8601String(),
    "evening_slots": Map.from(eveningSlots!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "setOffer": setOffer,
  };
}
