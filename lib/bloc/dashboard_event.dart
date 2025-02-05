part of 'dashboard_bloc.dart';

@immutable 
sealed class DashboardEvent {}

class OnGetLatestTransaction extends DashboardEvent {
}

class OnEmitLatestTransaction extends DashboardEvent {
  final List<Transactions> list;
  OnEmitLatestTransaction(this.list);
}
