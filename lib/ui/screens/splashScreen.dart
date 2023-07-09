import 'package:eschool_teacher/app/routes.dart';
import 'package:eschool_teacher/cubits/appConfigurationCubit.dart';
import 'package:eschool_teacher/cubits/authCubit.dart';
import 'package:eschool_teacher/ui/widgets/errorContainer.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    fetchAppConfiguration();
  }

  void fetchAppConfiguration() {
    Future.delayed(Duration.zero, () {
      context.read<AppConfigurationCubit>().fetchAppConfiguration();
    });
  }

  void navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 1));
    // ignore: use_build_context_synchronously
    if (context.read<AuthCubit>().state is Unauthenticated) {
       
      // ignore: use_build_context_synchronously
     // Navigator.of(context).pushReplacementNamed(Routes.login);
      Navigator.of(context).pushReplacementNamed(Routes.school);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AppConfigurationCubit, AppConfigurationState>(
        listener: (context, state) {
          if (state is AppConfigurationFetchSuccess) {
            navigateToNextScreen();
          }
        },
        builder: (context, state) {
          if (state is AppConfigurationFetchFailure) {
            return Center(
              child: ErrorContainer(
                  onTapRetry: () {
                    fetchAppConfiguration();
                  },
                  errorMessageCode: UiUtils.getErrorMessageFromErrorCode(
                      context, state.errorMessage)),
            );
          }
          return Center(
              child: SvgPicture.asset(UiUtils.getImagePath("appLogo.svg")));
        },
      ),
    );
  }
}
