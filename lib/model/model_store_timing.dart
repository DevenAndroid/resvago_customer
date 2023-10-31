class ModelStoreTime {
  List<Schedule>? schedule;

  ModelStoreTime({this.schedule});

  ModelStoreTime.fromJson(Map<String, dynamic> json) {
    if (json['schedule'] != null) {
      schedule = <Schedule>[];
      json['schedule'].forEach((v) {
        schedule!.add(Schedule.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (schedule != null) {
      data['schedule'] = schedule!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Schedule {
  String? startTime;
  String? endTime;
  String? day;
  bool? status;

  Schedule({this.startTime, this.endTime, this.day, this.status});

  Schedule.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
    day = json['day'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['day'] = day;
    data['status'] = status;
    return data;
  }
}
