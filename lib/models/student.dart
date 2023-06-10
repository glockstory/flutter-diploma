class Student {
  final String id;
  final String name;
  final String coachId;
  final String color;
  Student(this.id, this.name, this.coachId, this.color);

  Student.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        coachId = json['coachId'],
        color = json['color'];

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'coachId': coachId,
        'color': color,
      };
}
