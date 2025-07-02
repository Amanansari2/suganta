import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tytil_realty/repository/address_repo.dart';
import 'package:tytil_realty/repository/buy_property_repo.dart';
import 'package:tytil_realty/repository/commercial_property_repo.dart';
import 'package:tytil_realty/repository/pg_property_repo.dart';
import 'package:tytil_realty/repository/plot_property_repo.dart';
import 'package:tytil_realty/repository/project_property_repo.dart';
import 'package:tytil_realty/repository/rent_property_repository.dart';
import 'package:tytil_realty/repository/residental_property_repo.dart';
import 'package:tytil_realty/repository/wishlist_repo.dart';

import 'api_service/delete_service.dart';
import 'api_service/get_service.dart';
import 'api_service/post_service.dart';
import 'app.dart';
import 'controller/buy_property_controller.dart';
import 'controller/commercial_property_controller.dart';
import 'controller/fetch_city_list_controller.dart';
import 'controller/fetch_state_list_controller.dart';
import 'controller/pg_property_controller.dart';
import 'controller/plot_Property_controller.dart';
import 'controller/project_property_controller.dart';
import 'controller/rent_property_controller.dart';
import 'controller/residential_property_controller.dart';
import 'controller/wishlist_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(GetService(), permanent: true);
  Get.put(PostService(), permanent: true);
  Get.put(DeleteService(), permanent: true);
  Get.put(AddressRepository());
  Get.put(WishlistRepository());
  Get.put(WishlistController());
  Get.lazyPut(() => BuyPropertyRepository(), fenix: true);
  Get.lazyPut(() => BuyPropertyController(), fenix: true);
  Get.lazyPut(() => RentPropertyRepository(), fenix: true);
  Get.lazyPut(() => RentPropertyController(), fenix: true);
  Get.lazyPut(() => PGPropertyRepository(), fenix: true);
  Get.lazyPut(() => PGPropertyController(), fenix: true);
  Get.lazyPut(() => PlotPropertyRepository(), fenix: true);
  Get.lazyPut(() => PlotPropertyController(), fenix: true);
  Get.lazyPut(() => CommercialPropertyRepository(), fenix: true);
  Get.lazyPut(() => CommercialPropertyController(), fenix: true);
  Get.lazyPut(() => ResidentialPropertyRepository(), fenix: true);
  Get.lazyPut(() => ResidentialPropertyController(), fenix: true);
  Get.lazyPut(()=> ProjectPropertyRepository(), fenix: true);
  Get.lazyPut(()=> ProjectPropertyController(), fenix: true);




  runApp(const MyApp());


  Future.delayed(const Duration(milliseconds: 2000), () async {
    final cityList = CityList();
    await cityList.loadCity();
    Get.put<CityList>(cityList);
  });

  Future.delayed(const Duration(milliseconds: 2000), () async {
    final stateList = StateList();
    await stateList.loadState();
    Get.put<StateList>(stateList);
  });


}


