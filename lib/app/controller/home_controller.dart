
import 'package:get/get.dart';
import 'package:politech_manager/app/controller/base_controller.dart';
import '../views/themes/themes.dart';

class HomeController extends BaseController {
  var isDarkMode = false.obs;
  var tabIndex = 0.obs;

  HomeController();

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
    if (isDarkMode.value) {
      Get.changeTheme(AppThemes.dark);
    } else {
      Get.changeTheme(AppThemes.light);
    }
    update();
  }

  void getData() {
    /*change(null, status: RxStatus.loading());
    dataRepository.getData().then((data) {
      degrees.value.clear();
      degrees.value.addAll(data.degrees);
      classrooms.value.clear();
      classrooms.value.addAll(data.classrooms);
      departments.value.clear();
      departments.value.addAll(data.departments);
      subjects.value.clear();
      subjects.value.addAll(data.subjects);
      schedule.value.clear();
      schedule.value.addAll(data.schedules);
      change(data, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });*/
  }

  /*void createDegree(DegreeModel degree) {
    change(null, status: RxStatus.loading());
    dataRepository.createDegree(degree).then((data) {
      change(data, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  void deleteDegree(int id) {
    change(null, status: RxStatus.loading());
    dataRepository.deleteDegree(id).then((data) {
      change(data, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  void updateDegree(DegreeModel degree) {
    change(null, status: RxStatus.loading());
    dataRepository.updateDegree(degree).then((data) {
      change(data, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  void createClassroom(ClassroomModel classroom) {
    change(null, status: RxStatus.loading());
    dataRepository.createClassroom(classroom).then((data) {
      change(data, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  void updateClassroom(ClassroomModel classroom) {
    change(null, status: RxStatus.loading());
    dataRepository.updateClassroom(classroom).then((data) {
      change(data, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }
  void deleteClassroom(int id) {
    change(null, status: RxStatus.loading());
    dataRepository.deleteClassroom(id).then((data) {
      change(data, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  void createDepartment(DepartmentModel department) {
    change(null, status: RxStatus.loading());
    dataRepository.createDepartment(department).then((data) {
      change(data, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  void updateDepartment(DepartmentModel department) {
    change(null, status: RxStatus.loading());
    dataRepository.updateDepartment(department).then((data) {
      change(data, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }
  void deleteDepartment(int id) {
    change(null, status: RxStatus.loading());
    dataRepository.deleteDepartment(id).then((data) {
      change(data, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  void createSubject(SubjectModel subject) {
    change(null, status: RxStatus.loading());
    dataRepository.createSubject(subject).then((data) {
      change(data, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  void updateSubject(SubjectModel subject) {
    change(null, status: RxStatus.loading());
    dataRepository.updateSubject(subject).then((data) {
      change(data, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  void deleteSubject(int id) {
    change(null, status: RxStatus.loading());
    dataRepository.deleteSubject(id).then((data) {
      change(data, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  void deleteSchedule(int id) {
    change(null, status: RxStatus.loading());
    dataRepository.deleteSchedule(id).then((data) {
      change(data, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }*/

}
