class FAQModel {
  String? question;
  String? answer;
  int? docid;
  int? time;
  bool? deactivate;

  FAQModel(
      {this.question, this.answer, this.docid, this.time, this.deactivate});

  FAQModel.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
    docid = json['docid'];
    time = json['time'];
    deactivate = json['deactivate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['answer'] = this.answer;
    data['docid'] = this.docid;
    data['time'] = this.time;
    data['deactivate'] = this.deactivate;
    return data;
  }
}
