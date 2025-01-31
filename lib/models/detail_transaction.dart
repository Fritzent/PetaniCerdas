class DetailTransaction {
  final String name;
  final String type;
  final String price;
  final String transactionDetailId;
  String transactionId;

  DetailTransaction({
    required this.name,
    required this.type,
    required this.price,
    required this.transactionId,
    required this.transactionDetailId,
  });

  DetailTransaction copyWith({
    String? name,
    String? type,
    String? price,
    String? transactionDetailId,
    String? transactionId,
  }) {
    return DetailTransaction(
      name: name ?? this.name,
      type: type ?? this.type,
      price: price ?? this.price,
      transactionId: transactionId ?? this.transactionId,
      transactionDetailId: transactionDetailId ?? this.transactionDetailId,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'transaction_id': transactionId,
      'transaction_detail_id': transactionDetailId,
      'detail_transaction_type': type,
      'detail_transaction_price': double.tryParse(price),
      'detail_transaction_name': name,
    };
  }

  factory DetailTransaction.fromJson(Map<String, dynamic> json) {
    return DetailTransaction(
      transactionId: json['transaction_id'] as String,
      transactionDetailId: json['transaction_detail_id'] as String,
      type: json['detail_transaction_type'] as String,
      price: json['detail_transaction_price'] as String,
      name: json['detail_transaction_name'] as String,
    );
  }
}
