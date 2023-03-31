// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:flutter_final/styles/textstyle.dart';

// class StudentPickerWidget extends StatefulWidget {
//   final List<String> names;
//   StudentPickerWidget({Key? key, required this.names}) : super(key: key);

//   @override
//   State<StudentPickerWidget> createState() => _StudentPickerWidgetState();
// }

// class _StudentPickerWidgetState extends State<StudentPickerWidget> {
//   List<String> _selectedNames = [];

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: widget.names.length,
//       itemBuilder: (context, index) {
//         final name = widget.names[index];
//         final isSelected = _selectedNames.contains(name);

//         return ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 if (isSelected) {
//                   _selectedNames.remove(name);
//                 } else {
//                   _selectedNames.add(name);
//                 }
//               });
//             },
//             style: ElevatedButton.styleFrom(
//                 primary: isSelected ? primaryClr : Colors.grey),
//             child: Text(name));
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';

class StudentPickerWidget extends StatefulWidget {
  const StudentPickerWidget({super.key});

  @override
  State<StudentPickerWidget> createState() => _StudentPickerWidgetState();
}

class _StudentPickerWidgetState extends State<StudentPickerWidget> {
  List<String> users = [
    'Никита',
    'Данила',
    'Марина',
    'Юлия',
  ];
  bool _isActiveButton = true;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          // border: Border.all(
          //   color: Colors.grey,
          //   width: 2.0,
          // ),
          // borderRadius: BorderRadius.circular(2.0),
          ),
      child: Wrap(
        spacing: 5.0,
        runSpacing: 8.0,
        children: users.map((user) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: _isActiveButton ? Colors.blue : Colors.grey,
                minimumSize: Size(100, 40)),
            onPressed: () {
              debugPrint('before: $_isActiveButton');
              _toggleButton();
              debugPrint('after: $_isActiveButton');

              debugPrint(user);
            },
            child: Text(user),
          );
        }).toList(),
      ),
    ));
  }

  void _toggleButton() {
    setState(() {
      _isActiveButton = !_isActiveButton;
    });
  }
}
