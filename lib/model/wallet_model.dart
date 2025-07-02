class WalletModel {
  final int amount;
  final List<WalletTransaction> transactions;

  WalletModel({required this.amount, required this.transactions});

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      amount: json["wallet_amount"] ?? 0,
      transactions:  (json["transaction"] as List<dynamic>? ?? [])
          .map((e) => WalletTransaction.fromJson(e))
          .toList(),
    );
  }
}

class WalletTransaction {
  final int type;
  final int amount;
  final String createdAt;
  final String? expiryDate;

  WalletTransaction({
    required this.type,
    required this.amount,
    required this.createdAt,
     this.expiryDate,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      type: json["type"] ?? 0,
      amount: json["amount"] ?? 0,
      createdAt: json["created_at"] ?? "",
      expiryDate: json["expiry_date"] ?? "",
    );
  }
}
