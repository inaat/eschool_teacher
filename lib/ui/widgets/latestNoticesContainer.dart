import 'package:eschool_teacher/app/routes.dart';
import 'package:eschool_teacher/cubits/noticeBoardCubit.dart';
import 'package:eschool_teacher/ui/widgets/announcementDetailsContainer.dart';
import 'package:eschool_teacher/ui/widgets/shimmerLoaders/announcementShimmerLoadingContainer.dart';
import 'package:eschool_teacher/utils/constants.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LatestNoticiesContainer extends StatelessWidget {
  const LatestNoticiesContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // margin: EdgeInsets.symmetric(
      //     horizontal: MediaQuery.of(context).size.width *
      //         UiUtils.screenContentHorizontalPaddingInPercentage),
      padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(UiUtils.getTranslatedLabel(context, latestNoticesKey),
                  style: TextStyle(
                      color: UiUtils.getColorScheme(context).secondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0),
                  textAlign: TextAlign.start),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.noticeBoard);
                },
                child: Text(UiUtils.getTranslatedLabel(context, viewAllKey),
                    style: TextStyle(
                        color: UiUtils.getColorScheme(context).onBackground,
                        fontSize: 13.0),
                    textAlign: TextAlign.start),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * (0.025),
          ),
          BlocBuilder<NoticeBoardCubit, NoticeBoardState>(
            builder: (context, state) {
              if (state is NoticeBoardFetchSuccess) {
                final announcements = state.announcements.length >
                        numberOfLatestNotciesInHomeScreen
                    ? state.announcements
                        .sublist(0, numberOfLatestNotciesInHomeScreen)
                        .toList()
                    : state.announcements;
                return Column(
                  children: announcements
                      .map((notice) =>
                          AnnouncementDetailsContainer(announcement: notice))
                      .toList(),
                );
              }

              if (state is NoticeBoardFetchInProgress ||
                  state is NoticeBoardInitial) {
                return Column(
                  children: List.generate(3, (index) => index)
                      .map((notice) => AnnouncementShimmerLoadingContainer())
                      .toList(),
                );
              }

              return SizedBox();
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * (0.025),
          ),
        ],
      ),
    );
  }
}
