import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/core/extensions/localization_extension.dart';
import 'package:safe_zone/features/report_a_problem/logic/report_a_problem_provider.dart';

class ReportAProblemScreen extends StatelessWidget {
  const ReportAProblemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.tr;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.report_a_problem)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<ReportAProblemProvider>(
          builder: (context, provider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.report_problem_description),

                const SizedBox(height: 20),

                Text(l10n.problem_category),

                const SizedBox(height: 10),

                ...provider.localizedCategories(l10n).map((cat) {
                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: RadioListTile(
                      value: cat,
                      groupValue: provider.selectedCategory,
                      onChanged: (val) {
                        provider.selectCategory(val!);
                      },
                      title: Text(cat),
                    ),
                  );
                }),

                const SizedBox(height: 20),

                Text(l10n.description),

                const SizedBox(height: 10),

                TextField(
                  controller: provider.descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: l10n.describe_issue,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed:
                        provider.isLoading
                            ? null
                            : () async {
                              try {
                                await provider.submitReport(context);

                                Fluttertoast.showToast(msg: l10n.report_sent);
                              } catch (e) {
                                Fluttertoast.showToast(msg: l10n.error);
                              }
                            },
                    child:
                        provider.isLoading
                            ? CircularProgressIndicator()
                            : Text(
                              l10n.submit_report,
                              style: TextStyle(color: Colors.white),
                            ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
