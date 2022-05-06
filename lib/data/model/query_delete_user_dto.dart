
class QueryDeleteUserDto {
  String email;

  QueryDeleteUserDto({required this.email});

  factory QueryDeleteUserDto.fromJson(Map<String, dynamic> json) {
    return QueryDeleteUserDto(
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    return data;
  }

}