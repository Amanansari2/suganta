import 'package:get/get.dart';

import '../api_service/get_service.dart';
import '../api_service/print_logger.dart';
import '../api_service/url.dart';
import '../model/city_model.dart';

class CityList extends GetxController{

List<City> cityList = [];

  Future<Map<String, dynamic>> fetchCityList() async {
    final response = await GetService.getRequest(
      url: getCityListUrl,
      requiresAuth: false,
    );

    // print("🔍 API Full Response: $response");

    if (response["success"] == true && response["data"] != null) {
      if (response["data"].containsKey("data") && response["data"]["data"] != null) {
        return {
          "success": true,
          "data": response["data"]["data"],
        };
      } else {
        AppLogger.log("⚠️ Warning: 'city' key not found in API response.");
        return {
          "success": false,
          "message": "City data not available.",
        };
      }
    } else {
      AppLogger.log("❌ API Error: ${response["message"] ?? "Unknown error"}");
      return {
        "success": false,
        "message": response["message"] ?? "Unable to fetch city list",
      };
    }
  }


Future<void> loadCity() async {

  if(cityList.isNotEmpty) return;

  try{
    final url = getCityListUrl;
    final response = await fetchCityList();

    if(response["success"]==true && response["data"] != null){
      List<dynamic> data = response["data"];
      cityList = data.map((e)=> City.fromJson(e)).toList();
      AppLogger.log("CIty List loaded once with ${cityList.length} cities");
    }else{
      AppLogger.log("Failed to Load Cities ${response["message"]}");
    }
  }catch(e){
    AppLogger.log("CityList error  -->> $e");
  }
}
}