

class ProjectModel{
  final String message;
  final int status;
  final ProjectPaginationData projectPagination;
  final List<ProjectPostModel> project;
  
  ProjectModel({
   required this.message,
   required this.status,
   required this.projectPagination,
   required this.project 
});
  
  factory ProjectModel.fromJson(Map<String, dynamic> json){
    return ProjectModel(
        message: json["message"], 
        status: json["status"],
        projectPagination: ProjectPaginationData.fromJson(json["data"]??{}),
        project: (json["data"]!= null && json["data"]["data"]!= null)
    ? (json["data"]["data"]as List)
    .map((e)=> ProjectPostModel.fromJson(e)).toList():[]);
  }
}


class ProjectPaginationData {
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
  final List<ProjectPostPaginationLink> links;

  ProjectPaginationData({
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

  factory ProjectPaginationData.fromJson(Map<String, dynamic> json) {
    return ProjectPaginationData(
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
            .map((e) => ProjectPostPaginationLink.fromJson(e))
            .toList()
    );
  }
}

class ProjectPostPaginationLink {
  final String? url;
  final String label;
  final bool active;

  ProjectPostPaginationLink({
    this.url,
    required this.label,
    required this.active,
  });

  factory ProjectPostPaginationLink.fromJson(Map<String, dynamic> json) {
    return ProjectPostPaginationLink(
      url: json["url"],
      label: json["label"] ?? "",
      active: json["active"] ?? false,
    );
  }
}

class ProjectPostModel {
  final int id;
  final int userId;
  final int? projectLogId;
  final String slug;
  final String project;
  final String projectName;
  final String? reraRegister;
  final String? reraStatus;
  final String projectType;
  final String? area;
  final String city;
  final int zipCode;
  final String? country;
  final String? possessionDate;
  final String? projectStatus;
  final String? possessionStatus;
  final String? totalArea;
  final String? developmentStage;
  final String? zoningStatus;
  final String? permitStatus;
  final int? totalTowers;
  final int? totalFloors;
  final int? noOfConferenceRoom;
  final int? noOfSeats;
  final String amenities;
  final String? noOfBhk;
  final int? noOfBedroom;
  final String? environmentalClearance;
  final int? noOfBathroom;
  final int? parkingSpace;
  final int? noOfBalcony;
  final String? projectDescription;
  final String? totalUnit;
  final String? projectSize;
  final String? superArea;
  final String? lift;
  final String? facing;
  final String developerName;
  final String developerPhNo1;
  final String? developerPhNo2;
  final String developerEmail1;
  final String? developerEmail2;
  final String? contactPersonNo;
  final String? contactPersonEmail;
  final String? paymentSchedule;
  final int? propertyTaxAnnual;
  final int? maintenanceFees;
  final String? additionalFees;
  final String priceRange;
  final int? accupancyRate;
  final int? annualRentalIncome;
  final int? currentValuation;
  final int status;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final int createdBy;
  final int updatedBy;
  final String contactPerson;
  final List<ProjectImageModel> projectImages;

  ProjectPostModel({
    required this.id,
    required this.userId,
    required this.projectLogId,
    required this.slug,
    required this.project,
    required this.projectName,
    this.reraRegister,
    this.reraStatus,
    required this.projectType,
    this.area,
    required this.city,
    required this.zipCode,
    this.country,
    this.possessionDate,
    this.projectStatus,
    this.possessionStatus,
    this.totalArea,
    this.developmentStage,
    this.zoningStatus,
    this.permitStatus,
    this.totalTowers,
    this.totalFloors,
    this.noOfConferenceRoom,
    this.noOfSeats,
    required this.amenities,
    this.noOfBhk,
    this.noOfBedroom,
    this.environmentalClearance,
    this.noOfBathroom,
    this.parkingSpace,
    this.noOfBalcony,
    this.projectDescription,
    this.totalUnit,
    this.projectSize,
    this.superArea,
    this.lift,
    this.facing,
    required this.developerName,
    required this.developerPhNo1,
    this.developerPhNo2,
    required this.developerEmail1,
    this.developerEmail2,
    this.contactPersonNo,
    this.contactPersonEmail,
    this.paymentSchedule,
    this.propertyTaxAnnual,
    this.maintenanceFees,
    this.additionalFees,
    required this.priceRange,
    this.accupancyRate,
    this.annualRentalIncome,
    this.currentValuation,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.contactPerson,
    required this.projectImages,
  });




  factory ProjectPostModel.fromJson(Map<String, dynamic> json) {
    return ProjectPostModel(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? 0,
      projectLogId: json["project_log_id"],
      slug: json["slug"] ?? "",
      project: json["project"] ?? "",
      projectName: json["project_name"] ?? "",
      reraRegister: json["rera_register"],
      reraStatus: json["rera_status"],
      projectType: json["project_type"] ?? "",
      area: json["area"],
      city: json["city"] ?? "",
      zipCode: json["zip_code"] ?? 0,
      country: json["country"],
      possessionDate: json["Possession_date"],
      projectStatus: json["project_status"],
      possessionStatus: json["Possession_status"],
      totalArea: json["total_area"],
      developmentStage: json["development_stage"],
      zoningStatus: json["zoning_status"],
      permitStatus: json["permit_status"],
      totalTowers: json["total_towers"],
      totalFloors: json["total_floors"],
      noOfConferenceRoom: json["no_of_conferenceRoom"],
      noOfSeats: json["no_of_seats"],
      amenities: json["amenities"] ?? "",
      noOfBhk: json["no_of_bhk"],
      noOfBedroom: json["no_of_bedroom"],
      environmentalClearance: json["environmental_clearance"],
      noOfBathroom: json["no_of_bathroom"],
      parkingSpace: json["parking_space"],
      noOfBalcony: json["no_of_balcony"],
      projectDescription: json["project_description"],
      totalUnit: json["total_unit"],
      projectSize: json["project_size"],
      superArea: json["super_area"],
      lift: json["lift"],
      facing: json["facing"],
      developerName: json["developer_name"] ?? "",
      developerPhNo1: json["developer_ph_no1"] ?? "",
      developerPhNo2: json["developer_ph_no2"],
      developerEmail1: json["developer_email1"] ?? "",
      developerEmail2: json["developer_email2"],
      contactPersonNo: json["contact_person_no"],
      contactPersonEmail: json["contact_person_email"],
      paymentSchedule: json["payment_schedule"],
      propertyTaxAnnual: json["property_tax_annual"],
      maintenanceFees: json["maintenance_fees"],
      additionalFees: json["additional_fees"],
      priceRange: json["price_range"] ?? "",
      accupancyRate: json["accupancy_rate"],
      annualRentalIncome: json["annual_rental_income"],
      currentValuation: json["current_valuation"],
      status: json["status"] ?? 0,
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      deletedAt: json["deleted_at"],
      createdBy: json["created_by"] ?? 0,
      updatedBy: json["updated_by"] ?? 0,
      contactPerson: json["contact_person"] ?? "",
      projectImages: (json["project_images"] as List? ?? [])
          .map((e) => ProjectImageModel.fromJson(e))
          .toList(),
    );
  }
}

class ProjectImageModel {
  final int id;
  final String images;
  final int projectId;
  final int userId;

  ProjectImageModel({
    required this.id,
    required this.images,
    required this.projectId,
    required this.userId,
  });

  factory ProjectImageModel.fromJson(Map<String, dynamic> json) {
    return ProjectImageModel(
      id: json["id"] ?? 0,
      images: json["images"] ?? "",
      projectId: json["project_id"] ?? 0,
      userId: json["user_id"] ?? 0,
    );
  }
}
