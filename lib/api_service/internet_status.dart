// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:suganta_international/api_service/internet_conectivity.dart';
// import 'package:suganta_international/common/custom_dialog.dart';
// import 'package:suganta_international/configs/app_color.dart';
//
// class InternetStatusWidget extends StatefulWidget {
//   const InternetStatusWidget({super.key});
//
//   @override
//   State<InternetStatusWidget> createState() => _InternetStatusWidgetState();
// }
//
// class _InternetStatusWidgetState extends State<InternetStatusWidget> {
//
//     ConnectivityResult _connectionStatus = ConnectivityResult.none;
//   bool _isDialogShown = false;
//
//   BuildContext? _dialogContext;
//
// // @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //     InternetConnectivity.connectivityStream.listen((ConnectivityResult result){
// //      if(mounted){
// //        setState(() {
// //          _connectionStatus = result;
// //        });
// //      }
// //
// //     });
// //   }
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     InternetConnectivity.connectivityStream.listen((ConnectivityResult result){
//       if(mounted){
//         setState(() {
//           _connectionStatus = result;
//         });
//         if(_connectionStatus == ConnectivityResult.none && !_isDialogShown){
//           _isDialogShown = true;
//
//           WidgetsBinding.instance.addPostFrameCallback((_){
//             _showInternetDialog();
//           });
//         } else if(_connectionStatus != ConnectivityResult.none){
//           _closeDialog();
//         }
//       }
//     });
//   }
//
//   void _showInternetDialog(){
//     showDialog(context: context,
//         builder: (BuildContext dialogContext) {
//           _dialogContext = dialogContext;
//           return CustomDialog(
//               title: "No Internet",
//               description: "description", buttonText: "buttonText",
//           onConfirm: (){
//                 _closeDialog();
//           },
//           );
//         }
//     );
//   }
//
//  void _closeDialog(){
//     if(_isDialogShown && _dialogContext != null){
//       _isDialogShown = false;
//       Navigator.of(_dialogContext!, rootNavigator: true).pop();
//       _dialogContext = null;
//     }
//  }
//   @override
//   Widget build(BuildContext context) {
//
//     // return Visibility(
//     //     visible: _connectionStatus == ConnectivityResult.none,
//     //     child: CustomDialog(
//     //         title: "No Internet",
//     //         description: "You are not connected to the Internet. Please check your connection!",
//     //         buttonText: "Ok",
//     //     onConfirm: (){
//     //           Navigator.of(context).pop();
//     //           _isDialogShown = false;
//     //     },
//     //     ));
//
//     return SizedBox();
//   }
// }
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/custom_dialog.dart';
import 'internet_conectivity.dart';

class InternetStatusWidget extends StatefulWidget {
  const InternetStatusWidget({super.key});

  @override
  State<InternetStatusWidget> createState() => _InternetStatusWidgetState();
}

class _InternetStatusWidgetState extends State<InternetStatusWidget> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  bool _isDialogShown = false;

  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startListening();
    });
  }

  void _startListening() {
    InternetConnectivity.connectivityStream.listen((ConnectivityResult result) {
      if (!mounted || Get.context == null) return;

      setState(() {
        _connectionStatus = result;
      });

      if (_connectionStatus == ConnectivityResult.none) {
        if (!_isDialogShown) {
          _isDialogShown = true;
          _showNoInternetDialog();
        }
      } else {
        _closeDialog();
      }
    });
  }

  void _showNoInternetDialog() {
    if (!mounted || Get.context == null) return;

    Future.delayed(Duration.zero, () {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return CustomDialog(
            title: "No Internet",
            description: "You are not connected to the Internet. Please check your connection!",
            buttonText: "Ok",

            onConfirm: () {
              _isDialogShown = false;
              _closeDialog();
            },
            image: "assets/icons/warning.png",
          );
        },
      );
    });
  }

  void _closeDialog() {
    if (_isDialogShown) {
      _isDialogShown = false;
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
