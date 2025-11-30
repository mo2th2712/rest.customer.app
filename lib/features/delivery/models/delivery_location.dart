class DeliveryLocation {
  final String address;
  final double lat;
  final double lng;

  const DeliveryLocation({
    required this.address,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toJson() => {
        'address': address,
        'lat': lat,
        'lng': lng,
      };

  factory DeliveryLocation.fromJson(Map<String, dynamic> json) {
    final a = (json['address'] ?? '').toString();
    final lat = (json['lat'] as num?)?.toDouble();
    final lng = (json['lng'] as num?)?.toDouble();
    if (a.trim().isEmpty || lat == null || lng == null) {
      throw const FormatException('Invalid DeliveryLocation json');
    }
    return DeliveryLocation(address: a, lat: lat, lng: lng);
  }
}
