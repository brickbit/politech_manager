
class QueryLoginDto {
  String email;
  String password;

  QueryLoginDto({required this.email, required this.password});

  factory QueryLoginDto.fromJson(Map<String, dynamic> json) {
    return QueryLoginDto(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    return data;
  }

}