
import 'package:get/get.dart';
import 'package:politech_manager/app/error/error_manager_impl.dart';
import 'package:politech_manager/data/datasource/network_datasource.dart';
import 'package:politech_manager/data/datasource/network_datasource_impl.dart';
import 'package:politech_manager/domain/error/error_manager.dart';
import '../../../data/repository/login_repository_impl.dart';
import '../../../domain/repository/login_repository.dart';
import '../controller/login_controller.dart';
import 'package:http/http.dart' as http;


class LoginBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<NetworkDataSource>(() => NetworkDataSourceImpl(http.Client()));
    Get.lazyPut<LoginRepository>(() => LoginRepositoryImpl(Get.find()));
    Get.lazyPut<ErrorManager>(() => ErrorManagerImpl());
    Get.lazyPut(() => LoginController(loginRepository: Get.find(), errorManager: Get.find()));
  }

}