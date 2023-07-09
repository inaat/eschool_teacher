import 'package:dropdown_search/dropdown_search.dart';
import 'package:eschool_teacher/app/routes.dart';
import 'package:eschool_teacher/cubits/SchoolCubit.dart';
import 'package:eschool_teacher/data/models/school.dart';
import 'package:eschool_teacher/data/repositories/schoolRepository.dart';
import 'package:eschool_teacher/ui/widgets/customShimmerContainer.dart';
import 'package:eschool_teacher/ui/widgets/errorContainer.dart';
import 'package:eschool_teacher/ui/widgets/internetListenerWidget.dart';
import 'package:eschool_teacher/ui/widgets/noDataContainer.dart';
import 'package:eschool_teacher/ui/widgets/schoolContainer.dart';
import 'package:eschool_teacher/ui/widgets/shimmerLoadingContainer.dart';
import 'package:eschool_teacher/utils/hiveBoxKeys.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

class SchoolsScreen extends StatefulWidget {
  SchoolsScreen({
    Key? key,
  }) : super(key: key);

  static Route<dynamic> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
        builder: (_) => BlocProvider(
            create: (context) => SchoolsCubit(SchoolRepository()),
            child: SchoolsScreen()));
  }

  @override
  State<SchoolsScreen> createState() => _SchoolsScreenState();
}

class _SchoolsScreenState extends State<SchoolsScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1000));

  late final Animation<double> _patterntAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.0, 0.5, curve: Curves.easeInOut)));

  late final Animation<double> _formAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.5, 1.0, curve: Curves.easeInOut)));
  late final List<School> schools;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context.read<SchoolsCubit>().fetchSchools();
      _animationController.forward();
    });

    super.initState();
  }

  Future<void> SetMainUrlBoxKey(String value) async {
    return Hive.box(mainUrlBoxKey).put(mainUrl, value);
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  Widget _buildSchoolDropdown() {
    return BlocConsumer<SchoolsCubit, SchoolsState>(
      listener: (context, state) {
        if (state is SchoolsFetchSuccess) {
          schools = state.schools;
        }
      },
      builder: (context, state) {
        //
        if (state is SchoolsFetchSuccess) {
          //
          if (state.schools.isEmpty) {
            return NoDataContainer(
                titleKey: UiUtils.getTranslatedLabel(context, noDataFoundKey));
          }
          //
          return Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: UiUtils.getColorScheme(context).primary)),
                child: DropdownSearch<String>(
                    //mode: Mode.MENU,
                    showSelectedItems: true,
                    items: state.schools.map((e) => e.name).toList(),
                    dropdownSearchDecoration: const InputDecoration(
                      labelText: "Select Your Campus",
          
                    ),
                    onChanged: itemSelectionChanged,
                    showSearchBox: true,
                    searchFieldProps: const TextFieldProps(
                      cursorColor: Color.fromARGB(172, 13, 231, 165),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                        hintText: "Search school",
                      ),
                      
                    )),
              ),
            ],
          ));
        }
        if (state is SchoolsFetchFailure) {
          return ErrorContainer(
              errorMessageCode: state.errorMessage,
              onTapRetry: () => context.read<SchoolsCubit>().fetchSchools());
        }
        return _buildStudentListShimmerContainer();
      },
    );
  }

  Widget _buildUpperPattern() {
    return Align(
      alignment: Alignment.topRight,
      child: FadeTransition(
        opacity: _patterntAnimation,
        child: SlideTransition(
            position: _patterntAnimation.drive(Tween<Offset>(
                begin: const Offset(0.0, -1.0), end: Offset.zero)),
            child: Image.asset(UiUtils.getImagePath("upper_pattern.png"))),
      ),
    );
  }

  Widget _buildLowerPattern() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: FadeTransition(
        opacity: _patterntAnimation,
        child: SlideTransition(
            position: _patterntAnimation.drive(
                Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)),
            child: Image.asset(UiUtils.getImagePath("lower_pattern.png"))),
      ),
    );
  }

  Widget _buildSchoolForm() {
    return Align(
      alignment: Alignment.topLeft,
      child: FadeTransition(
        opacity: _formAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * (0.075),
              right: MediaQuery.of(context).size.width * (0.075),
              top: MediaQuery.of(context).size.height * (0.25)),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Align(
                    alignment: Alignment.center,
                    child: FadeTransition(
                      opacity: _patterntAnimation,
                      child: SlideTransition(
                          position: _patterntAnimation.drive(Tween<Offset>(
                              begin: const Offset(0.0, -1.0),
                              end: Offset.zero)),
                          child: Image.asset(
                              UiUtils.getImagePath("loginHeader.png"))),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                _buildSchoolDropdown(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildUpperPattern(),
          _buildLowerPattern(),
          _buildSchoolForm(),
        ],
      ),
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

  void itemSelectionChanged(String? s) {
    for (var i = 0; i < schools.length; i++) {
      if (schools[i].name == s) {
        print(schools[i].name);
        // print(schools);
        SetMainUrlBoxKey(schools[i].url);
        // //fetchAppConfiguration();
        print(Hive.box(mainUrlBoxKey).get(mainUrl) ?? "");
        Navigator.of(context).pushReplacementNamed(Routes.login);
      }
    }
  }
}
