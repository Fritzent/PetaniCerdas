part of 'transactions_bloc.dart';

abstract class TransactionsEvent {}

class FetchTransaction extends TransactionsEvent {
  FetchTransaction();
}

class SelectedSortBottomSheet extends TransactionsEvent {
  final String? sortBy;
  final String? sortWay;

  SelectedSortBottomSheet({this.sortBy, this.sortWay});
}

class SortTransactionName extends TransactionsEvent {
  final String? sortWay;

  SortTransactionName({this.sortWay});
}

class SortByTotalTransaction extends TransactionsEvent {
  final String? sortWay;

  SortByTotalTransaction({this.sortWay});
}

class SortByDate extends TransactionsEvent {
  final String? sortWay;

  SortByDate({this.sortWay});
}

class SortByType extends TransactionsEvent {
  final String? sortWay;

  SortByType({this.sortWay});
}

class EmitTransactionData extends TransactionsEvent {
  final Map<String, List<Transactions>> groupedTransactionsData;
  EmitTransactionData(this.groupedTransactionsData);
}
