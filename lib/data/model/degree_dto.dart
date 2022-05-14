
class DegreeDto {
  String name;
  int numSemesters;
  String year;
  int id;

  DegreeDto({required this.name, required this.numSemesters, required this.year, required this.id});

  factory DegreeDto.fromJson(Map<String, dynamic> json) {
    return DegreeDto(
      name: json['name'],
      numSemesters: json['num_semesters'],
      year: json['year'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['num_semesters'] = numSemesters;
    data['year'] = year;
    data['id'] = id;
    return data;
  }
}