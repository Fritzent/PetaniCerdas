part of 'calendar_bloc.dart';

class CalendarState {
  final bool isLoading;
  final String? errorMessage;
  final bool isEmpty;
  final DateTime selectedDate;
  final List<DateTime> timeSlots;
  final Map<String, List<Schedule>> groupedScheduleTasks;


  CalendarState({
    this.isLoading = false,
    DateTime? selectedDate,
    this.errorMessage,
    this.isEmpty = false,
    this.timeSlots = const  [],
    this.groupedScheduleTasks = const {},
  }) : selectedDate = selectedDate ?? DateTime.now();

  List<DateTime> get dateList => List.generate(
      7, (index) => selectedDate.subtract(Duration(days: 3 - index)));

  CalendarState copyWith ({
    bool? isLoading,
    String? errorMessage,
    bool? isEmpty,
    DateTime? selectedDate,
    List<DateTime>? timeSlots,
    Map<String, List<Schedule>>? groupedScheduleTasks,
  }) {
    return CalendarState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isEmpty: isEmpty ?? this.isEmpty,
      selectedDate: selectedDate ?? this.selectedDate,
      timeSlots: timeSlots ?? this.timeSlots,
      groupedScheduleTasks: groupedScheduleTasks ?? this.groupedScheduleTasks,
    );
  }
}
