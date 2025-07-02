


class PropertyPostResponse {
  String message;
  List<PostPropertyData> data;
  int status;

  PropertyPostResponse({
    required this.message,
    required this.data,
    required this.status,
  });

  factory PropertyPostResponse.fromJson(Map<String, dynamic> json) {
    return PropertyPostResponse(
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => PostPropertyData.fromJson(item))
          .toList(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "data": data.map((item) => item.toJson()).toList(),
      "status": status,
    };
  }
}

class PostPropertyData {
  int id;
  String slug;
  String wantTo;
  String? description;

  String? type;
  String? updatedAt;
  int? userRoleId;
  int? userRole;
  int? typeOptionsId;
  int? propertyLogId;

  Address address;
  Feature? feature;
  FirstImage? firstImage;
  List<PropertyImage> images;

  PostPropertyData({
    required this.id,
    required this.slug,
    required this.wantTo,
    this.description,

    this.type,
    this.updatedAt,
    this.userRoleId,
    this.userRole,
    this.typeOptionsId,
    this.propertyLogId,

    required this.address,
    this.feature,
    this.firstImage,
    required this.images,
  });

  factory PostPropertyData.fromJson(Map<String, dynamic> json) {
    return PostPropertyData(
      id: json['id'],
      slug: json['slug'],
      wantTo: json['want_to'],
      updatedAt: json['updated_at'],
      userRoleId: json['user_role_id'],
      userRole: json['user_role'],
      typeOptionsId: json['type_options_id'],
      propertyLogId: json['property_log_id'],
      description: json['description'],
      address: Address.fromJson(json['address']),
      feature: json['feature'] != null ? Feature.fromJson(json['feature']) : null,
      firstImage: json['first_image'] != null ? FirstImage.fromJson(json['first_image']) : null,
      images:(json['images'] as List)
          .map((item) => PropertyImage.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "slug": slug,
      "want_to": wantTo,
      "description": description,
      "type": type,
      "updated_at": updatedAt,
      "user_role_id": userRoleId,
      "user_role": userRole,
      "type_options_id": typeOptionsId,
      "address": address.toJson(),
      "feature": feature?.toJson(),
      "first_image": firstImage?.toJson(),
      "images": images.map((img) => img.toJson()).toList(),
    };
  }
}
class FirstImage {
  int id;
  int propertyId;
  String image;

  FirstImage({
    required this.id,
    required this.propertyId,
    required this.image,
  });

  factory FirstImage.fromJson(Map<String, dynamic> json) {
    return FirstImage(
      id: json['id'],
      propertyId: json['property_id'],
      image: json['image'],
    );
  }



  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "property_id": propertyId,
      "image": image,
    };
  }
}

class PropertyImage {
  int id;
  int propertyId;
  String image;

  PropertyImage({
    required this.id,
    required this.propertyId,
    required this.image,
  });

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      id: json['id'],
      propertyId: json['property_id'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "property_id": propertyId,
      "image": image,
    };
  }
}


class Address {
  int id;
  int propertyId;
  String city;
  String area;
  String? subLocality;
  int pin;
  String? houseNo;
  double? latitude;
  double? longitude;

  Address({
    required this.id,
    required this.propertyId,
    required this.city,
    required this.area,
    this.subLocality,
    required this.pin,
    this.houseNo,
    this.latitude,
    this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      propertyId: json['property_id'],
      city: json['city'],
      area: json['area'],
      subLocality: json['sub_locality'],
      pin: json['pin']??0,
      houseNo: json['house_no'],
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "property_id": propertyId,
      "city": city,
      "area": area,
      "sub_locality": subLocality,
      "pin": pin,
      "house_no": houseNo,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}

class Feature {
  int id;
  int propertyId;
  int? bhk;
  int bedrooms;
  int bathrooms;
  int balconies;
  double carpetArea;
  double plotArea;
  double buildArea;
  double? pricePerSqFt;
  String? plotAreaUnit;
  String? buildAreaUnit;
  String? carpetAreaUnit;
  int noOfFloors;
  int propertyOnFloor;
  int isUnderConstruction;
  String? ownership;
  int isNegotiable;
  double? maintainanceAmount;
  double? bookingAmount;
  int ageOfProperty;
  int rentAmount;
  int electricityExcluded;
  int waterExcluded;
  String? availabilityDate;
  int? noOfSeats;
  int? noOfCabins;
  int? noOfMeetingRooms;
  int? noOfWashrooms;
  int? noOfConferenceRooms;
  int receptionArea;
  int parking;
  int furnishing;
  int centralAC;
  int oxygenDuct;
  int ups;
  int fireExtension;
  int fireSprinklers;
  int fireHose;
  int? noOfStaircases;
  int? noOfLifts;
  String? furnishedType;
  String? availableFor;
  String suitableFor;
  String? roomType;
  String? pgDGIncluded;
  String? pantry;
  int fireSensors;
  int isTaxAndChargesExcluded;
  int isAllInclusionPrice;
  double? plotLength;
  double? plotBreadth;
  String? typeOfWashroom;
  String? typeOfLand;
  double? roadFacingWidth;
  String? plotFacingDirection;
  String? typeOfStorage;
  String? typeOfRetailSpace;
  String? shopLocatedInside;
  String roomSharing;
  String? pgAmenities;
  String pgName;


  Feature({
    required this.id,
    required this.propertyId,
    this.bhk,
    required this.bedrooms,
    required this.bathrooms,
    required this.balconies,
    required this.carpetArea,
    required this.plotArea,
    required this.buildArea,
    this.pricePerSqFt,
    this.plotAreaUnit,
    this.buildAreaUnit,
    this.carpetAreaUnit,
    required this.noOfFloors,
    required this.propertyOnFloor,
    required this.isUnderConstruction,
    this.ownership,
    required this.isNegotiable,
    this.maintainanceAmount,
    this.bookingAmount,
    required this.ageOfProperty,
    required this.rentAmount,
    required this.electricityExcluded,
    required this.waterExcluded,
    this.availabilityDate,
    this.noOfSeats,
    this.noOfCabins,
    this.noOfMeetingRooms,
    this.noOfWashrooms,
    this.noOfConferenceRooms,
    required this.receptionArea,
    required this.parking,
    required this.furnishing,
    required this.centralAC,
    required this.oxygenDuct,
    required this.ups,
    required this.fireExtension,
    required this.fireSprinklers,
    required this.fireHose,
    this.noOfStaircases,
    this.noOfLifts,
    this.furnishedType,
    this.availableFor,
    required this.suitableFor,
    this.roomType,
    this.pgDGIncluded,
    this.pantry,
    required this.fireSensors,
    required this.isTaxAndChargesExcluded,
    required this.isAllInclusionPrice,
    this.plotLength,
    this.plotBreadth,
    this.typeOfWashroom,
    this.typeOfLand,
    this.roadFacingWidth,
    this.plotFacingDirection,
    this.typeOfStorage,
    this.typeOfRetailSpace,
    this.shopLocatedInside,
    required this.roomSharing,
    this.pgAmenities,
    required this.pgName,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      id: json['id'],
      propertyId: json['property_id'],
      bhk: json['bhk'],
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      balconies: json['balconies'] ?? 0,
      carpetArea: (json['carpet_area'] ?? 0).toDouble(),
      plotArea: (json['plot_area'] ?? 0).toDouble(),
      buildArea: (json['build_area'] ?? 0).toDouble(),
      pricePerSqFt: (json['price_per_square_ft'] != null) ? double.tryParse(json['price_per_square_ft'].toString()) : null,
      plotAreaUnit: json['plot_area_unit'],
      buildAreaUnit: json['build_area_unit'],
      carpetAreaUnit: json['carpet_area_unit'],
      noOfFloors: json['no_of_floors'] ?? 0,
      propertyOnFloor: int.tryParse(json['property_on_floor'].toString()) ?? 0,
      isUnderConstruction: json['is_under_construction'] ?? 0,
      ownership: json['ownership'],
      isNegotiable: json['is_negotiable'] ?? 0,
      maintainanceAmount: (json['maintainance_amount'] != null) ? double.tryParse(json['maintainance_amount'].toString()) : null,
      bookingAmount: (json['booking_amount'] != null) ? double.tryParse(json['booking_amount'].toString()) : null,
      ageOfProperty: json['age_of_property'] ?? 0,
      rentAmount: json['rent_amount'] ?? 0,
      electricityExcluded: json['electricity_excluded'] ?? 0,
      waterExcluded: json['water_excluded'] ?? 0,
      availabilityDate: json['availability_date'],
      noOfSeats: json['no_of_seats'],
      noOfCabins: json['no_of_cabins'],
      noOfMeetingRooms: json['no_of_meeting_rooms'],
      noOfWashrooms: json['no_of_washrooms'],
      noOfConferenceRooms: json['no_of_confrence_rooms'],
      receptionArea: json['reception_area'] ?? 0,
      parking: json['parking'] ?? 0,
      furnishing: json['furnishing'] ?? 0,
      centralAC: json['central_ac'] ?? 0,
      oxygenDuct: json['oxygen_duct'] ?? 0,
      ups: json['ups'] ?? 0,
      fireExtension: json['fire_extension'] ?? 0,
      fireSprinklers: json['fire_sprinklers'] ?? 0,
      fireHose: json['fire_hose'] ?? 0,
      noOfStaircases: json['no_of_staircases'],
      noOfLifts: json['no_of_lifts'],
      furnishedType: json['furnished_type'],
      availableFor: json['available_for'],
      suitableFor: json['suitable_for'] ?? '',
      roomType: json['room_type'],
      pgDGIncluded: json['pg_dg_included'],
      pantry: json['pantry'],
      fireSensors: json['fire_sensors'] ?? 0,
      isTaxAndChargesExcluded: json['is_tax_and_charges_excluded'] ?? 0,
      isAllInclusionPrice: json['is_all_inclusion_price'] ?? 0,
      plotLength: (json['plot_length'] != null) ? double.tryParse(json['plot_length'].toString()) : null,
      plotBreadth: (json['plot_breadth'] != null) ? double.tryParse(json['plot_breadth'].toString()) : null,
      typeOfWashroom: json['type_of_washroom'],
      typeOfLand: json['type_of_land'],
      roadFacingWidth: (json['road_facing_width'] != null) ? double.tryParse(json['road_facing_width'].toString()) : null,
      plotFacingDirection: json['plot_facing_direction'],
      typeOfStorage: json['type_of_storage'],
      typeOfRetailSpace: json['type_of_retail_space'],
      shopLocatedInside: json['shop_located_inside'],
      roomSharing: json['room_sharing'] ?? '',
      pgAmenities: json['pg_amenties'],
      pgName: json['pg_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "property_id": propertyId,
      "bhk": bhk,
      "bedrooms": bedrooms,
      "bathrooms": bathrooms,
      "balconies": balconies,
      "carpet_area": carpetArea,
      "plot_area": plotArea,
      "build_area": buildArea,
      "price_per_square_ft": pricePerSqFt,
      "plot_area_unit": plotAreaUnit,
      "build_area_unit": buildAreaUnit,
      "carpet_area_unit": carpetAreaUnit,
      "no_of_floors": noOfFloors,
      "property_on_floor": propertyOnFloor,
      "is_under_construction": isUnderConstruction,
      "ownership": ownership,
      "is_negotiable": isNegotiable,
      "maintainance_amount": maintainanceAmount,
      "booking_amount": bookingAmount,
      "age_of_property": ageOfProperty,
      "rent_amount": rentAmount,
      "electricity_excluded": electricityExcluded,
      "water_excluded": waterExcluded,
      "availability_date": availabilityDate,
      "no_of_seats": noOfSeats,
      "no_of_cabins": noOfCabins,
      "no_of_meeting_rooms": noOfMeetingRooms,
      "no_of_washrooms": noOfWashrooms,
      "no_of_confrence_rooms": noOfConferenceRooms,
      "reception_area": receptionArea,
      "parking": parking,
      "furnishing": furnishing,
      "central_ac": centralAC,
      "oxygen_duct": oxygenDuct,
      "ups": ups,
      "fire_extension": fireExtension,
      "fire_sprinklers": fireSprinklers,
      "fire_hose": fireHose,
      "no_of_staircases": noOfStaircases,
      "no_of_lifts": noOfLifts,
      "furnished_type": furnishedType,
      "available_for": availableFor,
      "suitable_for": suitableFor,
      "room_type": roomType,
      "pg_dg_included": pgDGIncluded,
      "pantry": pantry,
      "fire_sensors": fireSensors,
      "is_tax_and_charges_excluded": isTaxAndChargesExcluded,
      "is_all_inclusion_price": isAllInclusionPrice,
      "plot_length": plotLength,
      "plot_breadth": plotBreadth,
      "type_of_washroom": typeOfWashroom,
      "type_of_land": typeOfLand,
      "road_facing_width": roadFacingWidth,
      "plot_facing_direction": plotFacingDirection,
      "type_of_storage": typeOfStorage,
      "shop_located_inside":shopLocatedInside,
      "type_of_retail_space":typeOfRetailSpace,
      "room_sharing": roomSharing,
      "pg_amenties": pgAmenities,
      "pg_name": pgName,
    };
  }
}
