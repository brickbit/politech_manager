class ClassroomDto {
  String name;
  String pavilion;
  String acronym;
  int id;

  ClassroomDto(
      {required this.name,
      required this.pavilion,
      required this.acronym,
      required this.id});

  factory ClassroomDto.fromJson(Map<String, dynamic> json) {
    return ClassroomDto(
      name: json['name'],
      pavilion: json['pavilion'],
      acronym: json['acronym'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['pavilion'] = pavilion;
    data['acronym'] = acronym;
    data['id'] = id;
    return data;
  }
}
