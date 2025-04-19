class BalanceHistoryModel {
  BalanceHistoryModel({this.transactions, this.balance});

  BalanceHistoryModel.fromJson(dynamic json) {
    if (json['transactions'] != null) {
      transactions = [];
      json['transactions'].forEach((v) {
        transactions?.add(Transactions.fromJson(v));
      });
    }
    balance = json['balance'];
  }

  List<Transactions>? transactions;
  num? balance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (transactions != null) {
      map['transactions'] = transactions?.map((v) => v.toJson()).toList();
    }
    map['balance'] = balance;
    return map;
  }
}

class Transactions {
  Transactions({
    this.id,
    this.userId,
    this.astrologerId,
    this.amount,
    this.transactionId,
    this.transactionType,
    this.debitType,
    this.creditType,
    this.serviceReferenceId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Transactions.fromJson(dynamic json) {
    id = json['_id'];
    userId = json['user_id'];
    astrologerId = json['astrologer_id'];
    amount = json['amount'];
    transactionId = json['transaction_id'];
    transactionType = json['transaction_type'];
    debitType = json['debit_type'];
    creditType = json['credit_type'];
    serviceReferenceId = json['service_reference_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  String? id;
  String? userId;
  dynamic astrologerId;
  num? amount;
  String? transactionId;
  String? transactionType;
  String? debitType;
  dynamic creditType;
  String? serviceReferenceId;
  String? createdAt;
  String? updatedAt;
  num? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['user_id'] = userId;
    map['astrologer_id'] = astrologerId;
    map['amount'] = amount;
    map['transaction_id'] = transactionId;
    map['transaction_type'] = transactionType;
    map['debit_type'] = debitType;
    map['credit_type'] = creditType;
    map['service_reference_id'] = serviceReferenceId;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }
}
