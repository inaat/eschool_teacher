import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddCustomMarksContainer extends StatelessWidget {
  final String title;
  final String alias;
  final String totalMarks;
  final TextEditingController obtainedMarksTextEditingController;
  final TextEditingController obtainedVivaMarksTextEditingController;
  final bool? isReadOnly;
  final bool vivaMarks;

  const AddCustomMarksContainer(
      {Key? key,
      required this.title,
      required this.alias,
      required this.totalMarks,
      required this.vivaMarks,
      required this.obtainedMarksTextEditingController,
      required this.obtainedVivaMarksTextEditingController,
      this.isReadOnly})
      : super(key: key);

  Widget _buildSubjectNameWithObtainedMarksContainer(
      {required BuildContext context,
      required String alias,
      required String studentName,
      required String totalMarks,
      required bool vivaMarks,
      bool? isReadOnly}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: LayoutBuilder(builder: (context, boxConstraints) {
       bool isVisible = vivaMarks;
         return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //
            Expanded(
              child: Container(
                alignment: AlignmentDirectional.centerStart,
                width: boxConstraints.maxWidth * (0.1),
                child: Text(
                  alias.toString(),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: AlignmentDirectional.centerStart,
                width: boxConstraints.maxWidth * (0.4),
                child: Text(
                  studentName,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.5))),
                width: boxConstraints.maxWidth * (0.2),
                height: 35,
                padding: const EdgeInsets.only(bottom: 6),
                child: TextField(
                  inputFormatters: <TextInputFormatter>[
                    //allow only one decimal point (.)
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                  ],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 12.0,
                  ),
                  controller: obtainedMarksTextEditingController,
                  readOnly: isReadOnly ?? false,
                  decoration: const InputDecoration(border: InputBorder.none),
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                ),
              ),
            ),
            Visibility(
              visible: isVisible,
              child: Expanded(
                child: 
                
                Container(
                  alignment: AlignmentDirectional.centerEnd,
                  margin: const EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.5))),
                  width: boxConstraints.maxWidth * (0.2),
                  height: 35,
                  padding: const EdgeInsets.only(bottom: 6),
                  child: TextField(
                    inputFormatters: <TextInputFormatter>[
                      //allow only one decimal point (.)
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                    ],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 12.0,
                    ),
                    controller: obtainedVivaMarksTextEditingController,
                    readOnly: isReadOnly ?? false,
                    decoration: const InputDecoration(border: InputBorder.none),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: false),
                        
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: AlignmentDirectional.center,
                width: boxConstraints.maxWidth * (0.2),
                child: Text(
                  totalMarks,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSubjectNameWithObtainedMarksContainer(
        context: context,
        alias: alias,
        studentName: title,
        totalMarks: totalMarks,
        vivaMarks: vivaMarks,
        isReadOnly: isReadOnly);
  }
}
