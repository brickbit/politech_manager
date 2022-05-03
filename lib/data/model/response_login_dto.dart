
class ResponseLoginDto {
  String message;
  String token;
  int code;

  ResponseLoginDto({required this.message, required this.token, required this.code});

  factory ResponseLoginDto.fromJson(Map<String, dynamic> json) {
    return ResponseLoginDto(
      message: json['message'],
      token: json['token'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['token'] = token;
    data['code'] = code;
    return data;
  }

}