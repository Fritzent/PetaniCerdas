import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Transactions {
  final String transactionId;
  final String transactionName;
  final int totalPrice;
  final String type;
  final String userId;
  final DateTime date;
  final String transactionNote;

  Transactions({
    required this.transactionId,
    required this.transactionName,
    required this.totalPrice,
    required this.type,
    required this.userId,
    required this.date,
    this.transactionNote = '',
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'transaction_id' : transactionId,
      'transaction_name' : transactionName,
      'transaction_total_price' : totalPrice,
      'transaction_type' : type,
      'user_id' : userId,
      'transaction_date' : date,
      'transaction_note' : transactionNote,
    };
  }

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions (
      transactionId: json['transaction_id'] as String,
      transactionName: json['transaction_name'] as String,
      totalPrice: json['transaction_total_price'] as int,
      type : json['transaction_type'] as String,
      userId : json['user_id'] as String,
      date : (json['transaction_date'] as Timestamp).toDate(),
      transactionNote: json['transaction_note'] as String,
    );
  }
}


class TransactionType {
  final String name;
  final Color colorPrimary;
  final Color secondaryColor;
  
  TransactionType(
    this.name,
    this.colorPrimary,
    this.secondaryColor
  );
}