
import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:http/http.dart';
import 'package:politech_manager/data/mapper/response_login_mapper.dart';
import 'package:politech_manager/domain/error/login_error.dart';
import 'package:politech_manager/domain/error/login_error_type.dart';
import 'package:politech_manager/domain/model/response_login_bo.dart';
import '../model/response_login_dto.dart';
import 'network_datasource.dart';

class NetworkDataSourceImpl extends NetworkDataSource {

  String endpoint = "https://politech-manager.herokuapp.com/";

  final Client client;

  final headers = {
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  NetworkDataSourceImpl(this.client);

  @override
  Future<Either<LoginError,ResponseLoginBO>> login() async {
    log('DataSource initialized');
    final response = await client.post(Uri.parse(endpoint + "user/login"), headers: headers, body:{
      'email': 'robe@unex.es',
      'password': 'C__1992'
    });
    if (response == null || response.statusCode != 200) {
      return Left(LoginError(errorType: LoginErrorType.wrongUser));
    } else {
      final dto = ResponseLoginDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    }
  }
}