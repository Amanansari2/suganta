import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../api_service/get_service.dart';
import '../api_service/post_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';
import '../model/map_model.dart';
import '../model/project_dropdown_model.dart';

class AddressRepository {

  final PostService postService = Get.find<PostService>();


  Future<MapModel?> fetchMapData( int propertyId) async {
    final response = await postService.postRequest(
        url: propertyMapDataUrl,
        body: {'property_id': propertyId},
    requiresAuth: false
    ) ;

    AppLogger.log("Map Data Raw response $response");

    if(response['success'] == true){
      return MapModel.fromJson(response['data']);
    }
    return null;
  }


  // Future<String> getAddressFromCoordinates(double latitude,
  //     double longitude) async {
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //         latitude, longitude);
  //     if (placemarks.isNotEmpty) {
  //       Placemark place = placemarks.first;
  //       return "${place.street}, ${place.locality}, ${place
  //           .administrativeArea}, ${place.country}";
  //     }
  //   } catch (e) {
  //     AppLogger.log("Error fetching address: $e");
  //   }
  //   return "Address not found";
  // }


  Future<MapModel?> fetchProjectMapData(int projectId) async {
    final response = await postService.postRequest(
        url: projectMapDataUrl,
        body: {"project_id": projectId},
    requiresAuth: false
    );

    AppLogger.log("Project Map Data Response -->> $response");
    if(response["success"] == true){
      return MapModel.fromJson(response["data"]);

    }
    return null;
  }


  Future<Map<String, dynamic>> submitSimilarPropertySlug({
    required String slug,
    int page = 1,
  }) async {
    final urlWithPage = "$similarPropertiesUrl?page=$page";
    AppLogger.log("Slug Pagination URl: $urlWithPage");
    Map<String, dynamic> body = {
      "slug": slug,};
    final response = await postService.postRequest(
        url: urlWithPage,
        body: body,
        requiresAuth: false);
    AppLogger.log("Slug Pagination API Response: $response");

    if (response["success"] == true) {
      return {
        "success": true,
        "data": response["data"],};
    } else {
      return {
        "success": false,
        "message": response["message"] ?? "Failed to load similar properties",};
    }
  }
  

  Future<Map<String, dynamic>> submitSimilarProjectSlug({
    required String slug,
    int page = 1,
}) async{
    final urlWithPage = "$similarProjectsUrl?page=$page";
    AppLogger.log("Project Slug Pagination Url -->> $urlWithPage ");
    
    Map<String, dynamic> body ={
      "slug": slug
    };
    final response = await postService.postRequest(
        url: urlWithPage, body: body, requiresAuth: false);
    AppLogger.log("Project Slug raw Response -->> $response");
    if(response["success"] == true){
      return{
        "success": true,
        "data":response["data"]
      };
    }else{
      return {
        "success":false,
        "message":response["message"] ?? "Failed to load similar properties"
      };
    }
  }




  
  Future<Map<String,dynamic>> fetchStatusList() async {
    try {
      final response = await GetService.getRequest(
          url: getDetailSectionProjectDropDownUrl,
          requiresAuth: false
      );

      AppLogger.log("Status APi Response -->>> $response");

      if(response["success"] == true){
        final statusModel = StatusResponseModel.fromJson(response);

        return{
          "success":true,
          "data":statusModel
        };
      }else{
        return{
          "success":false,
          "message":response["message"] ?? "failed to load Status data"
        };
      }
    }catch(e){
      return {
        "success": false,
        "message": "Exception: $e",
      };
    }
  }

  Future<Map<String,dynamic>> fetchAmenitiesList() async{
    try{
      final response = await GetService.getRequest(
          url: getDetailSectionProjectAmenitiesUrl,
      requiresAuth: false);
      AppLogger.log("Status Amenities Api Response $response");
      if(response["success"] == true){
        final amenitiesModel = AmenitiesResponseModel.fromJson(response);
        return{
          "success":true,
          "data": amenitiesModel
        };
      }else{
        return{
          "success":false,
          "message":response["message"] ?? "failed to load Status data"
        };
      }
    }catch(e){
      return {
        "success": false,
        "message": "Exception: $e",
      };
    }
  }
}
