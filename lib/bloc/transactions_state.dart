part of 'transactions_bloc.dart';

class TransactionsState {
  final bool isLoading;
  final String? errorMessage;
  final Map<String, List<Transactions>> groupedTransactions;
  final bool hasNewUpdate;
  final List<DetailTransaction> listDetailTransaction;
  final DocumentSnapshot? lastDocument;

  TransactionsState({
    this.isLoading = false,
    this.errorMessage,
    this.groupedTransactions = const {},
    this.hasNewUpdate = false,
    List<DetailTransaction>? listDetailTransaction,
    this.lastDocument,
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

  TransactionsState copyWith({
    bool? isLoading,
    String? errorMessage,
    Map<String, List<Transactions>>? groupedTransactions,
    bool? hasNewUpdate,
    List<DetailTransaction>? listDetailTransaction,
    DocumentSnapshot? lastDocument,
  }) {
    return TransactionsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      groupedTransactions: groupedTransactions ?? this.groupedTransactions,
      hasNewUpdate: hasNewUpdate ?? this.hasNewUpdate,
      listDetailTransaction:
          listDetailTransaction ?? this.listDetailTransaction,
      lastDocument: lastDocument ?? this.lastDocument,
    );
  }
}
