class ReportAProblemModel {
  final String category;
  final String description;
  final String userId;
  final String createdAt;

  ReportAProblemModel({
    required this.category,
    required this.description,
    required this.userId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'description': description,
      'userId': userId,
      'createdAt': createdAt,
    };
  }
}
