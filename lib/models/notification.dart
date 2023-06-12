class Notifications {
  String name;
  String date;
  String activityId;
  String timeStart;
  String timeEnd;

  Notifications(
      this.name, this.date, this.activityId, this.timeStart, this.timeEnd);

  Notifications.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        date = json['date'],
        activityId = json['activityId'],
        timeStart = json['start'],
        timeEnd = json['end'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date,
        'activityId': activityId,
        'start': timeStart,
        'end': timeEnd
      };
}
