import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../api_service/get_service.dart';
import '../api_service/post_service.dart';
import '../api_service/url.dart';


class HomeYourListingRepository {
  final PostService postService = Get.find<PostService>();
  // Future<Map<String, dynamic>> fetchProjectDropDownList() async{
  //   final response = await GetService.getRequest(
  //       url: getProjectDropDownUrl,
  //       requiresAuth: true);
  //   debugPrint("raw DropDown list -->>> $response");
  //   if(response["success"]==true){
  //     return{
  //       "success":true,
  //       "data":response["data"]?["data"]
  //
  //     };
  //
  //   }else{
  //     return{
  //       "success":false,
  //       "message": response["data"]?["message"]
  //     };
  //   }
  // }

  Future<Map<String, dynamic>> fetchPostPropertyListing() async {

    final response = await GetService.getRequest(
        url: getPostPropertyListUrl,
        requiresAuth: true

    );

    if (response is Map) {
      response.forEach((key, value) {
      });
    }
    if (response["success"] == true) {

      if (response["data"] != null && response["data"]["data"] != null) {
      } else {
      }

      return {
        "success": true,
        "data": response["data"]["data"],
      };
    } else {


      return {
        "success": false,
        "message": response["message"]
      };
    }
  }

  Future<Map<String,dynamic>> fetchPostProjectListing({int page = 1}) async{
    final fetchPostProjectFullUrl = "$getPostProjectListUrl?page = $page";
  final response = await GetService.getRequest(
      url: fetchPostProjectFullUrl,
  requiresAuth: true
  );
  if(response["success"]==true){
    return{
      "success":true,
      "data":response["data"]
    };
  }else{
    return{
      "success":false,
      "message":response["message"]
    };
  }
  }

}