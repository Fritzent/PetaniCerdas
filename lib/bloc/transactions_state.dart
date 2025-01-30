part of 'transactions_bloc.dart';

class TransactionsState {
  final bool isLoading;
  final String? errorMessage;
  final Map<String, List<Transactions>> groupedTransactions;
  final bool hasNewUpdate;

  TransactionsState({
    this.isLoading = false,
    this.errorMessage,
    this.groupedTransactions = const {},
    this.hasNewUpdate = false,
  });
}
