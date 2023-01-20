import 'package:flutter/material.dart';
import 'package:todo/ui/theme.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.lable, required this.ontape})
      : super(key: key);
  final String lable;
  final Function() ontape;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontape,
      child: Container(
        alignment: Alignment.center,
        width: 100,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: primaryClr,
        ),
        child: Text(
          lable,
          style: const TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
