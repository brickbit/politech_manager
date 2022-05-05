
import 'package:get/get.dart';
import 'package:politech_manager/app/error/error_manager_impl.dart';
import 'package:politech_manager/data/datasource/network_datasource.dart';
import 'package:politech_manager/data/datasource/network_datasource_impl.dart';
import 'package:politech_manager/domain/error/error_manager.dart';
import '../../../data/repository/user_repository_impl.dart';
import '../../../domain/repository/user_repository.dart';
import 'package:http/http.dart' as http;
import '../controller/sign_in_controller.dart';

class SignInBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<NetworkDataSource>(() => NetworkDataSourceImpl(http.Client()));
    Get.lazyPut<UserRepository>(() => UserRepositoryImpl(Get.find()));
    Get.lazyPut<ErrorManager>(() => ErrorManagerImpl());
    Get.lazyPut(() => SignInController(userRepository: Get.find(), errorManager: Get.find()));
  }

}