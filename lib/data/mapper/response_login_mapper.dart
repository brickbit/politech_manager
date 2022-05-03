
import 'package:politech_manager/data/model/response_login_dto.dart';
import '../../domain/model/response_login_bo.dart';

extension ResponseLoginBOMapper on ResponseLoginDto {
  ResponseLoginBO toBO() {
    return ResponseLoginBO(message, token, code);
  }
}