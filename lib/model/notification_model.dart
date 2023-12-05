class NotificationData {
  final dynamic? docid;
  final dynamic body;
  final dynamic date;
  final dynamic title;
  final dynamic userId;

  NotificationData(
      {
        this.docid,
        this.body,
        this.date,
        required this.title,
        required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'docid': docid,
      'body': body,
      'date': date,
      'title': title,
      'userId': userId,
    };
  }

  factory NotificationData.fromMap(Map<String, dynamic> map) {
    return NotificationData(
      title: map['title'],
      body: map['body'],
      date: map['date'],
      docid: map['docid'],
      userId: map['userId'],
    );
  }
}
