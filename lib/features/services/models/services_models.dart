import 'package:flutter/material.dart';

class ServicesModels {
  final String title;
  final String subTitle;
  final String number;

  ServicesModels({
    required this.title,
    required this.subTitle,
    required this.number,
  });
}

class SafeTipsModel {
  final IconData icon;
  final String title;

  SafeTipsModel({required this.icon, required this.title});
}
