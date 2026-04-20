import 'package:flutter/material.dart';

class beforeMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;
  const beforeMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blue, size: 25),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subTitle,
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
