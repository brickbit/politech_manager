
class ResponseOkDto {
  String message;
  int code;

  ResponseOkDto({required this.message, required this.code});

  factory ResponseOkDto.fromJson(Map<String, dynamic> json) {
    return ResponseOkDto(
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