import 'package:flutter/material.dart';
import 'package:flutter_final/styles/textstyle.dart';

class TwoButtonWidget extends StatefulWidget {
  const TwoButtonWidget({super.key});

  @override
  State<TwoButtonWidget> createState() => _TwoButtonWidgetState();
}

class _TwoButtonWidgetState extends State<TwoButtonWidget> {
  bool _isLeftActive = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _toggleButton(true),
            style: ElevatedButton.styleFrom(
                primary: _isLeftActive ? Colors.grey : primaryClr,
                minimumSize: Size(80, 50)),
            child: Text('Общая'),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
            child: ElevatedButton(
          onPressed: () => _toggleButton(false),
          style: ElevatedButton.styleFrom(
              primary: _isLeftActive ? primaryClr : Colors.grey,
              minimumSize: Size(80, 50)),
          child: Text('Индивидуальная'),
        )),
      ],
    );
  }

  void _toggleButton(bool isLeftActive) {
    setState(() {
      _isLeftActive = !isLeftActive;
    });
  }
}
