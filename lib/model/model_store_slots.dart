class ModelStoreSlots {
  dynamic endDateForDinner;
  dynamic noOfGuest;
  dynamic vendorId;
  dynamic dinnerDuration;
  dynamic setOffer;
  dynamic startTimeForLunch;
  dynamic lunchDuration;
  dynamic startDateForLunch;
  dynamic dateType;
  dynamic endTimeForLunch;
  dynamic endDateForLunch;
  dynamic slotId;
  dynamic time;
  dynamic endTimeForDinner;
  dynamic startDateForDinner;
  dynamic startTimeForDinner;

  ModelStoreSlots(
      {this.endDateForDinner,
        this.noOfGuest,
        this.vendorId,
        this.dinnerDuration,
        this.setOffer,
        this.startTimeForLunch,
        this.lunchDuration,
        this.startDateForLunch,
        this.dateType,
        this.endTimeForLunch,
        this.endDateForLunch,
        this.slotId,
        this.time,
        this.endTimeForDinner,
        this.startDateForDinner,
        this.startTimeForDinner});

  ModelStoreSlots.fromJson(Map<String, dynamic> json) {
    endDateForDinner = json['endDateForDinner'];
    noOfGuest = json['noOfGuest'];
    vendorId = json['vendorId'];
    dinnerDuration = json['dinnerDuration'];
    setOffer = json['setOffer'];
    startTimeForLunch = json['startTimeForLunch'];
    lunchDuration = json['lunchDuration'];
    startDateForLunch = json['startDateForLunch'];
    dateType = json['dateType'];
    endTimeForLunch = json['endTimeForLunch'];
    endDateForLunch = json['endDateForLunch'];
    slotId = json['slotId'];
    time = json['time'];
    endTimeForDinner = json['endTimeForDinner'];
    startDateForDinner = json['startDateForDinner'];
    startTimeForDinner = json['startTimeForDinner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['endDateForDinner'] = endDateForDinner;
    data['noOfGuest'] = noOfGuest;
    data['vendorId'] = vendorId;
    data['dinnerDuration'] = dinnerDuration;
    data['setOffer'] = setOffer;
    data['startTimeForLunch'] = startTimeForLunch;
    data['lunchDuration'] = lunchDuration;
    data['startDateForLunch'] = startDateForLunch;
    data['dateType'] = dateType;
    data['endTimeForLunch'] = endTimeForLunch;
    data['endDateForLunch'] = endDateForLunch;
    data['slotId'] = slotId;
    data['time'] = time;
    data['endTimeForDinner'] = endTimeForDinner;
    data['startDateForDinner'] = startDateForDinner;
    data['startTimeForDinner'] = startTimeForDinner;
    return data;
  }
}
