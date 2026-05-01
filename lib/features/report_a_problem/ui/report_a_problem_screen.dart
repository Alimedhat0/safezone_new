import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/features/report_a_problem/logic/report_a_problem_provider.dart';

class ReportAProblemScreen extends StatelessWidget {
  const ReportAProblemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report a Problem")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<ReportAProblemProvider>(
          builder: (context, provider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tell us what went wrong so we can help fix it."),

                const SizedBox(height: 20),

                Text("Problem Category"),

                const SizedBox(height: 10),

                ...provider.categories.map((cat) {
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

                Text("Description"),

                const SizedBox(height: 10),

                TextField(
                  controller: provider.descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Describe the issue...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                const Spacer(),

                /// 🚀 Submit Button
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
                                await provider.submitReport();

                                Fluttertoast.showToast(msg: 'Report Sent');
                              } catch (e) {
                                Fluttertoast.showToast(msg: 'Error');
                              }
                            },
                    child:
                        provider.isLoading
                            ? CircularProgressIndicator()
                            : Text(
                              "Submit Report",
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
