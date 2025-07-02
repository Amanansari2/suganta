import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tytil_realty/routes/app_routes.dart';
import 'package:tytil_realty/views/splash/splash_view.dart';

import 'api_service/internet_status.dart';
import 'configs/app_string.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppString.appName,
      defaultTransition: Transition.fadeIn,
      debugShowCheckedModeBanner: false,
      home: SplashView(),
      //home: const Scaffold(backgroundColor: AppColor.primaryColor, body: Center(child: CircularProgressIndicator(color: Colors.white,),),),
      getPages: AppRoutes.pages,
      builder: (context, child){
        return Stack(
          children: [
            child!,
            const InternetStatusWidget()
          ],
        );
      },

    );
  }
}

// class MainLayout extends StatelessWidget{
//   const MainLayout({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//
//         children: [
//           GetMaterialApp(
//             debugShowCheckedModeBanner: false,
//             getPages: AppRoutes.pages,
//             home: SplashView(),
//           ),
//           Positioned(
//               top:0 ,
//               left: 0,
//               right: 0,
//               child: InternetStatusWidget()),
//
//         ],
//     );
//   }
// }