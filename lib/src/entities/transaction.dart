class Transaction {
  Transaction({
    required this.transactionId,
    required this.amount,
    required this.currency,
  });

  final String transactionId;
  final double amount;
  final String currency;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'transactionId': transactionId,
        'amount': amount,
        'currency': currency.toUpperCase(),
      };
}
