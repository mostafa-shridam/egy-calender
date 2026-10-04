class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? avatar;
  String? deviceId;
  String? createdAt;
  String? updatedAt;
  bool? isVerified;
  bool? isBlocked;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.avatar,
    this.deviceId,
    this.createdAt,
    this.updatedAt,
    this.isVerified,
    this.isBlocked,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    avatar: json['avatar'],
    deviceId: json['deviceId'],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
    isVerified: json['isVerified'],
    isBlocked: json['isBlocked'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'avatar': avatar,
    'deviceId': deviceId,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'isVerified': isVerified,
    'isBlocked': isBlocked,
  };
}
