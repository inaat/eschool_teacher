import 'package:eschool_teacher/ui/widgets/noticeBoardContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoticeBoardScreen extends StatelessWidget {
  final int? childId;
  const NoticeBoardScreen({Key? key, this.childId}) : super(key: key);

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(builder: (_) => NoticeBoardScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NoticeBoardContainer(
        showBackButton: true,
      ),
    );
  }
}