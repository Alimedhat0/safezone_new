import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/features/about/logic/about_provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AboutProvider>();
    return Scaffold(
      appBar: AppBar(title: Text('About'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SvgPicture.asset('assests/images/about_image.svg'),
                  Center(
                    child: Icon(
                      Icons.shield_outlined,
                      color: Colors.white,
                      size: 90,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'SafeZone',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Providing instant emergency support, live location sharing, and trusted contact alerts to keep you safe.',
            ),
            Divider(thickness: 1),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text(
                  'Our Mission',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  'The app aims to keep users safe and provide quick help in dangerous or uncertain situations.',
                ),
              ],
            ),
            Divider(thickness: 1),
            Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How SafeZone Helps You',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(provider.aboutList[index].title),
                      leading: CircleAvatar(
                        backgroundColor: provider.colors[index],
                        child: Icon(
                          provider.aboutList[index].icon,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  itemCount: provider.aboutList.length,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
