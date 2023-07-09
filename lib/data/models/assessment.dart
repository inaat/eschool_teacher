
class Assessment {
  int? id;
  String? title;
  String? subTitle;
  bool? isAverage, isGood, isPoor;

  Assessment(
      {this.id,
      this.title,
      this.subTitle,
      this.isAverage,
      this.isGood,
      this.isPoor});

  Assessment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subTitle = json['subTitle'];
    isAverage = json['isAverage'];
    isGood = json['isGood'];
    isPoor = json['isPoor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['subTitle'] = subTitle;
    data['isAverage'] = isAverage;
    data['isGood'] = isGood;
    data['isPoor'] = isPoor;
    return data;
  }
}
