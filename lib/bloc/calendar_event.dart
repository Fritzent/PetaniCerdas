part of 'calendar_bloc.dart';

@immutable
sealed class CalendarEvent {}

class InitialCalendar extends CalendarEvent{}

class SelectedDate extends CalendarEvent{
  final DateTime dateTime;

  SelectedDate(this.dateTime);
}

class FetchScheduleTask extends CalendarEvent{
  final DateTime dateTime;

  FetchScheduleTask(this.dateTime);
}

class EmitScheduleData extends CalendarEvent {
  final Map<String, List<Schedule>> groupedSheduleTasks;
  EmitScheduleData(this.groupedSheduleTasks);
}

