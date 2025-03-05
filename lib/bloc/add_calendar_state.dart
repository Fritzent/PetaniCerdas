part of 'add_calendar_bloc.dart';

class AddCalendarState {
  final bool isLoading;
  final String errorMessagePush;
  final bool isSuccesAdd;
  final String calendarName;
  final String calendarNote;
  final DateTime? calendarDate;
  final String calendarDateHour;
  final String errorText;
  final bool isError;
  AddCalendarState({
    this.isLoading= false,
    this.errorMessagePush = '',
    this.isSuccesAdd = false,
    this.calendarName = '',
    this.calendarNote = '',
    this.calendarDate,
    this.calendarDateHour = '',
    this.errorText = '',
    this.isError = false,
  });

  AddCalendarState copyWith({
    bool? isLoading,
    String? errorMessagePush,
    bool? isSuccesAdd,
    String? calendarName,
    String? calendarNote,
    DateTime? calendarDate,
    String? calendarDateHour,
    String? errorText,
    bool? isError,
  }) {
    return AddCalendarState (
      isLoading: isLoading ?? this.isLoading,
      errorMessagePush: errorMessagePush ?? this.errorMessagePush,
      isSuccesAdd: isSuccesAdd ?? this.isSuccesAdd,
      calendarName: calendarName ?? this.calendarName,
      calendarNote: calendarNote ?? this.calendarNote,
      calendarDate: calendarDate ?? this.calendarDate,
      calendarDateHour: calendarDateHour ?? this.calendarDateHour,
      errorText: errorText ?? this.errorText,
      isError: isError ?? this.isError,
    );
  }
}