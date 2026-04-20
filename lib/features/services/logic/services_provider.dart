import 'package:flutter/material.dart';
import 'package:safe_zone/features/services/models/services_models.dart';

class ServicesProvider extends ChangeNotifier {
  List<ServicesModels> services = [
    ServicesModels(
      title: 'Police',
      subTitle: 'Law enforcement emergency',
      number: '122',
    ),
    ServicesModels(
      title: 'Ambluance',
      subTitle: 'Medical emergency services',
      number: '123',
    ),
    ServicesModels(
      title: 'FireDepartment',
      subTitle: 'Fire and reuse service',
      number: '180',
    ),
  ];

  final incidentController = TextEditingController();

  List<SafeTipsModel> safeTips = [
    SafeTipsModel(
      icon: Icons.remove_red_eye_outlined,
      title: 'Stay aware of your surroundings',
    ),
    SafeTipsModel(
      icon: Icons.location_on_outlined,
      title: 'Avoid dark and isolated areas',
    ),
    SafeTipsModel(
      icon: Icons.people_alt_outlined,
      title: 'Walk in groups when possible',
    ),
  ];
}
