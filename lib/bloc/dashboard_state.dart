part of 'dashboard_bloc.dart';

class DashboardState {
  final bool isLoadingLoadLatestTransaction;
  final List<Transactions> listLatestTransaction;
  final String errorMessageLoadLatestTransaction;
  final bool isEmpty;

  DashboardState({
    this.isLoadingLoadLatestTransaction = false,
    List<Transactions>? listLatestTransaction,
    this.errorMessageLoadLatestTransaction = '',
    this.isEmpty = false,
  }) : listLatestTransaction = listLatestTransaction ?? List.empty();
}
