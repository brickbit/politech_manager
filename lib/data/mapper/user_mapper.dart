
import 'package:politech_manager/data/model/response_login_dto.dart';
import '../../domain/model/response_login_bo.dart';
import '../../domain/model/response_recover_password_bo.dart';
import '../model/response_recover_password_dto.dart';

extension ResponseLoginBOMapper on ResponseLoginDto {
  ResponseLoginBO toBO() {
    return ResponseLoginBO(message, token, code);
  }
}

extension ResponseRecoverPasswordBOMapper on ResponseRecoverPasswordDto {
  ResponseRecoverPasswordBO toBO() {
    return ResponseRecoverPasswordBO(message, code);
  }
}