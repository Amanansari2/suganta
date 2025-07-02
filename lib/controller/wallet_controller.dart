import 'package:get/get.dart';
import '../api_service/print_logger.dart';
import '../model/wallet_model.dart';
import '../repository/wallet_repo.dart';

class WalletController extends GetxController {
  final WalletRepository _walletRepository = WalletRepository();

  Rxn<WalletModel> walletData = Rxn<WalletModel>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWalletDetails();
  }

  Future<void> fetchWalletDetails() async {


    isLoading.value = true;
    final data = await _walletRepository.getWalletDetail();
    AppLogger.log("All tx: ${data?.transactions.length}");
    AppLogger.log("Credits: ${data?.transactions.where((t) => t.type == 1).length}");
    AppLogger.log("Debits: ${data?.transactions.where((t) => t.type == 2).length}");
    if (data != null) {
      walletData.value = data;
    }
    isLoading.value = false;
  }

  List<WalletTransaction> get allTransactions =>
      walletData.value?.transactions ?? [];

  List<WalletTransaction> get creditTransactions =>
      walletData.value?.transactions
          .where((t) => t.type == 1)
          .toList() ??
          [];


  List<WalletTransaction> get debitTransactions =>
      walletData.value?.transactions
          .where((t) => t.type == 2 || t.type == 3 || t.type == 4)
          .toList() ??
          [];




}
