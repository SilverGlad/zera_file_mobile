import 'dart:convert';

class EstablishmentRequest {
  final String latitude;
  final String longitude;

  EstablishmentRequest({
    this.latitude,
    this.longitude,
  });

  EstablishmentRequest copyWith({
    String latitude,
    String longitude,
    String cidade,
    String uf,
  }) {
    return EstablishmentRequest(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory EstablishmentRequest.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return EstablishmentRequest(
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EstablishmentRequest.fromJson(String source) =>
      EstablishmentRequest.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EstblishmentRequest(latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is EstablishmentRequest &&
        o.latitude == latitude &&
        o.longitude == longitude;
  }

  @override
  int get hashCode {
    return latitude.hashCode ^ longitude.hashCode;
  }
}
