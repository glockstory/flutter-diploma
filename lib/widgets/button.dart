import 'package:flutter/material.dart';
import 'package:flutter_final/styles/textstyle.dart';

class MyButton extends StatelessWidget {
  const MyButton({required this.label, required this.onTap, Key? key})
      : super(key: key);

  final String label;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10), // отступы слева и справа
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap, // добавьте свои действия
        style:
            ButtonStyle(backgroundColor: MaterialStateProperty.all(primaryClr)),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: buttonText,
        ),
      ),
    );
  }
}
