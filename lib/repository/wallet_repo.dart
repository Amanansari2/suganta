import 'package:tytil_realty/api_service/get_service.dart';
import 'package:tytil_realty/api_service/print_logger.dart';

import '../api_service/url.dart';
import '../model/wallet_model.dart';

class WalletRepository{


  Future<WalletModel?>  getWalletDetail() async {
    final response = await GetService.getRequest(
        url: getWalletDetailsUrl,
        requiresAuth: true
    );

    AppLogger.log("Wallet Details -->> $response");

    if (response["success"] == true && response["data"] != null) {
      return WalletModel.fromJson(response["data"]);
    } else {
      return null;
    }
  }
}