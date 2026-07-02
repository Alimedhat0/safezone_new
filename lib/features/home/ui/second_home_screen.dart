import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/aspict/app_aspict.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
import 'package:safe_zone/core/widgets/home_avatar.dart';
import 'package:safe_zone/features/home/data/gird_services_data.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';
import 'package:safe_zone/features/location/logic/location_provider.dart';
import 'package:safe_zone/features/notification/ui/notification_screen.dart';
import 'package:safe_zone/features/register/model/register_model.dart';
import 'package:safe_zone/features/sos/ui/sos_screen.dart';
import 'package:safe_zone/features/trusted_contacts/ui/trusted_contact_screen.dart';

class SecondHomeScreen extends StatefulWidget {
  const SecondHomeScreen({super.key, required this.registerModel});
  final RegisterModel? registerModel;

  @override
  State<SecondHomeScreen> createState() => _SecondHomeScreenState();
}

class _SecondHomeScreenState extends State<SecondHomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeProvider>().getUser();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final homeProvider = context.read<HomeProvider>();
      final gridProvider = context.read<GirdServicesData>();
      final locationProvider = context.read<LocationProvider>();

      await homeProvider.getTrustedUsers();
      await gridProvider.getCurrentLocation();

      if (!mounted) return;
      final currentLocation = gridProvider.currentLatLng;
      if (currentLocation != null) {
        locationProvider.moveTo(currentLocation);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final homePro = context.read<HomeProvider>();
        final locationPro = context.watch<LocationProvider>();
        final grid = context.watch<GirdServicesData>();
        final currentLocation = grid.currentLatLng;

        return SizedBox(
          width: screenWidth,
          child: RefreshIndicator(
            onRefresh: () async {
              return homePro.getTrustedUsers();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        height: screenHeight * 0.65,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: const [
                              Color(0xff001B66),
                              Color(0xff0033AA),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(120),
                            bottomRight: Radius.circular(120),
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 50,
                        ),
                        height: 200,
                        child: Row(
                          spacing: 5,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                spacing: 5,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.shield_moon_outlined,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  const Text(
                                    "You're Protected",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                  const Text(
                                    "We're here for your safety",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              const NotificationScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.notifications_none_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              child: IconButton(
                                onPressed: () {
                                  grid.stopTracking();
                                },
                                icon: const Icon(
                                  Icons.stop,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        height: screenHeight * 0.4,
                        width: screenWidth,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(120),
                            bottomRight: Radius.circular(120),
                          ),
                          child: Stack(
                            clipBehavior: Clip.antiAlias,
                            children: [
                              FlutterMap(
                                mapController: locationPro.mapController,
                                options: MapOptions(
                                  initialCenter:
                                      currentLocation ??
                                      locationPro.currentLocation ??
                                      const LatLng(30.0444, 31.2357),
                                  initialZoom: 15,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://api.maptiler.com/maps/${locationPro.selectedMapStyle}/{z}/{x}/{y}.png?key=${locationPro.apiKey}',
                                    userAgentPackageName: 'com.example.app',
                                  ),
                                  if (currentLocation != null)
                                    MarkerLayer(
                                      markers: [
                                        Marker(
                                          point: currentLocation,
                                          width: 80,
                                          height: 80,
                                          child: const Icon(
                                            Icons.circle,
                                            color: Colors.blue,
                                            size: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),

                              Positioned(
                                bottom: 120,
                                right: 20,
                                child: Column(
                                  children: [
                                    FloatingActionButton.small(
                                      backgroundColor: Colors.black,
                                      onPressed: () async {
                                        await grid.getCurrentLocation();
                                        final location = grid.currentLatLng;
                                        if (location != null) {
                                          locationPro.moveTo(location);
                                        }
                                      },
                                      child: const Icon(
                                        Icons.my_location,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Positioned(
                        top: 150,
                        right: 2,
                        left: 2,
                        child: Card(
                          elevation: 6,
                          color: Colors.black,
                          surfaceTintColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
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
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 90,
                                      width: screenWidth * 0.65,
                                      child: Consumer<HomeProvider>(
                                        builder: (context, provider, _) {
                                          if (provider
                                              .trustedContacts
                                              .isEmpty) {
                                            return Text(
                                              'There is no contacts ${provider.trustedContacts.length}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            );
                                          } else {
                                            return ListView.builder(
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  provider
                                                      .trustedContacts
                                                      .length,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    avatar(
                                                      context,
                                                      provider
                                                          .trustedContacts[index]
                                                          .name,
                                                      provider
                                                          .trustedContacts[index]
                                                          .phone,
                                                    ),
                                                    const SizedBox(width: 10),
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
                                SizedBox(
                                  height: 120,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FilledButton(
                                        style: FilledButton.styleFrom(
                                          shape: const CircleBorder(),
                                          backgroundColor: const Color.fromARGB(
                                            37,
                                            56,
                                            83,
                                            1,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      TrustedContactScreen(
                                                        registerModel:
                                                            widget
                                                                .registerModel!,
                                                      ),
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.add,
                                          size: 20,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const Text(
                                        'Add Contact',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        left: 130,
                        top: screenHeight * 0.55,
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.white,
                          child: SizedBox(
                            height: 150,
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  255,
                                  25,
                                  0,
                                ),
                                shadowColor: Colors.red[100],
                              ),
                              onPressed: () async {
                                final navigator = Navigator.of(context);
                                await grid.init();
                                await grid.startLiveTracking();
                                if (!mounted) return;
                                navigator.push(
                                  MaterialPageRoute(
                                    builder: (context) => const SosScreen(),
                                  ),
                                );
                                String? path = await grid.record10Seconds();

                                if (path != null &&
                                    grid.currentLatLng != null) {
                                  await grid.sendSos(
                                    audioPath: path,
                                    lat: grid.currentLatLng!.latitude,
                                    lon: grid.currentLatLng!.longitude,
                                  );
                                } else {
                                  debugPrint("Missing data ❌");
                                }
                              },
                              child: const Text(
                                'SOS',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 8,
                        ),
                        child: Row(
                          spacing: 10,
                          children: [
                            const CircleAvatar(
                              child: Icon(
                                Icons.location_on,
                                color: Colors.blue,
                                size: 24,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Live Location',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'Sharing your location',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  Text(
                                    (grid.locationName.toString()),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  208,
                                  232,
                                  244,
                                ),
                              ),
                              onPressed: grid.startLiveTracking,
                              child: const Row(
                                spacing: 5,
                                children: [
                                  Icon(
                                    Icons.broadcast_on_home,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    'Live',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
