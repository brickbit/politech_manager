import 'dart:convert';
import 'dart:typed_data';
import 'package:either_dart/either.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:politech_manager/data/mapper/data_mapper.dart';
import 'package:politech_manager/data/mapper/user_mapper.dart';
import 'package:politech_manager/data/model/query_change_password_dto.dart';
import 'package:politech_manager/data/model/query_delete_user_dto.dart';
import 'package:politech_manager/data/model/query_login_dto.dart';
import 'package:politech_manager/data/model/response_sign_in_ko_dto.dart';
import 'package:politech_manager/domain/error/calendar_error.dart';
import 'package:politech_manager/domain/error/change_password_error.dart';
import 'package:politech_manager/domain/error/classroom_error.dart';
import 'package:politech_manager/domain/error/classroom_error_type.dart';
import 'package:politech_manager/domain/error/degree_error.dart';
import 'package:politech_manager/domain/error/delete_account_error.dart';
import 'package:politech_manager/domain/error/delete_account_error_type.dart';
import 'package:politech_manager/domain/error/department_error.dart';
import 'package:politech_manager/domain/error/department_error_type.dart';
import 'package:politech_manager/domain/error/exam_error.dart';
import 'package:politech_manager/domain/error/exam_error_type.dart';
import 'package:politech_manager/domain/error/login_error.dart';
import 'package:politech_manager/domain/error/login_error_type.dart';
import 'package:politech_manager/domain/error/recover_password_error.dart';
import 'package:politech_manager/domain/error/schedule_error.dart';
import 'package:politech_manager/domain/error/schedule_error_type.dart';
import 'package:politech_manager/domain/error/set_new_password_error.dart';
import 'package:politech_manager/domain/error/sign_in_error.dart';
import 'package:politech_manager/domain/error/sign_in_error_type.dart';
import 'package:politech_manager/domain/error/subject_error.dart';
import 'package:politech_manager/domain/error/subject_error_type.dart';
import 'package:politech_manager/domain/model/calendar_bo.dart';
import 'package:politech_manager/domain/model/classroom_bo.dart';
import 'package:politech_manager/domain/model/degree_bo.dart';
import 'package:politech_manager/domain/model/department_bo.dart';
import 'package:politech_manager/domain/model/exam_bo.dart';
import 'package:politech_manager/domain/model/response_login_bo.dart';
import 'package:politech_manager/domain/model/response_ok_bo.dart';
import 'package:politech_manager/domain/model/schedule_bo.dart';
import 'package:politech_manager/domain/model/subject_bo.dart';
import '../../domain/error/calendar_error_type.dart';
import '../../domain/error/change_password_error_type.dart';
import '../../domain/error/degree_error_type.dart';
import '../../domain/error/recover_password_error_type.dart';
import '../../domain/error/set_new_password_error_type.dart';
import '../../domain/error/teacher_error.dart';
import '../../domain/error/teacher_error_type.dart';
import '../../domain/model/teacher_bo.dart';
import '../model/calendar_dto.dart';
import '../model/classroom_dto.dart';
import '../model/degree_dto.dart';
import '../model/department_dto.dart';
import '../model/exam_dto.dart';
import '../model/query_recover_password_dto.dart';
import '../model/query_sign_in_dto.dart';
import '../model/response_login_dto.dart';
import '../model/response_ok_dto.dart';
import '../model/schedule_dto.dart';
import '../model/subject_dto.dart';
import '../model/teacher_dto.dart';
import 'network_datasource.dart';

class NetworkDataSourceImpl extends NetworkDataSource {
  String endpoint = "https://politech-manager.herokuapp.com/";

  String token = '';

  String user = '';

  String password = '';

  final Client client;

  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};

  final authHeaders = {
    'Authorization': '',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  final authJsonHeaders = {
    'Authorization': '',
    'Content-Type': 'application/json'
  };

  NetworkDataSourceImpl(this.client);

  @override
  Future<Either<LoginError, ResponseLoginBO>> updateToken() async {
    final query = QueryLoginDto(email: user, password: password).toJson();
    final response = await client.post(Uri.parse("${endpoint}user/login"),
        headers: headers, body: query);
    if (response.statusCode != 200) {
      return Left(LoginError(errorType: LoginErrorType.wrongUser));
    } else {
      final dto = ResponseLoginDto.fromJson(jsonDecode(response.body));
      token = dto.token;
      authHeaders['Authorization'] = token;
      authJsonHeaders['Authorization'] = token;
      return Right(dto.toBO());
    }
  }

  @override
  Future<Either<LoginError, ResponseLoginBO>> login(
      String username, String password) async {
    user = username;
    this.password = password;
    final query = QueryLoginDto(email: username, password: password).toJson();
    final response = await client.post(Uri.parse("${endpoint}user/login"),
        headers: headers, body: query);
    if (response.statusCode != 200) {
      return Left(LoginError(errorType: LoginErrorType.wrongUser));
    } else {
      final dto = ResponseLoginDto.fromJson(jsonDecode(response.body));
      token = dto.token;
      authHeaders['Authorization'] = token;
      authJsonHeaders['Authorization'] = token;
      return Right(dto.toBO());
    }
  }

  @override
  Future<Either<RecoverPasswordError, ResponseOkBO>> recoverPassword(
      String email) async {
    final query = QueryRecoverPasswordDto(email: email).toJson();
    final response = await client.post(
        Uri.parse("${endpoint}user/forgot-password"),
        headers: headers,
        body: query);
    if (response.statusCode != 200) {
      return Left(
          RecoverPasswordError(errorType: RecoverPasswordErrorType.wrongUser));
    } else {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    }
  }

  @override
  Future<Either<SetNewPasswordError, ResponseOkBO>> resetPassword(
      String password, String token) async {
    final url = "$token&password=$password";
    final response = await client.put(Uri.parse(url));
    if (response.statusCode != 200) {
      return Left(
          SetNewPasswordError(errorType: SetNewPasswordErrorType.wrongUser));
    } else {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    }
  }

  @override
  Future<Either<SignInError, ResponseOkBO>> signIn(
      String user, String email, String password, String repeatPassword) async {
    final query = QuerySignInDto(
            user: user,
            email: email,
            password: password,
            repeatPassword: repeatPassword)
        .toJson();
    final response = await client.post(Uri.parse("${endpoint}user/register"),
        headers: headers, body: query);
    if (response.statusCode != 200) {
      final responseKo =
          ResponseSignInKoDto.fromJson(jsonDecode(response.body));
      switch (responseKo.message) {
        case 'WRONG_USER':
          return Left(SignInError(errorType: SignInErrorType.wrongUser));
        case 'PASSWORD_NOT_MATCH':
          return Left(SignInError(errorType: SignInErrorType.passwordNotMatch));
        case 'INCORRECT_PASSWORD':
          return Left(
              SignInError(errorType: SignInErrorType.incorrectPassword));
        case 'UNKNOWN_ERROR':
          return Left(SignInError(errorType: SignInErrorType.unknownError));
        default:
          return Left(SignInError(errorType: SignInErrorType.unknownError));
      }
    } else {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    }
  }

  @override
  void logout() {
    token = '';
    authHeaders['Authorization'] = '';
    authJsonHeaders['Authorization'] = '';
    user = '';
  }

  @override
  Future<Either<DeleteAccountError, ResponseOkBO>> deleteUser() async {
    final query = QueryDeleteUserDto(email: user).toJson();
    final response = await client.post(Uri.parse("${endpoint}delete"),
        headers: authHeaders, body: query);
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      user = '';
      token = '';
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(
          DeleteAccountError(errorType: DeleteAccountErrorType.expiredToken));
    } else {
      return Left(
          DeleteAccountError(errorType: DeleteAccountErrorType.wrongUser));
    }
  }

  @override
  Future<Either<ClassroomError, List<ClassroomBO>>> getClassrooms() async {
    final response = await client.get(Uri.parse("${endpoint}classroom"),
        headers: authJsonHeaders);
    if (response.statusCode == 200) {
      final List list = json.decode(utf8.decode(response.bodyBytes));
      final List<ClassroomDto> classroomList =
      list.map((item) => ClassroomDto.fromJson(item)).toList();
      final dto = classroomList.map((item) => item.toBO()).toList();
      return Right(dto);
    } else if (response.statusCode == 403) {
      return Left(ClassroomError(errorType: ClassroomErrorType.expiredToken));
    } else {
      return Left(ClassroomError(errorType: ClassroomErrorType.wrongUser));
    }
  }

  @override
  Future<Either<DegreeError, List<DegreeBO>>> getDegrees() async {
    final response = await client.get(Uri.parse("${endpoint}degree"),
        headers: authJsonHeaders);
    if (response.statusCode == 200) {
      final List list = json.decode(utf8.decode(response.bodyBytes));
      final List<DegreeDto> degreeList =
      list.map((item) => DegreeDto.fromJson(item)).toList();
      final dto = degreeList.map((item) => item.toBO()).toList();
      return Right(dto);
    } else if (response.statusCode == 403) {
      return Left(DegreeError(errorType: DegreeErrorType.expiredToken));
    } else {
      return Left(DegreeError(errorType: DegreeErrorType.wrongUser));
    }
  }

  @override
  Future<Either<DepartmentError, List<DepartmentBO>>> getDepartments() async {
    final response = await client.get(Uri.parse("${endpoint}department"),
        headers: authJsonHeaders);
    if (response.statusCode == 200) {
      final List list = json.decode(utf8.decode(response.bodyBytes));
      final List<DepartmentDto> departmentList =
      list.map((item) => DepartmentDto.fromJson(item)).toList();
      final dto = departmentList.map((item) => item.toBO()).toList();
      return Right(dto);
    } else if (response.statusCode == 403) {
      return Left(DepartmentError(errorType: DepartmentErrorType.expiredToken));
    } else {
      return Left(DepartmentError(errorType: DepartmentErrorType.wrongUser));
    }
  }

  @override
  Future<Either<TeacherError, List<TeacherBO>>> getTeachers() async {
    final response = await client.get(Uri.parse("${endpoint}teacher"),
        headers: authJsonHeaders);
    if (response.statusCode == 200) {
      final List list = json.decode(utf8.decode(response.bodyBytes));
      final List<TeacherDto> teacherList =
      list.map((item) => TeacherDto.fromJson(item)).toList();
      final dto = teacherList.map((item) => item.toBO()).toList();
      return Right(dto);
    } else if (response.statusCode == 403) {
      return Left(TeacherError(errorType: TeacherErrorType.expiredToken));
    } else {
      return Left(TeacherError(errorType: TeacherErrorType.wrongUser));
    }
  }

  @override
  Future<Either<ExamError, List<ExamBO>>> getExams() async {
    final response = await client.get(Uri.parse("${endpoint}exam"),
        headers: authJsonHeaders);
    if (response.statusCode == 200) {
      final List list = json.decode(utf8.decode(response.bodyBytes));
      final List<ExamDto> examList =
      list.map((item) => ExamDto.fromJson(item)).toList();
      final dto = examList.map((item) => item.toBO()).toList();
      return Right(dto);
    } else if (response.statusCode == 403) {
      return Left(ExamError(errorType: ExamErrorType.expiredToken));
    } else {
      return Left(ExamError(errorType: ExamErrorType.wrongUser));
    }
  }

  @override
  Future<Either<SubjectError, List<SubjectBO>>> getSubjects() async {
    final response = await client.get(Uri.parse("${endpoint}subject"),
        headers: authJsonHeaders);
    if (response.statusCode == 200) {
      final List list = json.decode(utf8.decode(response.bodyBytes));
      final List<SubjectDto> subjectList =
      list.map((item) => SubjectDto.fromJson(item)).toList();
      final dto = subjectList.map((item) => item.toBO()).toList();
      return Right(dto);
    } else if (response.statusCode == 403) {
      return Left(SubjectError(errorType: SubjectErrorType.expiredToken));
    } else {
      return Left(SubjectError(errorType: SubjectErrorType.wrongUser));
    }
  }

  @override
  Future<Either<ScheduleError, List<ScheduleBO>>> getSchedules() async {
    final response = await client.get(Uri.parse("${endpoint}schedule"),
        headers: authJsonHeaders);
    if (response.statusCode == 200) {
      final List list = json.decode(utf8.decode(response.bodyBytes));
      final List<ScheduleDto> scheduleList =
      list.map((item) => ScheduleDto.fromJson(item)).toList();
      return Right(scheduleList.map((e) => e.toBO()).toList());
    } else if (response.statusCode == 403) {
      return Left(ScheduleError(errorType: ScheduleErrorType.expiredToken));
    } else {
      return Left(ScheduleError(errorType: ScheduleErrorType.wrongUser));
    }
  }

  @override
  Future<Either<CalendarError, List<CalendarBO>>> getCalendars() async {
    final response = await client.get(Uri.parse("${endpoint}calendar"),
        headers: authJsonHeaders);
    if (response.statusCode == 200) {
      final List list = json.decode(utf8.decode(response.bodyBytes));
      final List<CalendarDto> calendarList =
      list.map((item) => CalendarDto.fromJson(item)).toList();
      final dto = calendarList.map((item) => item.toBO()).toList();
      return Right(dto);
    } else if (response.statusCode == 403) {
      return Left(CalendarError(errorType: CalendarErrorType.expiredToken));
    } else {
      return Left(CalendarError(errorType: CalendarErrorType.wrongUser));
    }
  }

  @override
  Future<Either<ClassroomError, ResponseOkBO>> postClassroom(
      ClassroomBO classroom) async {
    final classroomJson = classroom.toDto().toJson();
    final response = await client.post(Uri.parse("${endpoint}classroom"),
        headers: authJsonHeaders, body: json.encode(classroomJson));
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(ClassroomError(errorType: ClassroomErrorType.expiredToken));
    } else {
      return Left(ClassroomError(errorType: ClassroomErrorType.wrongUser));
    }
  }

  @override
  Future<Either<DegreeError, ResponseOkBO>> postDegree(DegreeBO degree) async {
    final degreeJson = degree.toDto().toJson();
    final response = await client.post(Uri.parse("${endpoint}degree"),
        headers: authJsonHeaders, body: json.encode(degreeJson));
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(DegreeError(errorType: DegreeErrorType.expiredToken));
    } else {
      return Left(DegreeError(errorType: DegreeErrorType.wrongUser));
    }
  }

  @override
  Future<Either<DepartmentError, ResponseOkBO>> postDepartment(
      DepartmentBO department) async {
    final departmentJson = department.toDto().toJson();
    final response = await client.post(Uri.parse("${endpoint}department"),
        headers: authJsonHeaders, body: json.encode(departmentJson));
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(DepartmentError(errorType: DepartmentErrorType.expiredToken));
    } else {
      return Left(DepartmentError(errorType: DepartmentErrorType.wrongUser));
    }
  }

  @override
  Future<Either<TeacherError, ResponseOkBO>> postTeacher(
      TeacherBO teacher) async {
    final teacherJson = teacher.toDto().toJson();
    final response = await client.post(Uri.parse("${endpoint}teacher"),
        headers: authJsonHeaders, body: json.encode(teacherJson));
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(TeacherError(errorType: TeacherErrorType.expiredToken));
    } else {
      return Left(TeacherError(errorType: TeacherErrorType.wrongUser));
    }
  }

  @override
  Future<Either<ExamError, ResponseOkBO>> postExam(ExamBO exam) async {
    final examDto = exam.toDto();
    final response = await client.post(Uri.parse("${endpoint}exam"),
        headers: authJsonHeaders, body: json.encode(examDto.toJson()));
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(ExamError(errorType: ExamErrorType.expiredToken));
    } else {
      return Left(ExamError(errorType: ExamErrorType.wrongUser));
    }
  }

  @override
  Future<Either<SubjectError, ResponseOkBO>> postSubject(
      SubjectBO subject) async {
    final subjectJson = subject.toDto().toJson();
    final response = await client.post(Uri.parse("${endpoint}subject"),
        headers: authJsonHeaders, body: json.encode(subjectJson));
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(SubjectError(errorType: SubjectErrorType.expiredToken));
    } else {
      return Left(SubjectError(errorType: SubjectErrorType.wrongUser));
    }
  }

  @override
  Future<Either<ClassroomError, ResponseOkBO>> updateClassroom(
      ClassroomBO classroom) async {
    final classroomJson = classroom.toDto().toJson();
    final response = await client.post(Uri.parse("${endpoint}classroom/update"),
        headers: authJsonHeaders, body: json.encode(classroomJson));
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(ClassroomError(errorType: ClassroomErrorType.wrongUser));
    } else {
      return Left(ClassroomError(errorType: ClassroomErrorType.wrongUser));
    }
  }

  @override
  Future<Either<DegreeError, ResponseOkBO>> updateDegree(
      DegreeBO degree) async {
    final degreeJson = degree.toDto().toJson();
    final response = await client.post(Uri.parse("${endpoint}degree/update"),
        headers: authJsonHeaders, body: json.encode(degreeJson));
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(DegreeError(errorType: DegreeErrorType.expiredToken));
    } else {
      return Left(DegreeError(errorType: DegreeErrorType.wrongUser));
    }
  }

  @override
  Future<Either<DepartmentError, ResponseOkBO>> updateDepartment(
      DepartmentBO department) async {
    final departmentJson = department.toDto().toJson();
    final response = await client.post(
        Uri.parse("${endpoint}department/update"),
        headers: authJsonHeaders,
        body: json.encode(departmentJson));
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(DepartmentError(errorType: DepartmentErrorType.expiredToken));
    } else {
      return Left(DepartmentError(errorType: DepartmentErrorType.wrongUser));
    }
  }

  @override
  Future<Either<TeacherError, ResponseOkBO>> updateTeacher(
      TeacherBO teacher) async {
    final teacherJson = teacher.toDto().toJson();
    final response = await client.post(
        Uri.parse("${endpoint}teacher/update"),
        headers: authJsonHeaders,
        body: json.encode(teacherJson));
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(TeacherError(errorType: TeacherErrorType.expiredToken));
    } else {
      return Left(TeacherError(errorType: TeacherErrorType.wrongUser));
    }
  }

  @override
  Future<Either<ExamError, ResponseOkBO>> updateExam(ExamBO exam) async {
    final examDto = exam.toDto();
    final response = await client.post(Uri.parse("${endpoint}exam/update"),
        headers: authJsonHeaders, body: json.encode(examDto.toJson()));
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(ExamError(errorType: ExamErrorType.expiredToken));
    } else {
      return Left(ExamError(errorType: ExamErrorType.wrongUser));
    }
  }

  @override
  Future<Either<SubjectError, ResponseOkBO>> updateSubject(
      SubjectBO subject) async {
    final subjectJson = subject.toDto().toJson();
    final response = await client.post(Uri.parse("${endpoint}subject/update"),
        headers: authJsonHeaders, body: json.encode(subjectJson));
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(SubjectError(errorType: SubjectErrorType.expiredToken));
    } else {
      return Left(SubjectError(errorType: SubjectErrorType.wrongUser));
    }
  }

  @override
  Future<Either<ClassroomError, ResponseOkBO>> deleteClassroom(int id) async {
    final response = await client.post(
        Uri.parse("${endpoint}classroom/delete/$id"),
        headers: authJsonHeaders);
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(ClassroomError(errorType: ClassroomErrorType.expiredToken));
    } else {
      return Left(ClassroomError(errorType: ClassroomErrorType.wrongUser));
    }
  }

  @override
  Future<Either<DegreeError, ResponseOkBO>> deleteDegree(int id) async {
    final response = await client.post(
        Uri.parse("${endpoint}degree/delete/$id"),
        headers: authJsonHeaders);
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(DegreeError(errorType: DegreeErrorType.expiredToken));
    } else {
      return Left(DegreeError(errorType: DegreeErrorType.wrongUser));
    }
  }

  @override
  Future<Either<DepartmentError, ResponseOkBO>> deleteDepartment(int id) async {
    final response = await client.post(
        Uri.parse("${endpoint}department/delete/$id"),
        headers: authJsonHeaders);
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(DepartmentError(errorType: DepartmentErrorType.expiredToken));
    } else {
      return Left(DepartmentError(errorType: DepartmentErrorType.wrongUser));
    }
  }

  @override
  Future<Either<TeacherError, ResponseOkBO>> deleteTeacher(int id) async {
    final response = await client.post(
        Uri.parse("${endpoint}teacher/delete/$id"),
        headers: authJsonHeaders);
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(TeacherError(errorType: TeacherErrorType.expiredToken));
    } else {
      return Left(TeacherError(errorType: TeacherErrorType.wrongUser));
    }
  }

  @override
  Future<Either<ExamError, ResponseOkBO>> deleteExam(int id) async {
    final response = await client.post(Uri.parse("${endpoint}exam/delete/$id"),
        headers: authJsonHeaders);
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(ExamError(errorType: ExamErrorType.expiredToken));
    } else {
      return Left(ExamError(errorType: ExamErrorType.wrongUser));
    }
  }

  @override
  Future<Either<SubjectError, ResponseOkBO>> deleteSubject(int id) async {
    final response = await client.post(
        Uri.parse("${endpoint}subject/delete/$id"),
        headers: authJsonHeaders);
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(SubjectError(errorType: SubjectErrorType.expiredToken));
    } else {
      return Left(SubjectError(errorType: SubjectErrorType.wrongUser));
    }
  }

  @override
  Future<Either<ScheduleError, ResponseOkBO>> deleteSchedule(int id) async {
    final response = await client.post(
        Uri.parse("${endpoint}schedule/delete/$id"),
        headers: authJsonHeaders);
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(ScheduleError(errorType: ScheduleErrorType.expiredToken));
    } else {
      return Left(ScheduleError(errorType: ScheduleErrorType.wrongUser));
    }
  }

  @override
  Future<Either<CalendarError, ResponseOkBO>> deleteCalendar(int id) async {
    final response = await client.post(
        Uri.parse("${endpoint}calendar/delete/$id"),
        headers: authJsonHeaders);
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(CalendarError(errorType: CalendarErrorType.expiredToken));
    } else {
      return Left(CalendarError(errorType: CalendarErrorType.wrongUser));
    }
  }

  @override
  Future<Either<ChangePasswordError, ResponseOkBO>> changePassword(
      String oldPassword, String newPassword) async {
    var query = QueryChangePasswordDto(
            email: user, oldPassword: oldPassword, newPassword: newPassword)
        .toJson();
    final response = await client.post(Uri.parse("${endpoint}update"),
        headers: authHeaders, body: query);
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(
          ChangePasswordError(errorType: ChangePasswordErrorType.expiredToken));
    } else {
      return Left(
          ChangePasswordError(errorType: ChangePasswordErrorType.wrongUser));
    }
  }

  @override
  Future<Either<ScheduleError, ResponseOkBO>> postSchedule(ScheduleBO schedule) async {
    final scheduleJson = schedule.toDto().toJson();
    final response = await client.post(Uri.parse("${endpoint}schedule"),
        headers: authJsonHeaders, body: json.encode(scheduleJson));
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(ScheduleError(errorType: ScheduleErrorType.expiredToken));
    } else {
      return Left(ScheduleError(errorType: ScheduleErrorType.wrongUser));
    }
  }

  @override
  Future<Either<CalendarError, ResponseOkBO>> postCalendar(CalendarBO calendar) async {
    final calendarJson = calendar.toDto().toJson();
    final response = await client.post(Uri.parse("${endpoint}calendar"),
        headers: authJsonHeaders, body: json.encode(calendarJson));
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(CalendarError(errorType: CalendarErrorType.expiredToken));
    } else {
      return Left(CalendarError(errorType: CalendarErrorType.wrongUser));
    }
  }

  @override
  Future<Either<ScheduleError, ResponseOkBO>> updateSchedule(ScheduleBO schedule) async {
    final scheduleJson = schedule.toDto().toJson();
    final response = await client.post(Uri.parse("${endpoint}schedule/update"),
        headers: authJsonHeaders, body: json.encode(scheduleJson));
    if (response.statusCode == 200) {
      final dto = ResponseOkDto.fromJson(jsonDecode(response.body));
      return Right(dto.toBO());
    } else if (response.statusCode == 403) {
      return Left(ScheduleError(errorType: ScheduleErrorType.expiredToken));
    } else {
      return Left(ScheduleError(errorType: ScheduleErrorType.wrongUser));
    }
  }

  @override
  Future<Either<ScheduleError, Uint8List>> downloadSchedule(ScheduleBO schedule) async {
    var request = http.Request('GET', Uri.parse("${endpoint}schedule/download"));
    final dto = schedule.toDto();
    final body = json.encode(dto.toJson());
    request.body = body;
    request.headers.addAll(authJsonHeaders);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      http.ByteStream stream = response.stream;
      var bytes = await stream.toBytes();
      return Right(bytes);
    } else if (response.statusCode == 403) {
      return Left(ScheduleError(errorType: ScheduleErrorType.expiredToken));
    } else {
      return Left(ScheduleError(errorType: ScheduleErrorType.wrongUser));
    }
  }

  @override
  Future<Either<CalendarError, Uint8List>> downloadCalendar(CalendarBO calendar) async{
    var request = http.Request('GET', Uri.parse("${endpoint}calendar/download"));
    final calendarJson = calendar.toDto().toJson();
    request.body = json.encode(calendarJson);
    request.headers.addAll(authJsonHeaders);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      http.ByteStream stream = response.stream;
      var bytes = await stream.toBytes();
      return Right(bytes);
    } else if (response.statusCode == 403) {
      return Left(CalendarError(errorType: CalendarErrorType.expiredToken));
    } else {
      return Left(CalendarError(errorType: CalendarErrorType.wrongUser));
    }
  }
}
