import 'package:either_dart/either.dart';
import 'package:politech_manager/domain/error/change_password_error.dart';
import 'package:politech_manager/domain/error/delete_account_error.dart';
import 'package:politech_manager/domain/error/login_error.dart';
import 'package:politech_manager/domain/error/recover_password_error.dart';
import 'package:politech_manager/domain/error/set_new_password_error.dart';
import 'package:politech_manager/domain/error/sign_in_error.dart';
import 'package:politech_manager/domain/model/response_login_bo.dart';
import '../../domain/model/response_ok_bo.dart';
import '../../domain/repository/user_repository.dart';
import '../datasource/network_datasource.dart';

class UserRepositoryImpl extends UserRepository {
  final NetworkDataSource network;

  UserRepositoryImpl(this.network);

  @override
  Future<Either<LoginError, ResponseLoginBO>> login(
      String username, String password) async {
    final response = await network.login(username, password);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<RecoverPasswordError, ResponseOkBO>>
      recoverPassword(String email) async {
    final response = await network.recoverPassword(email);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<SetNewPasswordError, ResponseOkBO>> setNewPassword(
      String password, String token) async {
    final response = await network.resetPassword(password, token);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<SignInError, ResponseOkBO>> signIn(
      String user, String email, String password, String repeatPassword) async {
    final response =
        await network.signIn(user, email, password, repeatPassword);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  void logout() {
    network.logout();
  }

  @override
  Future<Either<DeleteAccountError, ResponseOkBO>> deleteUser() async {
    final response =
    await network.deleteUser();
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<ChangePasswordError, ResponseOkBO>> changePassword(String oldPassword, String newPassword) async {
    final response =
        await network.changePassword(oldPassword,newPassword);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }
}
