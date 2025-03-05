part of 'add_calendar_bloc.dart';

@immutable
sealed class AddCalendarEvent {}

class OnSubmitNewCalendar extends AddCalendarEvent {
  final Schedule newCalendar;

  OnSubmitNewCalendar(this.newCalendar);
}
