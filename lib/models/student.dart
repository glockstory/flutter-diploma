class Student {
  final String name;
  final String coachId;
  final String color;
  Student(this.name, this.coachId, this.color);

  // factory Student.fromJson(Map<String, dynamic> json) {
  //   return Student(
  //     name: json['name'],
  //     coachId: json['coachId'],
  //     color: json['color'],
  //   );
  // }
  Student.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        coachId = json['coachId'],
        color = json['color'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'coachId': coachId,
        'color': color,
      };
  // Map<String, dynamic> toJson() {
  //   return {
  //     'name': name,
  //     'coachId': coachId,
  //     'color': color,
  //   };
  // }
}
