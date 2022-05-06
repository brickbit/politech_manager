
import '../../domain/repository/data_repository.dart';
import '../datasource/network_datasource.dart';

class DataRepositoryImpl extends DataRepository {
  final NetworkDataSource network;

  DataRepositoryImpl(this.network);

}
