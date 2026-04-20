import 'package:flutter/material.dart';

Widget avatar(BuildContext context, String text) {
  return Card(
    elevation: 4,
    shadowColor: Theme.of(context).colorScheme.shadow,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    child: CircleAvatar(
      radius: 22,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: //Theme.of(context).colorScheme.primaryContainer,
            Colors.blue,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        child: Text(
          text.trim().isNotEmpty ? text.substring(0, 2).toUpperCase() : '',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  );
}
