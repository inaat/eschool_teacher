import 'package:eschool_teacher/data/models/school.dart';
import 'package:eschool_teacher/data/models/topic.dart';
import 'package:eschool_teacher/data/repositories/schoolRepository.dart';
import 'package:eschool_teacher/data/repositories/topicRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SchoolsState {}

class SchoolsInitial extends SchoolsState {}

class SchoolsFetchInProgress extends SchoolsState {}

class SchoolsFetchSuccess extends SchoolsState {
  final List<School> schools;

  SchoolsFetchSuccess(this.schools);
}

class SchoolsFetchFailure extends SchoolsState {
  final String errorMessage;

  SchoolsFetchFailure(this.errorMessage);
}

class SchoolsCubit extends Cubit<SchoolsState> {
  final SchoolRepository _schoolRepository;

  SchoolsCubit(this._schoolRepository) : super(SchoolsInitial());

  void updateState(SchoolsState updatedState) {
    emit(updatedState);
  }

  void fetchSchools() async {
    emit(SchoolsFetchInProgress());
    try {
      emit(SchoolsFetchSuccess(
          await _schoolRepository.fetchSchools()));
    } catch (e) {
      emit(SchoolsFetchFailure(e.toString()));
    }
  }
 List<School> getSchools() {
    if (state is SchoolsFetchSuccess) {
      return (state as SchoolsFetchSuccess).schools;
    }
    return [];
  }
 
}
