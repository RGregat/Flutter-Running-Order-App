import './band.dart';

class Days {
  String day;
  List<Band> timeTable;

  Days({this.day, this.timeTable});

  factory Days.fromJson(Map<String, dynamic> json) {
    var list = json['timeTable'] as List;
    List<Band> timeTable = list.map((i) => Band.fromJson(i)).toList();
    
    return Days(
        day: json["day"],
        timeTable: timeTable);
  }
}