class VersionModel {
  final String version;
  final String? id;
  VersionModel({required this.version, this.id});

  factory VersionModel.fromJson(Map<String, dynamic> json) {
    return VersionModel(version: json['version'], id: json[r'$id']);
  }

  Map<String, dynamic> toJson({bool toLocale = false}) => {
    if (toLocale) r'$id': id,
    'version': version,
  };
}
