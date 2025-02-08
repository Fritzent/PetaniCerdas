part of 'dashboard_bloc.dart';

@immutable 
sealed class DashboardEvent {}

class OnGetLatestTransaction extends DashboardEvent {
}

class OnGetTodaySchedule extends DashboardEvent {

}

class OnEmitLatestTransaction extends DashboardEvent {
  final List<Transactions> list;
  OnEmitLatestTransaction(this.list);
}

class OnEmitTodaySchedule extends DashboardEvent {
  final Schedule todaySchedule;
  OnEmitTodaySchedule(this.todaySchedule);
}
