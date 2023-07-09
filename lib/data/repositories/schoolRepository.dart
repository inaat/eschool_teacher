import 'package:eschool_teacher/data/models/holiday.dart';
import 'package:eschool_teacher/data/models/school.dart';
import 'package:eschool_teacher/data/models/sliderDetails.dart';
import 'package:eschool_teacher/utils/api.dart';

class SchoolRepository {
   Future<List<School>> fetchSchools() async {
    try {
      final result = await Api.get(url: Api.getSchool, useAuthToken: false);
     
           return (result['data'] as List)
          .map((school) => School.fromJson(Map.from(school)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
