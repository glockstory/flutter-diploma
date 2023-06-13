import 'package:flutter/material.dart';
import 'package:flutter_final/styles/textstyle.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.fieldController,
      this.child})
      : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? fieldController;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: logoText),
        Container(
          alignment: Alignment.center,
          //width: SizeConfig.screenWidth * 0.95,
          height: 52,
          padding: const EdgeInsets.only(left: 8.0),
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 2, color: Color(0xffefefef))),
          child: Row(children: [
            Expanded(
              child: TextFormField(
                style: subTitleStyle,
                obscureText: false,
                autocorrect: false,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: simpleText),
                controller: fieldController,
                readOnly: child != null ? true : false,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 5),
              child: child ?? Container(),
            )
          ]),
        ),
      ]),
    );
  }
}
