import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/features/safety_guide/logic/safety_guide_provider.dart';

class SafetyGuideScreen extends StatelessWidget {
  const SafetyGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Safety Guide'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<SafetyGuideProvider>(
          builder: (context, provider, _) {
            return ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(provider.safetyList[index].title),
                  leading: Icon(
                    provider.safetyList[index].icon,
                    color: Colors.blue,
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(thickness: 1),
              itemCount: provider.safetyList.length,
            );
          },
        ),
      ),
    );
  }
}
