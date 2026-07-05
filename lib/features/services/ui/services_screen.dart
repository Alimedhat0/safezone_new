import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
import 'package:safe_zone/features/emergency_contacts/logic/emergency_provider.dart';
import 'package:safe_zone/features/home/data/gird_services_data.dart';
import 'package:safe_zone/features/safety_guide/ui/safety_guide_screen.dart';
import 'package:safe_zone/features/services/logic/services_provider.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final l10n = context.tr;
        final colorScheme = Theme.of(context).colorScheme;
        final provider = context.watch<ServicesProvider>();
        final gridProvider = context.watch<GirdServicesData>();
        final emergencyProvider = context.watch<EmergencyProvider>();
        final services = provider.localizedServices(l10n);
        final safeTips = provider.localizedSafeTips(l10n);
        return SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Card(
                  margin: EdgeInsets.all(16),
                  elevation: 6,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          spacing: 10,
                          children: [
                            SvgPicture.asset(
                              'assests/svgs/call_icon.svg',
                              width: 35,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 5,
                              children: [
                                Text(
                                  l10n.emergency_contacts,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  l10n.national_emergency_hotlines,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 6,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        spacing: 5,
                                        children: [
                                          Text(
                                            services[index].title,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(services[index].subTitle),
                                          Text(
                                            services[index].number,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.lightBlue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                      onPressed: () {
                                        emergencyProvider.launchPhone(
                                          services[index].number,
                                        );
                                      },
                                      child: Icon(Icons.call_outlined),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(16),
                  elevation: 6,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          spacing: 10,
                          children: [
                            SvgPicture.asset(
                              'assests/svgs/alert-triangle_icon.svg',
                              width: 35,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 5,
                              children: [
                                Text(
                                  l10n.report_incident,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  l10n.document_safety_concerns,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.incident_type),
                            TextFormField(
                              controller: provider.incidentController,
                              decoration: InputDecoration(
                                hintText: l10n.select_incident_type,
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor:
                                          colorScheme.primaryContainer,
                                      foregroundColor:
                                          colorScheme.onPrimaryContainer,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed:
                                        provider.isPickingMedia ||
                                                provider.isSubmittingReport
                                            ? null
                                            : provider.pickMedia,
                                    child: Row(
                                      children: [
                                        provider.isPickingMedia
                                            ? SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color:
                                                    colorScheme
                                                        .onPrimaryContainer,
                                              ),
                                            )
                                            : Icon(Icons.file_upload_outlined),
                                        Text(
                                          l10n.upload_media,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor:
                                          colorScheme.primaryContainer,
                                      foregroundColor:
                                          colorScheme.onPrimaryContainer,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      gridProvider.shareLocation(l10n: l10n);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.send_outlined),
                                        Text(
                                          l10n.share_location_title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (provider.selectedMediaName != null)
                              Row(
                                children: [
                                  Icon(
                                    provider.selectedMediaType == 'video'
                                        ? Icons.videocam_outlined
                                        : Icons.image_outlined,
                                    color: colorScheme.primary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      provider.selectedMediaName!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: colorScheme.onSurfaceVariant,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            Text(l10n.description),
                            TextFormField(
                              controller: provider.descriptionController,
                              decoration: InputDecoration(
                                hintText: l10n.describe_what_happened,
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colorScheme.primary,
                                      foregroundColor: colorScheme.onPrimary,
                                    ),
                                    onPressed:
                                        provider.isSubmittingReport
                                            ? null
                                            : () async {
                                              try {
                                                await provider
                                                    .submitIncidentReport(
                                                      l10n,
                                                    );
                                                if (!context.mounted) return;
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      l10n.report_sent,
                                                    ),
                                                  ),
                                                );
                                              } catch (e) {
                                                if (!context.mounted) return;
                                                final message = provider
                                                        .lastReportError ??
                                                    e
                                                        .toString()
                                                        .replaceFirst(
                                                          'Exception: ',
                                                          '',
                                                        );
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(message),
                                                  ),
                                                );
                                              }
                                            },
                                    child:
                                        provider.isSubmittingReport
                                            ? SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: colorScheme.onPrimary,
                                              ),
                                            )
                                            : Text(
                                              l10n.submit_report,
                                              style: TextStyle(
                                                color: colorScheme.onPrimary,
                                              ),
                                            ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(16),
                  elevation: 6,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          spacing: 10,
                          children: [
                            SvgPicture.asset(
                              'assests/svgs/Iconfont_icon.svg',
                              width: 35,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 5,
                              children: [
                                Text(
                                  l10n.safe_guide,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  l10n.daily_safe_tips,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              width: 10,
                              height: 20,
                              child: Divider(thickness: 1),
                            );
                          },
                          itemCount: safeTips.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 10,
                              children: [
                                Icon(safeTips[index].icon, color: Colors.blue),
                                Text(safeTips[index].title),
                              ],
                            );
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SafetyGuideScreen(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.more_tips,
                              style: TextStyle(color: Colors.blue),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.blueAccent,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
