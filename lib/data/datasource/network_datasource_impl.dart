import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart';
import 'package:politech_manager/data/mapper/user_mapper.dart';
import 'package:politech_manager/data/model/query_login_dto.dart';
import 'package:politech_manager/domain/error/login_error.dart';
import 'package:politech_manager/domain/error/login_error_type.dart';
import 'package:politech_manager/domain/error/recover_password_error.dart';
import 'package:politech_manager/domain/error/set_new_password_error.dart';
import 'package:politech_manager/domain/model/response_login_bo.dart';
import 'package:politech_manager/domain/model/response_recover_password_bo.dart';
import '../../domain/error/recover_password_error_type.dart';
import '../../domain/error/set_new_password_error_type.dart';
import '../../domain/model/response_set_new_password_bo.dart';
import '../model/query_recover_password_dto.dart';
import '../model/response_login_dto.dart';
import '../model/response_recover_password_dto.dart';
import '../model/response_set_new_password_dto.dart';
import 'network_datasource.dart';

class NetworkDataSourceImpl extends NetworkDataSource {
  String endpoint = "https://politech-manager.herokuapp.com/";

  final Client client;

  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};

  NetworkDataSourceImpl(this.client);

  @override
  Future<Either<LoginError, ResponseLoginBO>> login(
      String username, String password) async {
    final query = QueryLoginDto(email: username, password: password).toJson();
    final response = await client.post(Uri.parse(endpoint + "user/login"),
        headers: headers, body: query);
    if (response.statusCode != 200) {
      return Left(LoginError(errorType: LoginErrorType.wrongUser));
    } else {
      final dto = ResponseLoginDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    }
  }

  @override
  Future<Either<RecoverPasswordError, ResponseRecoverPasswordBO>> recoverPassword(String email) async {
    final query = QueryRecoverPasswordDto(email: email).toJson();
    final response = await client.post(Uri.parse(endpoint + "user/forgot-password"),
        headers: headers, body: query);
    if (response.statusCode != 200) {
      return Left(RecoverPasswordError(errorType: RecoverPasswordErrorType.wrongUser));
    } else {
      final dto = ResponseRecoverPasswordDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    }
  }

  @override
  Future<Either<SetNewPasswordError, ResponseSetNewPasswordBO>> resetPassword(String password, String token) async {
    final url = "$token&password=$password";
    final response = await client.put(Uri.parse(url));
    if (response.statusCode != 200) {
      return Left(SetNewPasswordError(errorType: SetNewPasswordErrorType.wrongUser));
    } else {
      final dto = ResponseSetNewPasswordDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    }
  }
}
