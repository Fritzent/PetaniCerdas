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
  final bool isFocused;
  final bool isError;
  final bool isEmpty;
  final TextEditingController controller;
  final FocusNode? focusNode;

  AddCalendarState({
    this.isLoading= false,
    this.errorMessagePush = '',
    this.isSuccesAdd = false,
    this.calendarName = '',
    this.calendarNote = '',
    this.calendarDate,
    this.calendarDateHour = '',
    this.errorText = '',
    this.isFocused = false,
    this.isError = false,
    this.isEmpty = false,
    TextEditingController? controller,
    this.focusNode,
  }) : controller =  controller ?? TextEditingController(
    text: calendarNote.isEmpty ? '' : calendarNote
  );

  AddCalendarState copyWith({
    bool? isLoading,
    String? errorMessagePush,
    bool? isSuccesAdd,
    String? calendarName,
    String? calendarNote,
    DateTime? calendarDate,
    String? calendarDateHour,
    String? errorText,
    bool? isFocused,
    bool? isError,
    bool? isEmpty,
    TextEditingController? controller,
    FocusNode? focusNode
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
      isFocused: isFocused ?? this.isFocused,
      isError: isError ?? this.isError,
      isEmpty: isEmpty ?? this.isEmpty,
      controller: controller ?? this.controller,
      focusNode: focusNode ??  this.focusNode,
    );
  }
}