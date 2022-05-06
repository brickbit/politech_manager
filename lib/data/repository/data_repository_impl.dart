import 'package:either_dart/either.dart';
import 'package:politech_manager/domain/error/login_error.dart';
import 'package:politech_manager/domain/model/response_login_bo.dart';
import '../../domain/repository/data_repository.dart';
import '../datasource/network_datasource.dart';

class DataRepositoryImpl extends DataRepository {
  final NetworkDataSource network;

  DataRepositoryImpl(this.network);

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
}
