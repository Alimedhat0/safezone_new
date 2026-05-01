import 'package:flutter/material.dart';

class ThemeTile extends StatelessWidget {
  final ThemeMode value;
  final ThemeMode groupValue;
  final Function(ThemeMode) onChanged;
  final String title;
  final IconData? icon;
  final Widget? secondry;

  const ThemeTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.icon,
    required this.secondry,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: RadioListTile<ThemeMode>(
        value: value,
        groupValue: groupValue,
        onChanged: (val) {
          if (val != null) onChanged(val);
        },
        title: Text(title),
        secondary: secondry,
        activeColor: Colors.blue,
      ),
    );
  }
}
