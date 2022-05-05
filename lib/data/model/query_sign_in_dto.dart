
class QuerySignInDto {
  String user;
  String email;
  String password;
  String repeatPassword;

  QuerySignInDto({
    required this.user,
    required this.email,
    required this.password,
    required this.repeatPassword,
  });

  factory QuerySignInDto.fromJson(Map<String, dynamic> json) {
    return QuerySignInDto(
      user: json['user'],
      email: json['email'],
      password: json['password'],
      repeatPassword: json['repeatPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['email'] = email;
    data['password'] = password;
    data['repeatPassword'] = repeatPassword;
    return data;
  }

}