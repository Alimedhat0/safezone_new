import 'package:flutter/material.dart';

class LanguageTile extends StatelessWidget {
  final String value;
  final String groupValue;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const LanguageTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: RadioListTile<String>(
        value: value,
        groupValue: groupValue,
        onChanged: (_) => onTap(),
        title: Text(
          title,
          style: TextStyle(
            color: value == groupValue ? Colors.blue : Colors.black,
          ),
        ),
        subtitle: Text(subtitle),
        activeColor: Colors.blue,
      ),
    );
  }
}
