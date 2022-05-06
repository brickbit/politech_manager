
import 'package:politech_manager/data/model/response_login_dto.dart';
import '../../domain/model/response_login_bo.dart';
import '../../domain/model/response_ok_bo.dart';
import '../model/response_ok_dto.dart';

extension ResponseLoginBOMapper on ResponseLoginDto {
  ResponseLoginBO toBO() {
    return ResponseLoginBO(message, token, code);
  }
}

extension ResponseOkMapper on ResponseOkDto {
  ResponseOkBO toBO() {
    return ResponseOkBO(message, code);
  }
}
