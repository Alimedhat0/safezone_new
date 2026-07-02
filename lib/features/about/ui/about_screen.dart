import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
import 'package:safe_zone/features/about/logic/about_provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.tr;
    final provider = context.watch<AboutProvider>();
    final aboutList = provider.localizedAboutList(l10n);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.about), centerTitle: true),
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
              l10n.safezone,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              l10n.about_description,
            ),
            Divider(thickness: 1),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text(
                  l10n.our_mission,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  l10n.mission_description,
                ),
              ],
            ),
            Divider(thickness: 1),
            Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.how_safezone_helps_you,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(aboutList[index].title),
                      leading: CircleAvatar(
                        backgroundColor: provider.colors[index],
                        child: Icon(
                          aboutList[index].icon,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  itemCount: aboutList.length,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
