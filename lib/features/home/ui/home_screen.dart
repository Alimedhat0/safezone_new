import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/aspict/app_aspict.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
import 'package:safe_zone/core/widgets/home_avatar.dart';
import 'package:safe_zone/features/emergency_contacts/ui/emergency_contact_screen.dart';
import 'package:safe_zone/features/home/data/gird_services_data.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';
import 'package:safe_zone/features/register/model/register_model.dart';
import 'package:safe_zone/features/trusted_contacts/ui/trusted_contact_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.registerModel});
  final RegisterModel? registerModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeProvider>().getUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().getTrustedUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final homePro = context.read<HomeProvider>()..getUser();
        final grid = Provider.of<GirdServicesData>(context);
        return SizedBox(
          width: screenWidth,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RefreshIndicator(
              onRefresh: () async {
                return homePro.getTrustedUsers();
              },
              child: SingleChildScrollView(
                child: Column(
                  spacing: 15,
                  children: [
                    Card(
                      elevation: 6,
                      shadowColor: Theme.of(context).colorScheme.shadow,
                      surfaceTintColor:
                          // Theme.of(context).colorScheme.surfaceTint,
                          Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.tr.contacts,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                SizedBox(
                                  height: 40,
                                  width: screenWidth * 0.6,
                                  child: Consumer<HomeProvider>(
                                    builder: (context, provider, _) {
                                      if (provider.trustedContacts.isEmpty) {
                                        return Text(
                                          'There is no contacts ${provider.trustedContacts.length}',
                                        );
                                      } else {
                                        return ListView.builder(
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          // shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              provider.trustedContacts.length,
                                          itemBuilder: (context, index) {
                                            return Row(
                                              children: [
                                                avatar(
                                                  context,
                                                  provider
                                                      .trustedContacts[index]
                                                      .name,
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                shape: CircleBorder(),
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => TrustedContactScreen(
                                          registerModel: widget.registerModel!,
                                        ),
                                  ),
                                );
                              },

                              child: Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Text(
                          'Services',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    Consumer<GirdServicesData>(
                      builder: (context, provider, _) {
                        return GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                          itemCount: provider.gridServicesModel.length,
                          itemBuilder: (context, index) {
                            final gridPro = provider.gridServicesModel[index];
                            return InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                switch (index) {
                                  case 0:
                                    provider.shareLocation();
                                    break;
                                  case 1:
                                    provider.startLiveTracking();
                                    break;
                                  case 2:
                                    provider.naviagteTo(
                                      context,
                                      TrustedContactScreen(
                                        registerModel: widget.registerModel,
                                      ),
                                    );
                                    break;
                                  case 3:
                                    provider.naviagteTo(
                                      context,
                                      EmergencyContactScreen(),
                                    );
                                  default:
                                }
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    spacing: 7,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        gridPro.image,
                                        width: 30,
                                        height: 30,
                                      ),
                                      Text(
                                        gridPro.title,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        gridPro.subTitle,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.14,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: const Color.fromARGB(
                            255,
                            192,
                            58,
                            43,
                          ),
                        ),
                        onPressed: () async {
                          await grid.init();

                          await grid.locationPer();
                          await grid.startLiveTracking();

                          String? path = await grid.record10Seconds();

                          if (path != null && grid.currentLatLng != null) {
                            await grid.sendSos(
                              audioPath: path,
                              lat: grid.currentLatLng!.latitude,
                              lon: grid.currentLatLng!.longitude,
                              // uid: grid.uid,
                            );
                          } else {
                            print("Missing data ❌");
                          }
                        },
                        child: Text('SOS', style: TextStyle(fontSize: 25)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
