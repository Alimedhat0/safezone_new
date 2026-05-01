import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/features/emergency_contacts/logic/emergency_provider.dart';
import 'package:safe_zone/features/safety_guide/ui/safety_guide_screen.dart';
import 'package:safe_zone/features/services/logic/services_provider.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final provider = context.read<ServicesProvider>();
        final emergencyProvider = context.watch<EmergencyProvider>();
        return SingleChildScrollView(
          child: Column(
            children: [
              Card(
                color: Colors.white,

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
                                'Emergency Contacts',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'National emergency hotlines',
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
                      itemCount: provider.services.length,
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
                                          provider.services[index].title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(provider.services[index].subTitle),
                                        Text(
                                          provider.services[index].number,
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
                                        provider.services[index].number,
                                      );
                                    },
                                    child: Icon(
                                      Icons.call_outlined,
                                      color: Colors.white,
                                    ),
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
                color: Colors.white,
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
                                'Report Incident',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Document safety concerns',
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
                          Text('Incident Type'),
                          TextFormField(
                            controller: provider.incidentController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF5F7FA),
                              hintText: 'Select incident type',
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.white),
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
                                    backgroundColor: Color(0xFFE8F1FD),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.file_upload_outlined,
                                        color: const Color(0xFF2F80ED),
                                      ),
                                      Text(
                                        'Upload Media',
                                        style: TextStyle(
                                          color: const Color(0xFF2F80ED),
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

                                    backgroundColor: Colors.blue[50],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.send_outlined,
                                        color: Colors.blue,
                                      ),
                                      Text(
                                        'Share Location',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text('Description'),
                          TextFormField(
                            controller: provider.incidentController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF5F7FA),
                              hintText: 'Describe what happened...',
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    'Submit Report',
                                    style: TextStyle(color: Colors.white),
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
                color: Colors.white,
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
                                'Safe guide',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Daily safe tips',
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
                        itemCount: provider.safeTips.length,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 10,
                            children: [
                              Icon(
                                provider.safeTips[index].icon,
                                color: Colors.blue,
                              ),
                              Text(provider.safeTips[index].title),
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
                            'More Tips',
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
        );
      },
    );
  }
}
