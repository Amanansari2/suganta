
class MapModel {
  final String message;
  final int status;
  final MapData data;

  MapModel({required this.message, required this.status, required this.data});

  factory MapModel.fromJson(Map<String, dynamic> json) {
    return MapModel(
      message: json['message'],
      status: json['status'],
      data: MapData.fromJson(json['data']),
    );
  }
}

class MapData {
  final int id;
  final String city;
  final String area;
  final int pincode;
  final String latitude;
  final String longitude;
  final Places places;

  MapData({
    required this.id,
    required this.city,
    required this.area,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    required this.places,
  });

  factory MapData.fromJson(Map<String, dynamic> json) {
    return MapData(
      id: json['id'],
      city: json['city'],
      area: json['area'],
      pincode: json['pincode'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      places: Places.fromJson(json['places']),
    );
  }
}

class Places {
  final List<PlaceItem> hospitals;
  final List<PlaceItem> markets;
  final List<PlaceItem> schools;
  final List<PlaceItem> metro;

  Places({required this.hospitals, required this.markets, required this.schools, required this.metro});

  factory Places.fromJson(Map<String, dynamic> json) {
    return Places(
      hospitals: (json['hospitals'] as List).map((e) => PlaceItem.fromJson(e)).toList(),
      markets: (json['markets'] as List).map((e) => PlaceItem.fromJson(e)).toList(),
      schools: (json['schools'] as List).map((e) => PlaceItem.fromJson(e)).toList(),
      metro:  (json['metro'] as List).map((e) => PlaceItem.fromJson(e)).toList(),
    );
  }
}

class PlaceItem {
  final String name;
  final PlaceLocation location;
  final String vicinity;
  final String placeId;

  PlaceItem({
    required this.name,
    required this.location,
    required this.vicinity,
    required this.placeId,
  });

  factory PlaceItem.fromJson(Map<String, dynamic> json) {
    return PlaceItem(
      name: json['name'],
      location: PlaceLocation.fromJson(json['location']),
      vicinity: json['vicinity'],
      placeId: json['place_id'],
    );
  }
}

class PlaceLocation {
  final double lat;
  final double lng;

  PlaceLocation({required this.lat, required this.lng});

  factory PlaceLocation.fromJson(Map<String, dynamic> json) {
    return PlaceLocation(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }
}
