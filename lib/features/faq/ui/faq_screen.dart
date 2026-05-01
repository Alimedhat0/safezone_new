import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_zone/features/faq/logic/faq_provider.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FAQ"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Consumer<FaqProvider>(
              builder: (context, provider, _) {
                return TextField(
                  decoration: InputDecoration(
                    hintText: "Search for a question..",
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onChanged: provider.searchInFAQ,
                );
              },
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Consumer<FaqProvider>(
                builder: (context, provider, _) {
                  final list = provider.filteredFaq;

                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];

                      return Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ExpansionTile(
                          title: Text(item.question),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(item.answer),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
