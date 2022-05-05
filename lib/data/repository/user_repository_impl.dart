
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:politech_manager/domain/error/login_error.dart';
import 'package:politech_manager/domain/error/recover_password_error.dart';
import 'package:politech_manager/domain/model/response_login_bo.dart';
import '../../domain/model/response_recover_password_bo.dart';
import '../../domain/repository/user_repository.dart';
import '../datasource/network_datasource.dart';

class UserRepositoryImpl extends UserRepository {
  final NetworkDataSource network;

  UserRepositoryImpl(this.network);

  @override
  Future<Either<LoginError,ResponseLoginBO>> login(String username, String password) async {
    final response = await network.login(username, password);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<RecoverPasswordError, ResponseRecoverPasswordBO>> recoverPassword(String email) async {
    final response = await network.recoverPassword(email);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

}