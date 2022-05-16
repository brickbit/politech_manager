class QueryChangePasswordDto {
  String email;
  String oldPassword;
  String newPassword;

  QueryChangePasswordDto({required this.email, required this.oldPassword, required this.newPassword});

  factory QueryChangePasswordDto.fromJson(Map<String, dynamic> json) {
    return QueryChangePasswordDto(
      email: json['email'],
      oldPassword: json['oldPassword'],
      newPassword: json['newPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['oldPassword'] = oldPassword;
    data['newPassword'] = newPassword;
    return data;
  }

}