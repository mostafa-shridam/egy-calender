class MyEvent {
  String? id;
  String? title;
  String? description;
  String? image;
  String? createdAt;
  String? updatedAt;
  int? priority; // 0 = Low, 1 = Medium, 2 = High
  String? startAt; // ISO 8601
  String? endAt; // ISO 8601
  String? categoryId;
  bool? isSynced;

  MyEvent({
    this.id,
    this.title,
    this.description,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.priority,
    this.startAt,
    this.endAt,
    this.categoryId,
    this.isSynced = false,
  });

  factory MyEvent.fromJson(Map<String, dynamic> json) {
    return MyEvent(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      priority: json['priority'],
      startAt: json['startAt'],
      endAt: json['endAt'],
      categoryId: json['categoryId'],
      isSynced: json['isSynced'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'priority': priority,
      'startAt': startAt,
      'endAt': endAt,
      'categoryId': categoryId,
      'isSynced': isSynced,
    };
  }
}
