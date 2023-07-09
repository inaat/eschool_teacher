//database urls
//Please add your admin panel url here and make sure you do not add '/' at the end of the url
import 'package:eschool_teacher/utils/labelKeys.dart';

import 'package:hive/hive.dart';

import 'hiveBoxKeys.dart';

const String baseUrl = "http://192.168.100.70/esms/public";

const String databaseUrl = "$baseUrl/api/";
//Change slider duration
const Duration changeSliderDuration = Duration(seconds: 5);

//error message display duration
const Duration errorMessageDisplayDuration = Duration(milliseconds: 3000);
//Number of latest notices to show in home container
const int numberOfLatestNotciesInHomeScreen = 3;
String getExamStatusTypeKey(String examStatus) {
  if (examStatus == "0") {
    return upComingKey;
  }
  if (examStatus == "1") {
    return onGoingKey;
  }
  return completedKey;
}

List<String> examFilters = [allExamsKey, upComingKey, onGoingKey, completedKey];
