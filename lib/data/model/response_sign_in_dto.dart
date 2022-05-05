
class ResponseSignInDto {
  String message;
  int code;

  ResponseSignInDto({required this.message, required this.code});

  factory ResponseSignInDto.fromJson(Map<String, dynamic> json) {
    return ResponseSignInDto(
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