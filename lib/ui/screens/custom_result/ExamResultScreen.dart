import 'package:eschool_teacher/cubits/examCubit.dart';
import 'package:eschool_teacher/cubits/myClassesCubit.dart';
import 'package:eschool_teacher/cubits/studentsByExamAllocationCubit.dart';
import 'package:eschool_teacher/cubits/subjectsOfClassSectionCubit.dart';
import 'package:eschool_teacher/cubits/submitSubjectMarksBySubjectIdCubit.dart';
import 'package:eschool_teacher/data/models/classSectionDetails.dart';
import 'package:eschool_teacher/data/models/studentByExam.dart';
import 'package:eschool_teacher/data/models/subject.dart';
import 'package:eschool_teacher/data/repositories/studentRepository.dart';
import 'package:eschool_teacher/data/repositories/teacherRepository.dart';
import 'package:eschool_teacher/ui/screens/custom_result/widget/addCustomMarksContainer.dart';
import 'package:eschool_teacher/ui/widgets/classSubjectsDropDownMenu.dart';
import 'package:eschool_teacher/ui/widgets/customAppbar.dart';
import 'package:eschool_teacher/ui/widgets/customCircularProgressIndicator.dart';
import 'package:eschool_teacher/ui/widgets/customDropDownMenu.dart';
import 'package:eschool_teacher/ui/widgets/customRefreshIndicator.dart';
import 'package:eschool_teacher/ui/widgets/customRoundedButton.dart';
import 'package:eschool_teacher/ui/widgets/customShimmerContainer.dart';
import 'package:eschool_teacher/ui/widgets/defaultDropDownLabelContainer.dart';
import 'package:eschool_teacher/ui/widgets/errorContainer.dart';
import 'package:eschool_teacher/ui/widgets/myClassesDropDownMenu.dart';
import 'package:eschool_teacher/ui/widgets/noDataContainer.dart';
import 'package:eschool_teacher/ui/widgets/shimmerLoadingContainer.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamResultScreen extends StatefulWidget {
  final ClassSectionDetails? classSectionDetails;
  final Subject? subject;

  const ExamResultScreen({Key? key, this.classSectionDetails, this.subject})
      : super(key: key);
  static Route<dynamic> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<ExamDetailsCubit>(
                  create: (context) => ExamDetailsCubit(StudentRepository()),
                ),
                BlocProvider(
                  create: (context) =>
                      StudentsByExamAllocationCubit(StudentRepository()),
                ),
                BlocProvider(
                  create: (context) =>
                      SubjectsOfClassSectionCubit(TeacherRepository()),
                ),
                BlocProvider(
                  create: (context) => SubjectMarksBySubjectIdCubit(
                      studentRepository: StudentRepository()),
                ),
              ],
              child: const ExamResultScreen(),
            ));
  }

  @override
  State<ExamResultScreen> createState() => _ExamResultScreenState();
}

class _ExamResultScreenState extends State<ExamResultScreen> {
  late String currentSelectedExamName =
      context.read<ExamDetailsCubit>().getExamName().first;
  late String currentSelectedClassSection = widget.classSectionDetails != null
      ? widget.classSectionDetails!.getClassSectionName()
      : context.read<MyClassesCubit>().getClassSectionName().first;

  late String currentSelectedSubject = widget.subject != null
      ? widget.subject!.name
      : UiUtils.getTranslatedLabel(context, fetchingSubjectsKey);
  late List<TextEditingController> obtainedMarksTextEditingController = [];
  late List<TextEditingController> obtainedVivaMarksTextEditingController = [];
  late String totalMarksOfSelectedSubject = '';
  late String totalTheoryMark = "";
  late String totalVivaMark = "";
  late bool checkViva = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      fetchExamList();
    });
    if (widget.classSectionDetails == null) {
      context.read<SubjectsOfClassSectionCubit>().fetchCustomSubjects(
          classSectionId:
              context.read<MyClassesCubit>().getAllClasses().first.id);
    }

    super.initState();
  }

  void fetchExamList() {
    //
    context
        .read<ExamDetailsCubit>()
        .fetchStudentExamsList(examStatus: 3, publishStatus: 0);
  }

  void fetchSubjectList() {
    //
    context.read<SubjectsOfClassSectionCubit>().fetchCustomSubjects(
        classSectionId: context
            .read<MyClassesCubit>()
            .getClassSectionDetails(
                classSectionName: currentSelectedClassSection)
            .id);
  }

  //
  void fetchStudentList() {
    final subjectId = widget.subject != null
        ? widget.subject!.id
        : context
            .read<SubjectsOfClassSectionCubit>()
            .getSubjectIdByName(currentSelectedSubject);
    if (subjectId != -1) {
      context.read<StudentsByExamAllocationCubit>().fetchStudents(
          examId: context
              .read<ExamDetailsCubit>()
              .getExamDetailsByExamName(examName: currentSelectedExamName)
              .examID!,
          classSectionId: context
              .read<MyClassesCubit>()
              .getClassSectionDetails(
                  classSectionName: currentSelectedClassSection)
              .id,
          subjectId: subjectId);
    }
  }

  Widget _buildAppbar() {
    return Align(
      alignment: Alignment.topCenter,
      child:
          CustomAppBar(title: UiUtils.getTranslatedLabel(context, resultKey)),
    );
  }

  //
  Widget _buildExamListDropdown({required double width}) {
    return BlocConsumer<ExamDetailsCubit, ExamDetailsState>(
        builder: (context, state) {
      return state is ExamDetailsFetchSuccess
          ? state.examList.isEmpty
              ? DefaultDropDownLabelContainer(
                  titleLabelKey:
                      UiUtils.getTranslatedLabel(context, noExamsKey),
                  width: width)
              : CustomDropDownMenu(
                  width: width,
                  onChanged: (result) {
                    //
                    setState(() {
                      currentSelectedExamName = result!;
                      fetchStudentList();
                    });
                  },
                  menu: context.read<ExamDetailsCubit>().getExamName(),
                  currentSelectedItem: currentSelectedExamName)
          : DefaultDropDownLabelContainer(
              titleLabelKey: fetchingExamsKey, width: width);
    }, listener: (context, state) {
      if (state is ExamDetailsFetchSuccess) {
        if (state.examList.isNotEmpty) {
          setState(() {
            currentSelectedExamName =
                context.read<ExamDetailsCubit>().getExamName().first;
          });
        } else {
          context
              .read<StudentsByExamAllocationCubit>()
              .updateState(StudentsByExamAllocationFetchSuccess(students: []));
        }
      }
    });
  }

  Widget _buildClassAndSubjectDropDowns() {
    return LayoutBuilder(builder: (context, boxConstraints) {
      return Column(
        children: [
          //Exam List
          _buildExamListDropdown(width: boxConstraints.maxWidth),
          widget.classSectionDetails == null
              ? MyClassesDropDownMenu(
                  currentSelectedItem: currentSelectedClassSection,
                  width: boxConstraints.maxWidth,
                  changeSelectedItem: (result) {
                    setState(() {
                      currentSelectedClassSection = result;
                    });
                    fetchSubjectList();
                  })
              : DefaultDropDownLabelContainer(
                  titleLabelKey: currentSelectedClassSection,
                  width: boxConstraints.maxWidth),

          widget.subject == null
              ? ClassSubjectsDropDownMenu(
                  changeSelectedItem: (result) {
                    setState(() {
                      currentSelectedSubject = result;
                    });
                    fetchStudentList();
                  },
                  currentSelectedItem: currentSelectedSubject,
                  width: boxConstraints.maxWidth)
              : DefaultDropDownLabelContainer(
                  titleLabelKey: currentSelectedSubject,
                  width: boxConstraints.maxWidth),
        ],
      );
    });
  }

//////Student////
  ///
  TextStyle _getResultTitleTextStyle() {
    return TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
        fontWeight: FontWeight.w600,
        fontSize: 12.0);
  }

  Widget _buildResultTitleDetails(bool vivaMarks) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color:
                    Theme.of(context).colorScheme.secondary.withOpacity(0.075),
                offset: const Offset(2.5, 2.5),
                blurRadius: 5,
                spreadRadius: 1)
          ],
          color: Theme.of(context).scaffoldBackgroundColor),
      width: MediaQuery.of(context).size.width,
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                alignment: AlignmentDirectional.center,
                width: boxConstraints.maxWidth * (0.1),
                child: Text(
                  UiUtils.getTranslatedLabel(context, rollNoKey),
                  style: _getResultTitleTextStyle(),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: AlignmentDirectional.center,
                width: boxConstraints.maxWidth * (0.4),
                child: Text(
                  UiUtils.getTranslatedLabel(context, studentsKey),
                  style: _getResultTitleTextStyle(),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: AlignmentDirectional.center,
                width: boxConstraints.maxWidth * (0.2),
                child: Text(
                  UiUtils.getTranslatedLabel(context, obtainedKey),
                  style: _getResultTitleTextStyle(),
                ),
              ),
            ),
            Visibility(
              visible: vivaMarks,
              child: Expanded(
                child: Container(
                  alignment: AlignmentDirectional.center,
                  width: boxConstraints.maxWidth * (0.2),
                  child: Text(
                    'Viva',
                    style: _getResultTitleTextStyle(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: AlignmentDirectional.center,
                width: boxConstraints.maxWidth * (0.2),
                child: Text(
                  UiUtils.getTranslatedLabel(context, totalKey),
                  style: _getResultTitleTextStyle(),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStudentContainer() {
    return BlocConsumer<StudentsByExamAllocationCubit,
        StudentsByExamAllocationState>(
      listener: (context, state) {
        if (state is StudentsByExamAllocationFetchSuccess) {
          //create textController
          obtainedMarksTextEditingController = [];
          obtainedVivaMarksTextEditingController = [];
          checkViva = false;
          for (var i = 0; i < state.students.length; i++) {
            obtainedMarksTextEditingController.add(TextEditingController(
                text: state.students[i].theoryMark.toString()));
            obtainedVivaMarksTextEditingController.add(TextEditingController(
                text: state.students[i].vivaMark.toString()));
          }
          //
          totalMarksOfSelectedSubject = state.students[0].totalMark.toString();
          totalTheoryMark = state.students[0].totalTheoryMark.toString();
          totalVivaMark = state.students[0].totalVivaMark.toString();
          if (state.students[0].totalVivaMark > 0) {
            checkViva = true;
          }
        }
      },
      builder: (context, state) {
        //
        if (state is StudentsByExamAllocationFetchSuccess) {
          //
          if (state.students.isEmpty) {
            return NoDataContainer(
                titleKey: UiUtils.getTranslatedLabel(context, noDataFoundKey));
          }
          //
          return Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildResultTitleDetails(checkViva),
              SizedBox(
                height: MediaQuery.of(context).size.height * (0.04),
              ),
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                      children: List.generate(state.students.length, (index) {
                    return AddCustomMarksContainer(
                      alias: state.students[index].rollNumber.toString(),
                      obtainedMarksTextEditingController:
                          obtainedMarksTextEditingController[index],
                      obtainedVivaMarksTextEditingController:
                          obtainedVivaMarksTextEditingController[index],
                      vivaMarks: checkViva,
                      title:
                          '${state.students[index].firstName} ${state.students[index].lastName}',
                      totalMarks: totalMarksOfSelectedSubject,
                    );
                  })),
                  //
                  //  SizedBox(
                  //   height: MediaQuery.of(context).size.height * (0.09),
                  ///),
                ),
              ),
              _buildSubmitButtonContainer(),
            ],
          ));
        }
        if (state is StudentsByExamAllocationFetchFailure) {
          return ErrorContainer(
            errorMessageCode: state.errorMessage,
            onTapRetry: () => fetchStudentList(),
          );
        }
        return _buildStudentListShimmerContainer();
      },
    );
  }

  Widget _buildSubmitButton(
      {required String totalMarks, required List<StudentByExam> studentList}) {
    return BlocConsumer<SubjectMarksBySubjectIdCubit,
        SubjectMarksBySubjectIdState>(
      listener: (context, state) {
        if (state is SubjectMarksBySubjectIdSubmitSuccess) {
          UiUtils.showBottomToastOverlay(
              context: context,
              errorMessage: UiUtils.getTranslatedLabel(
                  context, marksAddedSuccessfullyKey),
              backgroundColor: Theme.of(context).colorScheme.onPrimary);

          for (var element in obtainedMarksTextEditingController) {
            element.clear();
          }
          for (var element in obtainedVivaMarksTextEditingController) {
            element.clear();
          }
          Navigator.of(context).pop();
        } else if (state is SubjectMarksBySubjectIdSubmitFailure) {
          UiUtils.showBottomToastOverlay(
              context: context,
              errorMessage: UiUtils.getErrorMessageFromErrorCode(
                  context, state.errorMessage),
              backgroundColor: Theme.of(context).colorScheme.error);
        }
      },
      builder: (context, state) {
        return CustomRoundedButton(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            bool hasError = false;
            List<Map<String, dynamic>> studentsMarksList = [];
            for (int index = 0;
                index < obtainedMarksTextEditingController.length;
                index++) {
              //
              String inputMarks =
                  obtainedMarksTextEditingController[index].text;
              String inputVivaMarks =
                  obtainedVivaMarksTextEditingController[index].text;
              //
              if (inputMarks != '') {
                if (double.parse(inputMarks) > double.parse(totalTheoryMark)) {
                  UiUtils.showBottomToastOverlay(
                      context: context,
                      errorMessage: UiUtils.getTranslatedLabel(
                          context, marksMoreThanTotalMarksKey),
                      backgroundColor: Theme.of(context).colorScheme.error);

                  hasError = true;
                  break;
                }
                if (double.parse(inputVivaMarks) >
                    double.parse(totalVivaMark)) {
                  UiUtils.showBottomToastOverlay(
                      context: context,
                      errorMessage: UiUtils.getTranslatedLabel(
                          context, marksMoreThanTotalMarksKey),
                      backgroundColor: Theme.of(context).colorScheme.error);

                  hasError = true;
                  break;
                }
                studentsMarksList.add({
                  'totalMarksOfSelectedSubject': totalMarksOfSelectedSubject,
                  'obtained_marks': inputMarks,
                  'viva_marks': inputVivaMarks,
                  'student_id': studentList[index].id,
                  'roll_no': studentList[index].rollNumber
                });
              }
            }

            if (studentsMarksList.length !=
                obtainedMarksTextEditingController.length) {
              //if marks of all students are not inserted then error message will be shown

              UiUtils.showBottomToastOverlay(
                  context: context,
                  errorMessage: UiUtils.getTranslatedLabel(
                      context, pleaseEnterAllMarksKey),
                  backgroundColor: Theme.of(context).colorScheme.error);
              return;
            }
            //if marks list is empty and doesn't show any error message before then this will be shown
            if (studentsMarksList.isEmpty && !hasError) {
              UiUtils.showBottomToastOverlay(
                  context: context,
                  backgroundColor: Theme.of(context).colorScheme.error,
                  errorMessage: UiUtils.getTranslatedLabel(
                      context, pleaseEnterSomeDataKey));

              return;
            }

            if (hasError) return;

            context
                .read<SubjectMarksBySubjectIdCubit>()
                .submitSubjectMarksBySubjectId(
                    examId: context
                        .read<ExamDetailsCubit>()
                        .getExamDetailsByExamName(
                            examName: currentSelectedExamName)
                        .examID!,
                    subjectId: widget.subject != null
                        ? widget.subject!.id
                        : context
                            .read<SubjectsOfClassSectionCubit>()
                            .getSubjectIdByName(currentSelectedSubject),
                    bodyParameter: studentsMarksList);
          },
          height: UiUtils.bottomSheetButtonHeight,
          widthPercentage: UiUtils.bottomSheetButtonWidthPercentage,
          backgroundColor: Theme.of(context).colorScheme.primary,
          buttonTitle: UiUtils.getTranslatedLabel(context, submitResultKey),
          showBorder: false,
          child: state is SubjectMarksBySubjectIdSubmitInProgress
              ? const CustomCircularProgressIndicator(
                  strokeWidth: 2,
                  widthAndHeight: 20,
                )
              : null,
        );
      },
    );
  }

  Widget _buildSubmitButtonContainer() {
    return BlocBuilder<StudentsByExamAllocationCubit,
        StudentsByExamAllocationState>(
      builder: (context, state) {
        if (state is StudentsByExamAllocationFetchSuccess) {
          return state.students.isEmpty
              ? const SizedBox()
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: _buildSubmitButton(
                        totalMarks: totalMarksOfSelectedSubject,
                        studentList: (context
                                .read<StudentsByExamAllocationCubit>()
                                .state as StudentsByExamAllocationFetchSuccess)
                            .students),
                  ));
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildStudentListShimmerContainer() {
    return Column(
      children:
          List.generate(UiUtils.defaultShimmerLoadingContentCount, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            width: MediaQuery.of(context).size.width * (0.85),
            child: LayoutBuilder(builder: (context, boxConstraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLoadingContainer(
                      child: CustomShimmerContainer(
                    margin: EdgeInsetsDirectional.only(
                        end: boxConstraints.maxWidth * (0.3)),
                  )),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              );
            }),
          ),
        );
      }),
    );
  }

  ///end
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // floatingActionButton: FloatingActionAddButton(onTap: () {
        //   Navigator.of(context).pushNamed(Routes.addOrEditLesson);
        // }),
        body: Stack(
      children: [
        CustomRefreshIndicator(
          displacment: UiUtils.getScrollViewTopPadding(
              context: context,
              appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage),
          onRefreshCallback: () {
            fetchStudentList();
          },
          child: ListView(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width *
                    UiUtils.screenContentHorizontalPaddingPercentage,
                right: MediaQuery.of(context).size.width *
                    UiUtils.screenContentHorizontalPaddingPercentage,
                top: UiUtils.getScrollViewTopPadding(
                    context: context,
                    appBarHeightPercentage:
                        UiUtils.appBarSmallerHeightPercentage)),
            children: [
              _buildClassAndSubjectDropDowns(),
              SizedBox(
                height: MediaQuery.of(context).size.height * (0.0125),
              ),
              _buildStudentContainer(),
            ],
          ),
        ),
        _buildAppbar()
      ],
    ));
  }
}
