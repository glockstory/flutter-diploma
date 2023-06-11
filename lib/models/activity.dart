class Activity {
  final String? id;
  final String name;
  final String pictogram;
  final String date;
  final String start;
  final String end;
  final String coachId;
  final int repeatType;
  final List students;

  const Activity(this.id, this.name, this.pictogram, this.date, this.start,
      this.end, this.coachId, this.repeatType, this.students);

  Activity.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        pictogram = json['pictogram'],
        date = json['date'],
        start = json['start'],
        end = json['end'],
        coachId = json['coachId'],
        repeatType = json['repeatType'],
        students = json['students'];

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'pictogram': pictogram,
        'date': date,
        'start': start,
        'end': end,
        'coachId': coachId,
        'repeatType': repeatType,
        'students': students,
      };
}
