class VoiceMessage {
  final String id;
  final String receiverName;
  final String receiverUid;
  final String? senderName;
  final String senderUid;
  final String type;
  final String content;
  final String createdAt;

  VoiceMessage({
    required this.id,
    required this.receiverName,
    required this.receiverUid,
    this.senderName,
    required this.senderUid,
    required this.type,
    required this.content,
    required this.createdAt,
  });

  factory VoiceMessage.fromMap(Map<String, dynamic> map) => VoiceMessage(
    id: map['id'],
    receiverName: map['receiverName'],
    receiverUid: map['receiverUid'],
    senderName: map['senderName'] ?? '',
    senderUid: map['senderUid'],
    type: map['type'],
    content: map['content'],
    createdAt: map['createdAt'],
  );
  Map<String, dynamic> toMap() => {
    'id': id,
    'receiverName': receiverName,
    'receiverUid': receiverUid,
    'senderName': senderName,
    'senderUid': senderUid,
    'type': type,
    'content': content,
    'createdAt': createdAt,
  };
}
