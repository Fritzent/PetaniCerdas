import 'package:intl/intl.dart';

import '../models/transaction.dart';

Map<String, List<Transactions>> groupTransactionsByMonth(List<Transactions> transactions) {
  Map<String, List<Transactions>> grouped = {};

  for (var transaction in transactions) {
    String month = DateFormat.yMMMM().format(transaction.date);
    if (!grouped.containsKey(month)) {
      grouped[month] = [];
    }
    grouped[month]!.add(transaction);
  }

  return grouped;
}