import 'package:eschool_teacher/cubits/SubmitAssessmentCubit.dart';
import 'package:eschool_teacher/cubits/assessmentCubit.dart';
import 'package:eschool_teacher/data/models/assessment.dart';
import 'package:eschool_teacher/data/repositories/studentRepository.dart';
import 'package:eschool_teacher/data/repositories/teacherRepository.dart';
import 'package:eschool_teacher/ui/widgets/customAppbar.dart';
import 'package:eschool_teacher/ui/widgets/customCircularProgressIndicator.dart';
import 'package:eschool_teacher/ui/widgets/customRoundedButton.dart';
import 'package:eschool_teacher/ui/widgets/customShimmerContainer.dart';
import 'package:eschool_teacher/ui/widgets/errorContainer.dart';
import 'package:eschool_teacher/ui/widgets/noDataContainer.dart';
import 'package:eschool_teacher/ui/widgets/shimmerLoadingContainer.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssessmentScreen extends StatefulWidget {
  final int? studentId;
  final String? studentName;

  const AssessmentScreen({Key? key, this.studentId, this.studentName})
      : super(key: key);
  static Route route(RouteSettings routeSettings) {
    final studentData = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider<AssessmentCubit>(
                    create: (context) => AssessmentCubit(StudentRepository()),
                  ),
                  BlocProvider<SubmitAssessmentCubit>(
                    create: (context) =>
                        SubmitAssessmentCubit(TeacherRepository()),
                  ),
                ],
                child: AssessmentScreen(
                  studentId: studentData['studentId'],
                  studentName: studentData['studentName'],
                )));
  }

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  late final List<Assessment> assessment;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) => fetchExamList());
  }

  void fetchExamList() {
    //
    context
        .read<AssessmentCubit>()
        .fetchAssessments(studentId: widget.studentId!);
  }

  TextStyle _getAssessmentTitleTextStyle() {
    return TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
        fontWeight: FontWeight.w600,
        fontSize: 12.0);
  }

  Widget _buildAssessmentContainer() {
    return BlocConsumer<AssessmentCubit, AssessmentState>(
      listener: (context, state) {
        if (state is AssessmentFetchSuccess) {
          assessment = state.assessments;
        }
      },
      builder: (context, state) {
        //
        if (state is AssessmentFetchSuccess) {
          //
          if (state.assessments.isEmpty) {
            return NoDataContainer(
                titleKey: UiUtils.getTranslatedLabel(context, noDataFoundKey));
          }
          //
          return ListView.builder(
              padding: const EdgeInsets.only(top: 100),
              itemCount: assessment.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                  ),
                  child: Column(
                    children: [
                      Text("${assessment[index].title} ",
                          style: _getAssessmentTitleTextStyle()),
                      Text(
                        "${assessment[index].subTitle} ",
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.8),
                            fontSize: 14.5,
                            fontWeight: FontWeight.w400),
                      ),
                      Column(
                        children: [
                          CheckboxListTile(
                            // title: Text(
                            //   "${_data[index].title} ${index + 1}",
                            // ),
                            title: Text(
                                UiUtils.getTranslatedLabel(context, averageKey),
                                style: _getAssessmentTitleTextStyle()),
                            value: assessment[index].isAverage,
                            onChanged: (val) {
                              setState(
                                () {
                                  assessment[index].isAverage = val!;
                                  if (assessment[index].isAverage == true) {
                                    assessment[index].isGood = false;
                                    assessment[index].isPoor = false;
                                  }
                                },
                              );
                            },
                            activeColor: Theme.of(context).colorScheme.primary,
                            checkColor: Colors.white,
                            tileColor: Colors.black12,
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                          CheckboxListTile(
                            // title: Text(
                            //   "${_data[index].title} ${index + 1}",
                            // ),
                            title: Text(
                                UiUtils.getTranslatedLabel(context, goodKey),
                                style: _getAssessmentTitleTextStyle()),
                            value: assessment[index].isGood,
                            onChanged: (val) {
                              setState(
                                () {
                                  assessment[index].isGood = val!;
                                  if (assessment[index].isGood == true) {
                                    assessment[index].isAverage = false;
                                    assessment[index].isPoor = false;
                                  }
                                },
                              );
                            },
                            activeColor: Theme.of(context).colorScheme.primary,
                            checkColor: Colors.white,
                            tileColor: Theme.of(context).colorScheme.outline,
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                          CheckboxListTile(
                            // title: Text(
                            //   "${_data[index].title} ${index + 1}",
                            // ),
                            title: Text(
                                UiUtils.getTranslatedLabel(context, poorKey),
                                style: _getAssessmentTitleTextStyle()),
                            value: assessment[index].isPoor,
                            onChanged: (val) {
                              setState(
                                () {
                                  assessment[index].isPoor = val!;
                                  if (assessment[index].isPoor == true) {
                                    assessment[index].isGood = false;
                                    assessment[index].isAverage = false;
                                  }
                                },
                              );
                            },
                            activeColor: Theme.of(context).colorScheme.primary,
                            checkColor: Colors.white,
                            tileColor: Colors.black12,
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
        }
        if (state is AssessmentFetchFailure) {
          return ErrorContainer(
            errorMessageCode: state.errorMessage,
            onTapRetry: () => fetchExamList(),
          );
        }
        return _buildStudentListShimmerContainer();
      },
    );
  }

  Widget _buildStudentListShimmerContainer() {
    return Center(
      child: Column(
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
      ),
    );
  }

  Widget _buildAppbar() {
    return Align(
      alignment: Alignment.topCenter,
      child: CustomAppBar(
        title: UiUtils.getTranslatedLabel(context, assessmentKey),
        subTitle: " ${widget.studentName}",
        showBackButton: true,
        onPressBackButton: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildSubmitAssessmentButton() {
    return BlocConsumer<SubmitAssessmentCubit, SubmitAssessmentState>(
      listener: (context, submitAssessmentState) {
        if (submitAssessmentState is SubmitAssessmentSuccess) {
          UiUtils.showBottomToastOverlay(
              context: context,
              errorMessage: UiUtils.getTranslatedLabel(
                  context, assessmentSubmittedSuccessfullyKey),
              backgroundColor: Theme.of(context).colorScheme.onPrimary);
        } else if (submitAssessmentState is SubmitAssessmentFailure) {
          UiUtils.showBottomToastOverlay(
              context: context,
              errorMessage: UiUtils.getErrorMessageFromErrorCode(
                  context, submitAssessmentState.errorMessage),
              backgroundColor: Theme.of(context).colorScheme.error);
        }
      },
      builder: (context, submitAssessmentState) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: CustomRoundedButton(
                onTap: () {
                  if (submitAssessmentState is SubmitAssessmentInProgress) {
                    return;
                  }

                  context.read<SubmitAssessmentCubit>().submitAssessment(
                      studentId: widget.studentId!, assessment: assessment);
                },
                elevation: 10.0,
                height: UiUtils.bottomSheetButtonHeight,
                widthPercentage: UiUtils.bottomSheetButtonWidthPercentage,
                backgroundColor: Theme.of(context).colorScheme.primary,
                buttonTitle: UiUtils.getTranslatedLabel(context, submitKey),
                showBorder: false,
                child: submitAssessmentState is SubmitAssessmentInProgress
                    ? const CustomCircularProgressIndicator(
                        strokeWidth: 2,
                        widthAndHeight: 20,
                      )
                    : null),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildAssessmentContainer(),
          _buildSubmitAssessmentButton(),
          _buildAppbar(),
        ],
      ),
    );
  }
}
