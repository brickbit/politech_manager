
class QueryRecoverPasswordDto {
  String email;

  QueryRecoverPasswordDto({required this.email});

  factory QueryRecoverPasswordDto.fromJson(Map<String, dynamic> json) {
    return QueryRecoverPasswordDto(
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    return data;
  }

}