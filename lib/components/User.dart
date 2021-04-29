class User {
  final double latitude;
  final double longitude;
  final bool needsHelp;
  final String id;

  User(this.latitude, this.longitude, this.id, this.needsHelp);
  User.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'],
        longitude = json['longitude'],
        needsHelp = json['needsHelp'],
        id = json['id'];

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'needsHelp': needsHelp,
        'id': id,
      };
}
