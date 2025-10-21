class ListItemModel {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final String userId;

  ListItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.userId,
  });

  factory ListItemModel.fromJson(Map<String, dynamic> json) {
    return ListItemModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
    };
  }
}
