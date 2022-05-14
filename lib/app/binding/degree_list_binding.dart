
import 'package:get/get.dart';
import 'package:politech_manager/app/controller/data_controller.dart';
import 'package:politech_manager/app/error/error_manager_impl.dart';
import 'package:politech_manager/data/datasource/network_datasource.dart';
import 'package:politech_manager/data/datasource/network_datasource_impl.dart';
import 'package:politech_manager/domain/error/error_manager.dart';
import 'package:politech_manager/domain/repository/data_repository.dart';
import 'package:http/http.dart' as http;
import '../../data/repository/data_repository_impl.dart';
import '../controller/degree_list_controller.dart';

class DegreeListBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<NetworkDataSource>(() => NetworkDataSourceImpl(http.Client()));
    Get.lazyPut<DataRepository>(() => DataRepositoryImpl(Get.find()));
    Get.lazyPut<ErrorManager>(() => ErrorManagerImpl());
    Get.lazyPut(() => DegreeListController(dataRepository: Get.find(), errorManager: Get.find()));
  }

}