import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/features/delete_account/logic/delete_account_provider.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DeleteAccountProvider>();
    return Scaffold(
      appBar: AppBar(title: Text('Delete Account'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 20,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.red[100],
              child: Icon(Icons.warning_amber, color: Colors.red, size: 40),
            ),
            Text(
              'Final Warning',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text(
              'This is your last chance to cancel. Once you confirm, your account will be permanently deleted.',
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 16),
              color: Colors.red[100],
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  spacing: 10,
                  children: [
                    Text('The following data will be permanently deleted:'),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Text(provider.listCard[index]);
                      },
                      itemCount: provider.listCard.length,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'This action ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'cannot be undone',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            Column(
              spacing: 5,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 6,
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed:
                        provider.isDeletingAccount
                            ? null
                            : () async {
                              await provider.deleteCurrentAccount(context);
                            },
                    child: Text(
                      provider.isDeletingAccount
                          ? 'Deleting Account...'
                          : 'Yes, Delete My Account Permanently',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 6,
                      backgroundColor: Colors.grey,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
