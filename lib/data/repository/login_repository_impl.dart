
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:politech_manager/domain/error/login_error.dart';
import 'package:politech_manager/domain/model/response_login_bo.dart';
import '../../domain/repository/login_repository.dart';
import '../datasource/network_datasource.dart';

class LoginRepositoryImpl extends LoginRepository {
  final NetworkDataSource network;

  LoginRepositoryImpl(this.network);

  @override
  Future<Either<LoginError,ResponseLoginBO>> login(String username, String password) async {
    log("Repository initialized");
    final response = await network.login();
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

}