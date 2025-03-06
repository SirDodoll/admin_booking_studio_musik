import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_booking_application/providers/theme_providers.dart';

class TextFieldWidget extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final bool readOnly;
  final TextInputType? keyboardType;
  final VoidCallback? toggleObscureText;

  const TextFieldWidget({
    super.key,
    required this.icon,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.toggleObscureText,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.getIsDarkTheme;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: isDarkMode ? Colors.white : Colors.black),
        hintText: hintText,
        hintStyle: TextStyle(color: isDarkMode ? Colors.white54 : Colors.grey),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: isDarkMode ? Colors.white24 : Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: isDarkMode ? Colors.white : Colors.black),
        ),
        suffixIcon: toggleObscureText != null
            ? IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: toggleObscureText,
        )
            : null,
      ),
    );
  }
}
