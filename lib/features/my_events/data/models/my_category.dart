import 'package:calender/features/my_events/data/models/my_event.dart';
class MyCategory {
  String? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  List<MyEvent>? myEvents;
  int? color;
  String? icon;
  bool? isSynced;

  MyCategory({
    this.id,
    this.name,
    this.color,
    this.createdAt,
    this.updatedAt,
    this.myEvents,
    this.icon,
    this.isSynced = false,
  });

  factory MyCategory.fromJson(Map<String, dynamic> json) {
    return MyCategory(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      myEvents:
          json['myEvents'] != null
              ? List<MyEvent>.from(
                json['myEvents'].map((x) => MyEvent.fromJson(x)),
              )
              : null,
      icon: json['icon'],
      isSynced: json['isSynced'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'createdAt': createdAt,
      'updatedAt': DateTime.now().toIso8601String(),
      'myEvents': myEvents?.map((x) => x.toJson()).toList(),
      'icon': icon,
      'isSynced': isSynced,
    };
  }
}
