import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:eschool_teacher/data/models/school.dart';
import 'package:eschool_teacher/data/models/sliderDetails.dart';
import 'package:eschool_teacher/utils/constants.dart';
import 'package:eschool_teacher/utils/hiveBoxKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../../app/routes.dart';

class SchoolsContainer extends StatefulWidget {
  final List<School> schools;
  const SchoolsContainer({Key? key, required this.schools}) : super(key: key);

  @override
  State<SchoolsContainer> createState() => _SchoolsContainerState();
}

class _SchoolsContainerState extends State<SchoolsContainer> {
    Future<void> SetMainUrlBoxKey(String value) async {
    return Hive.box(mainUrlBoxKey).put(mainUrl, value);
  }
  @override
  Widget build(BuildContext context) {
    
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "WellCome Back",
                style: TextStyle(
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold,
                    color: UiUtils.getColorScheme(context).secondary),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Select Your Campus",
                style: TextStyle(
                    fontSize: 24.0,
                    height: 1.5,
                    color: UiUtils.getColorScheme(context).secondary),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: UiUtils.getColorScheme(context).secondary)),
                child: DropdownSearch<String>(
                  mode: Mode.MENU,
                  showSelectedItems: true,
                  items: widget.schools.map((e) => e.name).toList(),
                  dropdownSearchDecoration: const InputDecoration(
                    labelText: "Select Your Campus",
                    // hintText: "country in menu mode",
                  ),
                  //  popupItemDisabled: isItemDisabled,
                  onChanged: itemSelectionChanged,
                  //selectedItem: "",
                  showSearchBox: true,
                  searchFieldProps: const TextFieldProps(
                    cursorColor: Colors.blue,
                  ),
                ),
              ),
            ],
        
    );
  }
    bool isItemDisabled(String s) {
    //return s.startsWith('I');

    if (s.startsWith('I')) {
      return true;
    } else {
      return false;
    }
  }

  void itemSelectionChanged(String? s ) {
    //   String getJwtToken() {
    //   return Hive.box(authBoxKey).get(jwtTokenKey) ?? "";
    // }
    print(s);
    SetMainUrlBoxKey("https://lhss.sfsc.edu.pk/api/");
    //fetchAppConfiguration();
    print(Hive.box(mainUrlBoxKey).get(mainUrl) ?? "");
    Navigator.of(context).pushReplacementNamed(Routes.login);
  }
}

