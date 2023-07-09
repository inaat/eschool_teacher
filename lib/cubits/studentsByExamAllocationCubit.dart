import 'package:eschool_teacher/data/models/student.dart';
import 'package:eschool_teacher/data/models/studentByExam.dart';
import 'package:eschool_teacher/data/repositories/studentRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class StudentsByExamAllocationState {}

class StudentsByExamAllocationInitial extends StudentsByExamAllocationState {}

class StudentsByExamAllocationFetchInProgress
    extends StudentsByExamAllocationState {}

class StudentsByExamAllocationFetchSuccess extends StudentsByExamAllocationState {
  final List<StudentByExam> students;

  StudentsByExamAllocationFetchSuccess({required this.students});
}

class StudentsByExamAllocationFetchFailure extends StudentsByExamAllocationState {
  final String errorMessage;

  StudentsByExamAllocationFetchFailure(this.errorMessage);
}

class StudentsByExamAllocationCubit extends Cubit<StudentsByExamAllocationState> {
  final StudentRepository _studentRepository;

  StudentsByExamAllocationCubit(this._studentRepository)
      : super(StudentsByExamAllocationInitial());

  void updateState(StudentsByExamAllocationState updatedState) {
    emit(updatedState);
  }

  void fetchStudents({required int examId,required int classSectionId, required subjectId}) async {
    emit(StudentsByExamAllocationFetchInProgress());
    try {
      emit(
        StudentsByExamAllocationFetchSuccess(
          students: (await _studentRepository.getStudentsByExamAllocation(
              examId:examId,
              classSectionId: classSectionId,
              subjectId:subjectId)),
        ),
      );
    } catch (e) {
      emit(StudentsByExamAllocationFetchFailure(e.toString()));
    }
  }

  List<Object> getStudents() {
    return (state is StudentsByExamAllocationFetchSuccess)
        ? (state as StudentsByExamAllocationFetchSuccess).students
        : [];
  }
}
