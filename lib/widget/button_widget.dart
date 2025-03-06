import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final bool isOutlined;
  final bool isLoading;
  final double? width;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = Colors.red,
    this.textColor = Colors.white,
    this.isOutlined = false,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 50,
      child: isOutlined
          ? OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: backgroundColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.red)
            : Text(text, style: TextStyle(color: backgroundColor, fontSize: 16)),
      )
          : ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(text, style: TextStyle(color: textColor, fontSize: 16)),
      ),
    );
  }
}
