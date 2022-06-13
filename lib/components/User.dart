class User {
  final double? latitude;
  final double? longitude;
  final bool? needsHelp;
  final String? isHelping;
  final String? isGettingHelp;
  final String? id;

  User(this.latitude, this.longitude, this.id, this.needsHelp, this.isHelping, this.isGettingHelp);
  User.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'],
        longitude = json['longitude'],
        needsHelp = json['needsHelp'],
        isHelping = json['isHelping'],
        isGettingHelp = json['isGettingHelp'],
        id = json['id'];

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'needsHelp': needsHelp,
        'isHelping': isHelping,
        'isGettingHelp' : isGettingHelp,
        'id': id,
      };
}
