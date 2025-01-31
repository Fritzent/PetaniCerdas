part of 'transactions_bloc.dart';

class TransactionsState {
  final bool isLoading;
  final String? errorMessage;
  final Map<String, List<Transactions>> groupedTransactions;
  final bool hasNewUpdate;
  final List<DetailTransaction> listDetailTransaction;

  TransactionsState({
    this.isLoading = false,
    this.errorMessage,
    this.groupedTransactions = const {},
    this.hasNewUpdate = false,
    List<DetailTransaction>? listDetailTransaction,
  }) : listDetailTransaction = listDetailTransaction ??
            [
              DetailTransaction(
                name: '',
                type: '',
                price: '',
                transactionId: '',
                transactionDetailId: '',
              )
            ];
}
