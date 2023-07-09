import 'package:eschool_teacher/data/models/student.dart';
import 'package:eschool_teacher/data/models/studentByExam.dart';
import 'package:eschool_teacher/data/models/studentByRoutine.dart';
import 'package:eschool_teacher/data/repositories/studentRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class RoutineState {}

class RoutineInitial extends RoutineState {}

class RoutineFetchInProgress
    extends RoutineState {}

class RoutineFetchSuccess extends RoutineState {
  final List<StudentByRoutine> students;

  RoutineFetchSuccess({required this.students});
}

class RoutineFetchFailure extends RoutineState {
  final String errorMessage;

  RoutineFetchFailure(this.errorMessage);
}

class RoutineCubit extends Cubit<RoutineState> {
  final StudentRepository _studentRepository;

  RoutineCubit(this._studentRepository)
      : super(RoutineInitial());

  void updateState(RoutineState updatedState) {
    emit(updatedState);
  }

  void fetchStudents({required int classSectionId, required int subjectId}) async {
    emit(RoutineFetchInProgress());
    try {
      emit(
        RoutineFetchSuccess(
          students: (await _studentRepository.getStudentsByRoutineResult(
              classSectionId: classSectionId,
              subjectId:subjectId)),
        ),
      );
    } catch (e) {
      emit(RoutineFetchFailure(e.toString()));
    }
  }

  List<Object> getStudents() {
    return (state is RoutineFetchSuccess)
        ? (state as RoutineFetchSuccess).students
        : [];
  }
}
