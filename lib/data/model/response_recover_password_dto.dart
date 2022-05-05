
class ResponseRecoverPasswordDto {
  String message;
  int code;

  ResponseRecoverPasswordDto({required this.message, required this.code});

  factory ResponseRecoverPasswordDto.fromJson(Map<String, dynamic> json) {
    return ResponseRecoverPasswordDto(
      message: json['message'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['code'] = code;
    return data;
  }

}