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
      appBar: AppBar(title: Text('Add Contacts')),
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
                                  provider.users[index].isTrusted ||
                                          provider.trustedContacts.any(
                                            (u) =>
                                                u.uid ==
                                                provider.users[index].uid,
                                          )
                                      ? Icons.star
                                      : Icons.star_border,
                                  color:
                                      provider.users[index].isTrusted
                                          ? Colors.amber
                                          : null,
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
