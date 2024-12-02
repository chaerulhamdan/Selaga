import 'package:flutter/material.dart';

class MyCheckBox extends StatelessWidget {
  final String hintText;
  final bool? velue;
  final Function(bool?)? onChanged;

  const MyCheckBox(
      {super.key, required this.hintText, this.velue, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          checkColor: const Color.fromRGBO(76, 76, 220, 1),
          fillColor: const MaterialStatePropertyAll(Colors.white),
          value: velue,
          onChanged: onChanged,
        ),
        Text(
          hintText,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
