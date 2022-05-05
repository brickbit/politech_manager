
class ResponseSetNewPasswordDto {
  String message;
  int code;

  ResponseSetNewPasswordDto({required this.message, required this.code});

  factory ResponseSetNewPasswordDto.fromJson(Map<String, dynamic> json) {
    return ResponseSetNewPasswordDto(
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