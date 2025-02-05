part of 'dashboard_bloc.dart';

class DashboardState {
  final bool isLoadingLoadLatestTransaction;
  final List<Transactions> listLatestTransaction;
  final String errorMessageLoadLatestTransaction;

  DashboardState({
    this.isLoadingLoadLatestTransaction = false,
    List<Transactions>? listLatestTransaction,
    this.errorMessageLoadLatestTransaction = '',
  }) : listLatestTransaction = listLatestTransaction ?? List.empty();
}
