import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../configs/app_color.dart';
import '../../configs/app_size.dart';
import '../../configs/app_string.dart';
import '../../configs/app_style.dart';
import '../../controller/wallet_controller.dart';
import '../../gen/assets.gen.dart';
import '../../model/wallet_model.dart';

class WalletView extends StatefulWidget {
   WalletView({super.key});


  @override
  State<WalletView> createState() => _WalletViewState();
}


class _WalletViewState extends State<WalletView> {
  final WalletController walletController = Get.put(WalletController());

  @override
  void initState() {
    super.initState();
    walletController.fetchWalletDetails();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: buildAppBar(),
      body: buildWallet(context),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.whiteColor,
      scrolledUnderElevation: AppSize.appSize0,
      leading: Padding(
        padding: const EdgeInsets.only(left: AppSize.appSize16),
        child: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Image.asset(
            Assets.images.backArrow.path,
          ),
        ),
      ),
      leadingWidth: AppSize.appSize40,
      title: Text(
        AppString.wallet,
        style: AppStyle.heading4Medium(color: AppColor.textColor),
      ),
    );
  }

  Widget buildWallet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSize.appSize20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withOpacity(0.5),
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/myImg/coin.png",
                      width: 40,
                      height: 30,
                    ),
                    const SizedBox(width: 10),
                    Obx (
                      ()=> Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                           walletController.walletData.value?.amount.toString() ?? "0",
                            style: AppStyle.heading2(color: AppColor.black),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Total Coins",
                            style: AppStyle.heading5Regular(
                                color: AppColor.textColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  FontAwesomeIcons.wallet,
                  size: 50,
                  color: AppColor.primaryColor,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(),
          DefaultTabController(
            length: 3,
            child: Expanded(
              child: Column(
                children: [
                  const TabBar(
                      indicatorColor: AppColor.primaryColor,
                      labelColor: AppColor.primaryColor,
                      unselectedLabelColor: AppColor.textColor,
                      tabs: [
                        Tab(text: "All Transaction"),
                        Tab(text: "Credit"),
                        Tab(text: "Debits"),
                      ]),
                  const SizedBox(height: 10),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Obx(() => buildTransactionList(walletController.allTransactions, AppColor.textColor, tabType: "all")),
                        Obx(() => buildTransactionList(walletController.creditTransactions, Colors.green, tabType: "credit")),
                        Obx(() =>  buildTransactionList(walletController.debitTransactions, AppColor.primaryColor, tabType: "debit")),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget buildTransactionList(List<WalletTransaction> transactions, Color color,  {String tabType = "all"}) {
    if (transactions.isEmpty) {
      return const Center(child: Text("No transactions found."));
    }

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final isCredit = tx.type == 1;
        final isDebit = tx.type == 2 || tx.type == 3 || tx.type == 4;
        Color txColor = color;
        if (tabType == "all") {
          txColor = isCredit ? Colors.green : isDebit ? AppColor.primaryColor : AppColor.textColor;
        }


        return buildTransactionItem(
          context,
          coins: tx.amount.toString(),
          text: isCredit
              ? "Credited To Your Wallet "
              :  tx.type == 2
              ? "Used For Listing "
              : tx.type == 3
              ? "Used For Contact Property Owner "
              : tx.type == 4
              ? "Used For Contact Project Owner "
              : "Transaction",
          // expireDate:  tabType == "credit"
          //     ? "Expire On ${tx.expiryDate}"
          //     : tabType == "debit"
          //     ? "On ${tx.createdAt}"
          //     : tx.type == 1
          //     ? "Expire On ${tx.expiryDate}"
          //     : tx.type == 2
          //     ? "On ${tx.createdAt}"
          //     : "", // fallback
          expireDate:  isCredit
              ? "Expire On ${tx.expiryDate}"
              : "On ${tx.createdAt}",
          color: txColor,
          showExpiry: true,
        );
      },
    );
  }


  Widget buildTransactionItem(
    BuildContext context, {
    required String coins,
    required String text,
    String? expireDate,
    required Color color,
    bool showExpiry = true,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_box, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$coins Coins ",
                    style: AppStyle.heading5SemiBold(color: color),
                  ),
                  TextSpan(
                    text: text,
                    style: AppStyle.heading5Regular(color: color),
                  ),
                  if (showExpiry && expireDate != null && expireDate.isNotEmpty)
                  TextSpan(
                    text:  "$expireDate",
                    style: AppStyle.heading5Regular(color: color),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
