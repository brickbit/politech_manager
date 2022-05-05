
class ResponseSignInKoDto {
  String timestamp;
  String message;

  ResponseSignInKoDto({required this.timestamp, required this.message});

  factory ResponseSignInKoDto.fromJson(Map<String, dynamic> json) {
    return ResponseSignInKoDto(
      timestamp: json['timestamp'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timestamp'] = timestamp;
    data['message'] = message;
    return data;
  }

}