import 'package:flutter/material.dart';

class BlackButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  final double? width;        // Chiều ngang
  final double height;        // Chiều cao
  final double fontSize;      // Size chữ
  final double borderRadius;  // Bo góc

  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double borderWidth;

  const BlackButton({
    super.key,
    required this.text,
    required this.onPressed,

    this.width,                 // nếu không truyền → full width
    this.height = 52,           // mặc định cao 52
    this.fontSize = 16,         // size chữ mặc định
    this.borderRadius = 12,     // bo góc mặc định

    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: borderColor,
              width: borderWidth,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
