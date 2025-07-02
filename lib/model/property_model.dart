class PropertyModel {
  final String message;
  final int status;
  final PaginationData pagination;
  final List<BuyProperty> properties;

  PropertyModel({
    required this.message,
    required this.status,
    required this.pagination,
    required this.properties,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      message: json["message"] ?? "",
      status: json["status"] ?? 0,
      pagination: PaginationData.fromJson(json["data"] ?? {}),
      properties: (json["data"] != null && json["data"]["data"] != null)
          ? (json["data"]["data"] as List)
          .map((e) => BuyProperty.fromJson(e))
          .toList()
          : [],
    );
  }
}

//   factory PropertyModel.fromJson(Map<String, dynamic> json) {
//     final innerData = json["data"];
//     final actualData = innerData["data"];
//
//     return PropertyModel(
//       message: json["message"] ?? "",
//       status: json["status"] ?? 0,
//       pagination: PaginationData.fromJson(actualData ?? {}),
//       properties: (actualData["data"] != null)
//           ? (actualData["data"] as List)
//           .map((e) => BuyProperty.fromJson(e))
//           .toList()
//           : [],
//     );
//   }
//
// }


class PaginationData {
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final String? firstPageUrl;
  final String? lastPageUrl;
  final String? path;
  final int? from;
  final int? to;
  final List<PaginationLink> links;

  PaginationData({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
    this.nextPageUrl,
    this.prevPageUrl,
    this.firstPageUrl,
    this.lastPageUrl,
    this.path,
    this.from,
    this.to,
    required this.links,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
        currentPage: json["current_page"] ?? 1,
        lastPage: json["last_page"] ?? 1,
        total: json["total"] ?? 0,
        perPage: json["per_page"] ?? 10,
        nextPageUrl: json["next_page_url"],
        prevPageUrl: json["prev_page_url"],
        firstPageUrl: json["first_page_url"],
        lastPageUrl: json["last_page_url"],
        path: json["path"],
        from: json["from"],
        to: json["to"],
        links: (json["links"] as List? ?? [])
            .map((e) => PaginationLink.fromJson(e))
            .toList()
    );
  }
}

class PaginationLink {
  final String? url;
  final String label;
  final bool active;

  PaginationLink({
    this.url,
    required this.label,
    required this.active,
  });

  factory PaginationLink.fromJson(Map<String, dynamic> json) {
    return PaginationLink(
      url: json["url"],
      label: json["label"] ?? "",
      active: json["active"] ?? false,
    );
  }
}

class BuyProperty {
  final int id;
  final String slug;
  final String description;
  final String wantTo;
  final String type;
  final String updatedAt;
  final String createdAt;
  final int userRoleId;
  final int userRole;
  final PropertyImage? firstImage;
  final PropertyAddress address;
  final PropertyFeature feature;
  final UserInfo user;
  final int? typeOptionsId; // New field
  final List<PropertyImage> images; // New field
  final TypeOption? typeOption; // New field

  BuyProperty({
    required this.id,
    required this.slug,
    required this.description,
    required this.wantTo,
    required this.type,
    required this.updatedAt,
    required this.createdAt,
    required this.userRoleId,
    required this.userRole,
    this.firstImage,
    required this.address,
    required this.feature,
    required this.user,
    this.typeOptionsId,/////
    required this.images,////
    this.typeOption,////
  });

  factory BuyProperty.fromJson(Map<String, dynamic> json) {
    return BuyProperty(
      id: json["id"] ?? 0,
      slug: json["slug"] ?? "",
      description: json["description"]??"",
      wantTo: json["want_to"] ?? "SELL",
      type: json["type"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      createdAt: json["created_at"] ?? "",
      userRoleId: json["user_role_id"] ?? 0,
      userRole: json["user_role"] ?? 0,
      firstImage: json["first_image"] != null
          ? PropertyImage.fromJson(json["first_image"])
          : null,
      address: PropertyAddress.fromJson(json["address"] ?? {}),
      feature: PropertyFeature.fromJson(json["feature"] ?? {}),
      user: UserInfo.fromJson(json["user"] ?? {}),
      typeOptionsId: json["type_options_id"],
      images: (json["images"] as List? ?? [])
          .map((e) => PropertyImage.fromJson(e))
          .toList(), // New field
      typeOption: json["type_option"] != null
          ? TypeOption.fromJson(json["type_option"])
          : null, // New field

    );
  }
}

class TypeOption {
  final int id;
  final String option;

  TypeOption({
    required this.id,
    required this.option,
  });

  factory TypeOption.fromJson(Map<String, dynamic> json) {
    return TypeOption(
      id: json["id"] ?? 0,
      option: json["option"] ?? "",
    );
  }
}

class PropertyImage {
  final int id;
  final int propertyId;
  final String imageUrl;

  PropertyImage({
    required this.id,
    required this.propertyId,
    required this.imageUrl,
  });

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      id: json["id"] ?? 0,
      propertyId: json["property_id"] ?? 0,
      imageUrl: json["image"] ?? "",
    );
  }
}

class PropertyAddress {
  final int id;
  final int propertyId;
  final String city;
  final String area;
  final String? subLocality;
  final String? latitude; // New field
  final String? longitude; // New field
  final int pinCode;

  PropertyAddress({
    required this.id,
    required this.propertyId,
    required this.city,
    required this.area,
    this.subLocality,
    this.latitude,
    this.longitude,
    required this.pinCode
  });

  factory PropertyAddress.fromJson(Map<String, dynamic> json) {
    return PropertyAddress(
      id: json["id"] ?? 0,
      propertyId: json["property_id"] ?? 0,
      city: json["city"] ?? "",
      area: json["area"] ?? "",
      subLocality: json["sub_locality"],
      latitude: json["latitude"], // New field
      longitude: json["longitude"], // New field
      pinCode : int.tryParse(json["pin"].toString()) ?? 0,
    );
  }
}

// class PropertyFeature {
//   final int id;
//   final int propertyId;
//   final int bhk;
//   final int bedrooms;
//   final int bathrooms;
//   final int balconies;
//   final int carpetArea;
//   final int plotArea;
//   final int buildArea;
//   final String plotAreaUnit;
//   final String buildAreaUnit;
//   final String carpetAreaUnit;
//   final int pricePerSquareFt;
//   final int noOfFloors;
//   final String propertyOnFloor;
//   final int isUnderConstruction;
//   final String ownership;
//   final int isNegotiable;
//   final int rentAmount;
//   final bool electricityExcluded;
//   final bool waterExcluded;
//   final String availabilityDate;
//   final int parking;
//   final String furnishedType;
//   final int noOfLifts;
//   final int noOfStaircases;
//
//   PropertyFeature({
//     required this.id,
//     required this.propertyId,
//     required this.bhk,
//     required this.bedrooms,
//     required this.bathrooms,
//     required this.balconies,
//     required this.carpetArea,
//     required this.plotArea,
//     required this.buildArea,
//     required this.plotAreaUnit,
//     required this.buildAreaUnit,
//     required this.carpetAreaUnit,
//     required this.pricePerSquareFt,
//     required this.noOfFloors,
//     required this.propertyOnFloor,
//     required this.isUnderConstruction,
//     required this.ownership,
//     required this.isNegotiable,
//     required this.rentAmount,
//     required this.electricityExcluded,
//     required this.waterExcluded,
//     required this.availabilityDate,
//     required this.parking,
//     required this.furnishedType,
//     required this.noOfLifts,
//     required this.noOfStaircases,
//   });
//
//   factory PropertyFeature.fromJson(Map<String, dynamic> json) {
//     return PropertyFeature(
//       id: json["id"] ?? 0,
//       propertyId: json["property_id"] ?? 0,
//       bhk: json["bhk"] ?? 0,
//       bedrooms: json["bedrooms"] ?? 0,
//       bathrooms: json["bathrooms"] ?? 0,
//       balconies: json["balconies"] ?? 0,
//       carpetArea: json["carpet_area"] ?? 0,
//       plotArea: json["plot_area"] ?? 0,
//       buildArea: json["build_area"] ?? 0,
//       plotAreaUnit: json["plot_area_unit"] ?? "sq. ft.",
//       buildAreaUnit: json["build_area_unit"] ?? "sq. ft.",
//       carpetAreaUnit: json["carpet_area_unit"] ?? "sq. ft.",
//       pricePerSquareFt: json["price_per_square_ft"] ?? 0,
//       noOfFloors: json["no_of_floors"] ?? 0,
//       propertyOnFloor: json["property_on_floor"] ?? "",
//       isUnderConstruction: json["is_under_construction"] ?? 0,
//       ownership: json["ownership"] ?? "",
//       isNegotiable: json["is_negotiable"] ?? 0,
//       rentAmount: json["rent_amount"] ?? 0,
//       electricityExcluded: json["electricity_excluded"] == 1,
//       waterExcluded: json["water_excluded"] == 1,
//       availabilityDate: json["availability_date"] ?? "",
//       parking: json["parking"] ?? 0,
//       furnishedType: json["furnished_type"] ?? "UNFURNISHED",
//       noOfLifts: json["no_of_lifts"] ?? 0,
//       noOfStaircases: json["no_of_staircases"] ?? 0,
//     );
//   }
// }

class PropertyFeature {
  final int id;
  final int propertyId;
  final int bhk;
  final int bedrooms;
  final int? bathrooms;
  final int? balconies;
  final int carpetArea;
  final int plotArea;
  final int buildArea;
  final String plotAreaUnit;
  final String buildAreaUnit;
  final String carpetAreaUnit;
  final int pricePerSquareFt;
  final int noOfFloors;
  final String propertyOnFloor;
  final int? isUnderConstruction;
  final String ownership;
  final int isNegotiable;
  final int? maintainanceAmount;
  final int? bookingAmount;
  final int? ageOfProperty;
  final int? rentAmount;
  final bool electricityExcluded;
  final bool waterExcluded;
  final String? availabilityDate;
  final int? noOfSeats;
  final int? noOfCabins;
  final int? noOfMeetingRooms;
  final int? noOfWashrooms;
  final int noOfConferenceRooms;
  final int receptionArea;
  final int parking;
  final int furnishing;
  final bool centralAc;
  final bool oxygenDuct;
  final bool ups;
  final bool fireExtension;
  final bool fireSprinklers;
  final bool fireHose;
  final int noOfStaircases;
  final int noOfLifts;
  final String? furnishedType;
  final String? availableFor;
  final String? suitableFor;
  final String? roomType;
  final bool pgDgIncluded;
  final String? pantry;
  final bool fireSensors;
  final bool isTaxAndChargesExcluded;
  final bool isAllInclusionPrice;
  final String? plotLength;
  final String? plotBreadth;
  final String? typeOfWashroom;
  final String? typeOfLand;
  final int roadFacingWidth;
  final String? plotFacingDirection;
  final String? typeOfStorage;
  final String? roomSharing;
  final String? pgAmenties;


  PropertyFeature({
    required this.id,
    required this.propertyId,
    required this.bhk,
    required this.bedrooms,
    this.bathrooms,
    this.balconies,
    required this.carpetArea,
    required this.plotArea,
    required this.buildArea,
    required this.plotAreaUnit,
    required this.buildAreaUnit,
    required this.carpetAreaUnit,
    required this.pricePerSquareFt,
    required this.noOfFloors,
    required this.propertyOnFloor,
    this.isUnderConstruction,
    required this.ownership,
    required this.isNegotiable,
    this.maintainanceAmount,
    this.bookingAmount,
    this.ageOfProperty,
    this.rentAmount,
    required this.electricityExcluded,
    required this.waterExcluded,
    this.availabilityDate,
    this.noOfSeats,
    this.noOfCabins,
    this.noOfMeetingRooms,
    this.noOfWashrooms,
    required this.noOfConferenceRooms,
    required this.receptionArea,
    required this.parking,
    required this.furnishing,
    required this.centralAc,
    required this.oxygenDuct,
    required this.ups,
    required this.fireExtension,
    required this.fireSprinklers,
    required this.fireHose,
    required this.noOfStaircases,
    required this.noOfLifts,
    this.furnishedType,
    this.availableFor,
    this.suitableFor,
    this.roomType,
    required this.pgDgIncluded,
    this.pantry,
    required this.fireSensors,
    required this.isTaxAndChargesExcluded,
    required this.isAllInclusionPrice,
    this.plotLength,
    this.plotBreadth,
    this.typeOfWashroom,
    this.typeOfLand,
    required this.roadFacingWidth,
    this.plotFacingDirection,
    this.typeOfStorage,
    this.roomSharing,
    this.pgAmenties,
  });

  factory PropertyFeature.fromJson(Map<String, dynamic> json) {
    return PropertyFeature(
      id: json["id"] ?? 0,
      propertyId: json["property_id"] ?? 0,
      bhk: json["bhk"] ?? 0,
      bedrooms: json["bedrooms"] ?? 0,
      bathrooms: json["bathrooms"],
      balconies: json["balconies"],
      carpetArea: json["carpet_area"] ?? 0,
      plotArea: json["plot_area"] ?? 0,
      buildArea: json["build_area"] ?? 0,
      plotAreaUnit: json["plot_area_unit"] ?? "sq. ft.",
      buildAreaUnit: json["build_area_unit"] ?? "sq. ft.",
      carpetAreaUnit: json["carpet_area_unit"] ?? "sq. ft.",
      pricePerSquareFt: json["price_per_square_ft"] ?? 0,
      noOfFloors: json["no_of_floors"] ?? 0,
      propertyOnFloor: json["property_on_floor"] ?? "",
      isUnderConstruction: json["is_under_construction"],
      ownership: json["ownership"] ?? "",
      isNegotiable: json["is_negotiable"] ?? 0,
      maintainanceAmount: json["maintainance_amount"],
      bookingAmount: json["booking_amount"],
      ageOfProperty: json["age_of_property"],
      rentAmount: json["rent_amount"],
      electricityExcluded: json["electricity_excluded"] == 1,
      waterExcluded: json["water_excluded"] == 1,
      availabilityDate: json["availability_date"],
      noOfSeats: json["no_of_seats"],
      noOfCabins: json["no_of_cabins"],
      noOfMeetingRooms: json["no_of_meeting_rooms"],
      noOfWashrooms: json["no_of_washrooms"],
      noOfConferenceRooms: json["no_of_confrence_rooms"] ?? 0,
      receptionArea: json["reception_area"] ?? 0,
      parking: json["parking"] ?? 0,
      furnishing: json["furnishing"] ?? 0,
      centralAc: json["central_ac"] == 1,
      oxygenDuct: json["oxygen_duct"] == 1,
      ups: json["ups"] == 1,
      fireExtension: json["fire_extension"] == 1,
      fireSprinklers: json["fire_sprinklers"] == 1,
      fireHose: json["fire_hose"] == 1,
      noOfStaircases: json["no_of_staircases"] ?? 0,
      noOfLifts: json["no_of_lifts"] ?? 0,
      furnishedType: json["furnished_type"]??  "UNFURNISHED",
      availableFor: json["available_for"],
      suitableFor: json["suitable_for"],
      roomType: json["room_type"],
      pgDgIncluded: json["pg_dg_included"] == 1,
      pantry: json["pantry"],
      fireSensors: json["fire_sensors"] == 1,
      isTaxAndChargesExcluded: json["is_tax_and_charges_excluded"] == 1,
      isAllInclusionPrice: json["is_all_inclusion_price"] == 1,
      plotLength: json["plot_length"],
      plotBreadth: json["plot_breadth"],
      typeOfWashroom: json["type_of_washroom"],
      typeOfLand: json["type_of_land"],
      roadFacingWidth: json["road_facing_width"] ?? 0,
      plotFacingDirection: json["plot_facing_direction"],
      typeOfStorage: json["type_of_storage"],
      roomSharing: json["room_sharing"],
      pgAmenties: json["pg_amenties"],
    );
  }
}

class UserInfo {
  final int id;
  final String name;
  final String email;
  final String phone;



  UserInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      email: json["email"] ?? "No email available",
      phone: json["phone"] ?? "No phone available",
    );
  }
}
