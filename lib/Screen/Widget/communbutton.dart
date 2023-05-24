import 'package:flutter/material.dart';

InkResponse commonbutton(double height, width, Function() ontab, String text) {
  return InkResponse(
    onTap: ontab,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    ),
  );
}
