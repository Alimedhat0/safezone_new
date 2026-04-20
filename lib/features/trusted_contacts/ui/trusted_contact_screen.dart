// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:safe_zone/core/aspict/app_aspict.dart';
// import 'package:safe_zone/core/widgets/custom_text_field.dart';
// import 'package:safe_zone/core/widgets/home_avatar.dart';
// import 'package:safe_zone/features/home/logic/home_provider.dart';
// import 'package:safe_zone/features/messages/ui/message_screen.dart';
// import 'package:safe_zone/features/register/model/register_model.dart';

// class TrustedContactScreen extends StatelessWidget {
//   final RegisterModel? registerModel;
//   const TrustedContactScreen({super.key, required this.registerModel});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create:
//           (context) =>
//               HomeProvider()
//                 ..getAllUsers()
//                 ..getContacts()
//                 ..getUser(),
//       builder: (context, child) {
//         final homePro = context.watch<HomeProvider>();
//         return Scaffold(
//           appBar: AppBar(title: Text('Trusted Contacts'), centerTitle: true),
//           // body: Padding(
//           //   padding: const EdgeInsets.all(8.0),
//           //   child: Column(
//           //     children: [
//           //       Expanded(
//           //         child: SingleChildScrollView(
//           //           child: SizedBox(
//           //             width: double.infinity,
//           //             child: Padding(
//           //               padding: EdgeInsets.symmetric(
//           //                 horizontal: 30.0,
//           //                 vertical: 16,
//           //               ),
//           //               child: Column(
//           //                 crossAxisAlignment: CrossAxisAlignment.start,
//           //                 spacing: 10,
//           //                 children: [
//           //                   Text(
//           //                     'Add trusted contacts who will receive your\nemergency alerts.',
//           //                     style: TextStyle(fontWeight: FontWeight.bold),
//           //                   ),
//           //                   Consumer<HomeProvider>(
//           //                     builder: (context, provider, child) {
//           //                       if (provider.users.isEmpty) {
//           //                         return Column(
//           //                           children: [
//           //                             CustomTextField(
//           //                               controller: provider.searchController,

//           //                               onSubmit: (value) {
//           //                                 if (value.isNotEmpty) {
//           //                                   provider.searchForUser();
//           //                                 } else {
//           //                                   provider.getAllUsers();
//           //                                 }
//           //                               },
//           //                               text: 'Search user here...',
//           //                             ),
//           //                             Text('There is no conatcts'),
//           //                           ],
//           //                         );
//           //                       } else {
//           //                         return SizedBox(
//           //                           width: screenWidth,
//           //                           height: screenHeight * 0.7,
//           //                           child: ListView.builder(
//           //                             physics: AlwaysScrollableScrollPhysics(),
//           //                             itemCount: provider.users.length,
//           //                             itemBuilder: (context, index) {
//           //                               return GestureDetector(
//           //                                 onTap:
//           //                                     () => Navigator.push(
//           //                                       context,
//           //                                       MaterialPageRoute(
//           //                                         builder:
//           //                                             (
//           //                                               context,
//           //                                             ) => MessageScreen(
//           //                                               // المستخدم الحالي
//           //                                               registerModel:
//           //                                                   provider
//           //                                                       .users[index], // الشخص اللي هتكلمه
//           //                                             ),
//           //                                       ),
//           //                                     ),
//           //                                 child: Card(
//           //                                   elevation: 5,
//           //                                   shape: RoundedRectangleBorder(
//           //                                     borderRadius:
//           //                                         BorderRadius.circular(20),
//           //                                   ),
//           //                                   child: Padding(
//           //                                     padding:
//           //                                         const EdgeInsets.symmetric(
//           //                                           horizontal: 8.0,
//           //                                           vertical: 10.0,
//           //                                         ),
//           //                                     child: Row(
//           //                                       spacing: 10,
//           //                                       children: [
//           //                                         avatar(
//           //                                           context,
//           //                                           provider.users[index].name,
//           //                                         ),
//           //                                         Expanded(
//           //                                           child: Column(
//           //                                             spacing: 5,
//           //                                             crossAxisAlignment:
//           //                                                 CrossAxisAlignment
//           //                                                     .start,
//           //                                             children: [
//           //                                               Text(
//           //                                                 provider
//           //                                                     .users[index]
//           //                                                     .name,
//           //                                                 style: TextStyle(
//           //                                                   fontWeight:
//           //                                                       FontWeight.bold,
//           //                                                   fontSize: 16,
//           //                                                 ),
//           //                                               ),
//           //                                               Text(
//           //                                                 provider
//           //                                                     .users[index]
//           //                                                     .phoneNumber,
//           //                                                 style: TextStyle(
//           //                                                   color: Colors.grey,
//           //                                                 ),
//           //                                               ),
//           //                                             ],
//           //                                           ),
//           //                                         ),
//           //                                         IconButton(
//           //                                           onPressed:
//           //                                               () => provider
//           //                                                   .deleteContact(
//           //                                                     index,
//           //                                                   ),
//           //                                           icon: Icon(
//           //                                             Icons.delete,
//           //                                             color: Colors.red,
//           //                                           ),
//           //                                         ),
//           //                                       ],
//           //                                     ),
//           //                                   ),
//           //                                 ),
//           //                               );
//           //                             },
//           //                           ),
//           //                         );
//           //                       }
//           //                     },
//           //                   ),
//           //                 ],
//           //               ),
//           //             ),
//           //           ),
//           //         ),
//           //       ),
//           //       SizedBox(
//           //         width: double.infinity,
//           //         child: ElevatedButton(
//           //           style: ElevatedButton.styleFrom(
//           //             backgroundColor: Colors.blue,
//           //           ),
//           //           onPressed: () {
//           //             showDialog(
//           //               context: context,
//           //               builder: (context) {
//           //                 return AlertDialog(
//           //                   title: Text('Add New Contact'),
//           //                   content: Column(
//           //                     mainAxisSize: MainAxisSize.min,

//           //                     crossAxisAlignment: CrossAxisAlignment.start,
//           //                     spacing: 10,
//           //                     children: [
//           //                       Text('Name'),
//           //                       CustomTextField(
//           //                         text: 'Enter Name',
//           //                         keyboardType: TextInputType.name,
//           //                         controller: homePro.nameController,
//           //                       ),
//           //                       Text('Phone'),
//           //                       CustomTextField(
//           //                         text: 'Enter Phone number',
//           //                         keyboardType: TextInputType.phone,
//           //                         controller: homePro.phoneController,
//           //                       ),
//           //                     ],
//           //                   ),
//           //                   actions: [
//           //                     Row(
//           //                       spacing: 15,
//           //                       mainAxisAlignment: MainAxisAlignment.center,
//           //                       children: [
//           //                         ElevatedButton(
//           //                           onPressed: () => Navigator.pop(context),
//           //                           child: Text('Cancel'),
//           //                         ),
//           //                         ElevatedButton(
//           //                           style: ElevatedButton.styleFrom(
//           //                             backgroundColor: Colors.blue,
//           //                           ),
//           //                           onPressed: () {
//           //                             homePro.addContact();
//           //                             Navigator.pop(context);
//           //                           },
//           //                           child: Text(
//           //                             'Save',
//           //                             style: TextStyle(color: Colors.white),
//           //                           ),
//           //                         ),
//           //                       ],
//           //                     ),
//           //                   ],
//           //                 );
//           //               },
//           //             );
//           //           },
//           //           child: Text(
//           //             '+ Add New Contact',
//           //             style: TextStyle(color: Colors.white),
//           //           ),
//           //         ),
//           //       ),
//           //     ],
//           //   ),
//           // ),
//           body: Consumer<HomeProvider>(
//             builder: (context, value, child) {
//               final provider = context.read<HomeProvider>();
//               if (provider.isLoading) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               return Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   spacing: 20,
//                   children: [
//                     CustomTextField(
//                       controller: provider.searchController,
//                       text: 'Search user here...',
//                       onSubmit: (value) {
//                         if (value.isNotEmpty) {
//                           provider.searchForUser();
//                         } else {
//                           provider.getAllUsers();
//                         }
//                       },
//                     ),
//                     Expanded(
//                       child: ListView.separated(
//                         itemBuilder:
//                             (context, index) => GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder:
//                                         (context) => MessageScreen(
//                                           registerModel: provider.users[index],
//                                         ),
//                                   ),
//                                 );
//                               },
//                               child: Row(
//                                 spacing: 10,
//                                 children: [
//                                   CircleAvatar(
//                                     backgroundColor:
//                                         Theme.of(context).colorScheme.primary,
//                                     child: Icon(
//                                       Icons.person,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           provider.users[index].name,
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 16,
//                                           ),
//                                         ),
//                                         Text(provider.users[index].email),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                         separatorBuilder:
//                             (context, index) => Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 10),
//                               child: Divider(color: Colors.grey[400]),
//                             ),
//                         itemCount: provider.users.length,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/widgets/custom_text_field.dart';
import 'package:safe_zone/features/home/logic/home_provider.dart';
import 'package:safe_zone/features/messages/ui/message_screen.dart';
import 'package:safe_zone/features/register/model/register_model.dart';

class TrustedContactScreen extends StatefulWidget {
  const TrustedContactScreen({super.key, this.registerModel});
  final RegisterModel? registerModel;

  @override
  State<TrustedContactScreen> createState() => _TrustedContactScreenState();
}

class _TrustedContactScreenState extends State<TrustedContactScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeProvider>().getUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().getAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('trusted'),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ProfileScreen()),
              // );
            },
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, value, child) {
          final provider = context.read<HomeProvider>();
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              spacing: 20,
              children: [
                CustomTextField(
                  controller: provider.searchController,
                  text: 'Search user here...',
                  onSubmit: (value) {
                    if (value.isNotEmpty) {
                      provider.searchForUser();
                    } else {
                      provider.getAllUsers();
                    }
                  },
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder:
                        (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => MessageScreen(
                                      registerModel: provider.users[index],
                                    ),
                              ),
                            );
                          },
                          child: Row(
                            spacing: 10,
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      provider.users[index].name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(provider.users[index].email),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  provider.toggleTrusted(provider.users[index]);
                                },
                                icon: Icon(
                                  provider.trustedContacts.any(
                                        (u) =>
                                            u.uid == provider.users[index].uid,
                                      )
                                      ? Icons.star
                                      : Icons.star_border,
                                ),
                              ),
                            ],
                          ),
                        ),
                    separatorBuilder:
                        (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Divider(color: Colors.grey[400]),
                        ),
                    itemCount: provider.users.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
