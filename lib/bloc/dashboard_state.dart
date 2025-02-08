part of 'dashboard_bloc.dart';

class DashboardState {
  final bool isLoadingLoadLatestTransaction;
  final List<Transactions> listLatestTransaction;
  final String errorMessageLoadLatestTransaction;
  final bool isEmpty;
  final bool isEmptySchedule;
  final Schedule todaySchedule;
  final bool isLoadingLoadTodaySchedule;
  final String errorMessageLoadTodaySchedule;

  DashboardState({
    this.isLoadingLoadLatestTransaction = false,
    List<Transactions>? listLatestTransaction,
    this.errorMessageLoadLatestTransaction = '',
    this.isEmpty = false,
    this.isEmptySchedule = false,
    Schedule? todaySchedule,
    this.isLoadingLoadTodaySchedule = false,
    this.errorMessageLoadTodaySchedule = '',
  })  : listLatestTransaction = listLatestTransaction ?? List.empty(),
        todaySchedule = todaySchedule ??
            Schedule(
                calendarId: '',
                scheduleDate: '',
                scheduleEndTime: DateTime.now(),
                scheduleName: '',
                scheduleNote: '',
                scheduleStartTime: DateTime.now(),
                userId: '');

  DashboardState copyWith({
    bool? isLoadingLoadLatestTransaction,
    List<Transactions>? listLatestTransaction,
    String? errorMessageLoadLatestTransaction,
    bool? isEmpty,
    bool? isEmptySchedule,
    Schedule? todaySchedule,
    bool? isLoadingLoadTodaySchedule,
    String? errorMessageLoadTodaySchedule,
  }) {
    return DashboardState(
        isLoadingLoadLatestTransaction: isLoadingLoadLatestTransaction ??
            this.isLoadingLoadLatestTransaction,
        listLatestTransaction:
            listLatestTransaction ?? this.listLatestTransaction,
        errorMessageLoadLatestTransaction: errorMessageLoadLatestTransaction ??
            this.errorMessageLoadLatestTransaction,
        isEmpty: isEmpty ?? this.isEmpty,
        isEmptySchedule: isEmptySchedule ?? this.isEmptySchedule,
        todaySchedule: todaySchedule ?? this.todaySchedule,
        isLoadingLoadTodaySchedule:
            isLoadingLoadTodaySchedule ?? this.isLoadingLoadTodaySchedule,
        errorMessageLoadTodaySchedule: errorMessageLoadTodaySchedule ??
            this.errorMessageLoadTodaySchedule);
  }
}
