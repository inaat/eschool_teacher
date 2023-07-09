import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eschool_teacher/utils/constants.dart';
import 'package:eschool_teacher/utils/errorMessageKeysAndCodes.dart';
import 'package:eschool_teacher/utils/hiveBoxKeys.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ApiException implements Exception {
  String errorMessage;

  ApiException(this.errorMessage);

  @override
  String toString() {
    return errorMessage;
  }
}

class Api {
  static Map<String, dynamic> headers() {
    final String jwtToken = Hive.box(authBoxKey).get(jwtTokenKey) ?? "";
    print('token is $jwtToken');
    return {"Authorization": "Bearer $jwtToken"};
  }

  //
  //Teacher app apis
  //
  static String school=Hive.box(mainUrlBoxKey).get(mainUrl) ?? "";
  static String getSliders = "${school}sliders";
  static String login = "${school}teacher/login";
  static String forgotPassword = "${school}forgot-password";
  static String logout = "${school}logout";
  static String changePassword = "change-password";
  static String getClasses = "${school}teacher/classes";
  static String getSubjectByClassSection = "${school}teacher/subjects";

  static String getassignment = "${school}teacher/get-assignment";
  static String uploadassignment = "${school}teacher/update-assignment";
  static String deleteassignment = "${school}teacher/delete-assignment";
  static String createassignment = "${school}teacher/create-assignment";
  static String createLesson = "${school}teacher/create-lesson";
  static String getLessons = "${school}teacher/get-lesson";
  static String deleteLesson = "${school}teacher/delete-lesson";
  static String updateLesson = "${school}teacher/update-lesson";

  static String getTopics = "${school}teacher/get-topic";
  static String deleteStudyMaterial = "${school}teacher/delete-file";
  static String deleteTopic = "${school}teacher/delete-topic";
  static String updateStudyMaterial = "${school}teacher/update-file";
  static String createTopic = "${school}teacher/create-topic";
  static String updateTopic = "${school}teacher/update-topic";
  static String getAnnouncement = "${school}teacher/get-announcement";
  static String generalAnnouncements =
      "${school}teacher/general-announcements";

  static String createAnnouncement = "${school}teacher/send-announcement";
  static String deleteAnnouncement =
      "${school}teacher/delete-announcement";
  static String updateAnnouncement =
      "${school}teacher/update-announcement";
  static String getStudentsByClassSection =
      "${school}teacher/student-list";
  static String getStudentsByExamAllocation =
      "${school}teacher/student-list-by-exam-allocation";
  static String getStudentsByRoutine =
      "${school}teacher/student-list-by-routine-test";

  static String getStudentsMoreDetails =
      "${school}teacher/student-details";
  static String getAssessment = "${school}teacher/get-assessment";
  static String submitAssessment = "${school}teacher/submit-assessment";

  static String getAttendance = "${school}teacher/get-attendance";
  static String submitAttendance = "${school}teacher/submit-attendance";
  static String timeTable = "${school}teacher/teacher_timetable";
  static String examList = "${school}teacher/get-exam-list";
  static String examTimeTable = "${school}teacher/get-exam-details";
  static String examResults = "${school}teacher/exam-marks";
  static String submitExamMarksBySubjectId =
      "${school}teacher/submit-exam-marks/subject";
  static String submitExamMarksByStudentId =
      "${school}teacher/submit-exam-marks/student";
  static String getStudentResultList =
      "${school}teacher/get-student-result";
  static String submitRoutineMarksBySubjectId =
      "${school}teacher/submit-routine-marks/subject";

  static String getReviewAssignment =
      "${school}teacher/get-assignment-submission";

  static String updateReviewAssignmet =
      "${school}teacher/update-assignment-submission";

  static String settings = "${databaseUrl}settings";

  static String holidays = "${databaseUrl}holidays";
  static String getSchool =  "${databaseUrl}schools";

  //Api methods

  static Future<Map<String, dynamic>> post({
    required Map<String, dynamic> body,
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final Dio dio = Dio();
      final FormData formData =
          FormData.fromMap(body, ListFormat.multiCompatible);
      print('url is $url and query $queryParameters and $useAuthToken');
      final response = await dio.post(url,
          data: formData,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          options: useAuthToken ? Options(headers: headers()) : null);

      if (response.data['error']) {
        print(response.data);
        throw ApiException(response.data['code'].toString());
      }
      return Map.from(response.data);
    } on DioError catch (e) {
      print(e.error);
      throw ApiException(e.error is SocketException
          ? ErrorMessageKeysAndCode.noInternetCode
          : ErrorMessageKeysAndCode.defaultErrorMessageCode);
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      print(e.toString());
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }

  static Future<Map<String, dynamic>> get({
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    print('called');
    try {
      //
      final Dio dio = Dio();
      final response = await dio.get(url,
          queryParameters: queryParameters,
          options: useAuthToken ? Options(headers: headers()) : null);
      print('url is $url and query $queryParameters and $useAuthToken');
      if (response.data['error']) {
        print(response.data['error']);
        throw ApiException(response.data['code'].toString());
      }

      return Map.from(response.data);
    } on DioError catch (e) {
      print('error is ${e.response}');
      throw ApiException(e.error is SocketException
          ? ErrorMessageKeysAndCode.noInternetCode
          : ErrorMessageKeysAndCode.defaultErrorMessageCode);
    } on ApiException catch (e) {
      print(e.toString());
      throw ApiException(e.errorMessage);
    } catch (e) {
      print(e.toString());
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }

  static Future<void> download(
      {required String url,
      required CancelToken cancelToken,
      required String savePath,
      required Function updateDownloadedPercentage}) async {
    try {
      final Dio dio = Dio();
      await dio.download(url, savePath, cancelToken: cancelToken,
          onReceiveProgress: ((count, total) {
        updateDownloadedPercentage((count / total) * 100);
      }));
    } on DioError catch (e) {
      throw ApiException(e.error is SocketException
          ? ErrorMessageKeysAndCode.noInternetCode
          : ErrorMessageKeysAndCode.defaultErrorMessageCode);
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }
}
