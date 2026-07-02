import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
import 'package:safe_zone/features/delete_account/logic/delete_account_provider.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.tr;
    final provider = context.watch<DeleteAccountProvider>();
    final listCard = provider.localizedListCard(l10n);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.delete_account), centerTitle: true),
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
              l10n.final_warning,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text(
              l10n.delete_account_warning,
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
                    Text(l10n.delete_account_data_intro),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Text(listCard[index]);
                      },
                      itemCount: listCard.length,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.this_action,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  l10n.cannot_be_undone,
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
                          ? l10n.deleting_account
                          : l10n.yes_delete_account_permanently,
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
                      l10n.cancel,
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
