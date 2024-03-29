// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';

class RegInButton extends StatefulWidget {
  String text = '';
  bool isSelected = true;
  MaterialStateProperty<Color> buttonColor =
      MaterialStateProperty.all(Colors.white);
  final Function toggleView;
  RegInButton(
      {super.key,
      required this.text,
      required this.isSelected,
      required this.buttonColor,
      required this.toggleView});

  @override
  State<RegInButton> createState() => _RegInButtonState();
}

class _RegInButtonState extends State<RegInButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          if (widget.isSelected == false) {
            widget.toggleView();
            widget.isSelected = !widget.isSelected;
          } else if (widget.isSelected == true) {
            return;
          }
        });
      },
      style: ButtonStyle(
        backgroundColor: widget.buttonColor,
        elevation: MaterialStateProperty.all(0),
        fixedSize: MaterialStateProperty.all(const Size(140, 50)),
      ),
      child: Text(
        widget.text,
        style: TextStyle(fontSize: 15),
      ),
    );
  }
}
