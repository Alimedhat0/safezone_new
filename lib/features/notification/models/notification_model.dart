class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime date;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {'title': title, 'body': body, 'date': date.toIso8601String()};
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      id: id,
      title: map['title'],
      body: map['body'],
      date: DateTime.parse(map['date']),
    );
  }
}
