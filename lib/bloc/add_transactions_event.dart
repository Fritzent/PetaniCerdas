part of 'add_transactions_bloc.dart';

@immutable
sealed class AddTransactionsEvent {}

class OnUpdateTransactionName extends AddTransactionsEvent {
  final String nameTransaction;

  OnUpdateTransactionName(this.nameTransaction);
}

class OnUpdateTransactionNote extends AddTransactionsEvent {
  final String noteTransaction;

  OnUpdateTransactionNote(this.noteTransaction);
}

class OnUpdateTransactionDateField extends AddTransactionsEvent {
  final String dateTimeValue;
  OnUpdateTransactionDateField(this.dateTimeValue);
}

class OnUpdateTransactionDate extends AddTransactionsEvent {
  final DateTime dateTransaction;

  OnUpdateTransactionDate(this.dateTransaction);
}

class OnFocusChange extends AddTransactionsEvent {
  final bool isFocused;

  OnFocusChange(this.isFocused);
}

class OnTextChange extends AddTransactionsEvent {
  final bool isEmpty;

  OnTextChange(this.isEmpty);
}

class OnUpdateTransactionDetail extends AddTransactionsEvent {
  final DetailTransaction detailTransaction;

  OnUpdateTransactionDetail(this.detailTransaction);
}

class OnUpdateTransactionSectionError extends AddTransactionsEvent {
  final bool isError;
  final String errorText;

  OnUpdateTransactionSectionError(this.isError, this.errorText);
}

class OnAddDetailSection extends AddTransactionsEvent {}

class OnRemoveDetailSection extends AddTransactionsEvent {
  final int index;

  OnRemoveDetailSection(this.index);
}

class OnUpdateDetailTransactionDropDownType extends AddTransactionsEvent {
  final int index;
  final String type;

  OnUpdateDetailTransactionDropDownType(
      {required this.index, required this.type});
}

class OnUpdateDetailTransactionName extends AddTransactionsEvent {
  final int index;
  final String value;

  OnUpdateDetailTransactionName({required this.index, required this.value});
}

class OnUpdateDetailTransactionPrice extends AddTransactionsEvent {
  final int index;
  final String value;

  OnUpdateDetailTransactionPrice({required this.index, required this.value});
}

class OnSubmitAddTransactions extends AddTransactionsEvent {
  final String nameTransaction;
  final String noteTransaction;
  final DateTime dateTimeValue;
  final List<DetailTransaction> listDetailTransaction;

  OnSubmitAddTransactions({
    required this.nameTransaction,
    required this.noteTransaction,
    required this.dateTimeValue,
    required this.listDetailTransaction
  });
}
