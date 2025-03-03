import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:petani_cerdas/models/schedule.dart';
import 'package:petani_cerdas/repository/user_service.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final UserService userService;

  CalendarBloc({required this.userService}) : super(CalendarState()) {
    on<InitialCalendar>(onInitialCalendar);
    on<SelectedDate>(onSelectedDate);
    on<FetchScheduleTask>(onFetchScheduleTask);
    on<EmitScheduleData>(onEmitScheduleData);
  }

  FutureOr<void> onInitialCalendar(
      InitialCalendar event, Emitter<CalendarState> emit) {
    DateTime now = DateTime.now();
    int currentHour = now.hour;

    List<DateTime> updatedTimeSlots = List<DateTime>.from(state.timeSlots);

    if (state.selectedDate.day != now.day) {
      currentHour = 1;
      updatedTimeSlots.clear();
    }

    for (int hour = currentHour; hour <= 24; hour++) {
      updatedTimeSlots.add(DateTime(now.year, now.month, now.day, hour));
    }

    emit(state.copyWith(timeSlots: updatedTimeSlots));

    add(FetchScheduleTask(now));
  }

  FutureOr<void> onSelectedDate(
      SelectedDate event, Emitter<CalendarState> emit) {
    DateTime now = DateTime.now();
    int currentHour = now.hour;

    List<DateTime> updatedTimeSlots = [];

    for (int hour = currentHour; hour <= 24; hour++) {
      updatedTimeSlots.add(DateTime(now.year, now.month, now.day, hour));
    }

    emit(state.copyWith(
        selectedDate: event.dateTime, timeSlots: updatedTimeSlots));

    if (event.dateTime.day != now.day) {
      add(InitialCalendar());
    }
    
    add(FetchScheduleTask(event.dateTime));
  }

  FutureOr<void> onFetchScheduleTask(
      FetchScheduleTask event, Emitter<CalendarState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      String userId = await userService.getUserData();
      List<Schedule> data = [];

      DateTime startOfDay = DateTime(
          event.dateTime.year, event.dateTime.month, event.dateTime.day);
      DateTime endOfDay = startOfDay.add(Duration(days: 1));

      FirebaseFirestore.instance
          .collection('Schedule')
          .where('user_id', isEqualTo: userId)
          .where('schedule_date', isGreaterThanOrEqualTo: startOfDay)
          .where('schedule_date', isLessThan: endOfDay)
          .orderBy('schedule_date', descending: true)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        data = snapshot.docs.map((doc) {
          return Schedule.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();

        Map<String, List<Schedule>> groupedSheduleTasks = {};
        for (var schedule in data) {
          String hour = DateFormat('HH:mm a').format(schedule.scheduleDate);
          if (!groupedSheduleTasks.containsKey(hour)) {
            groupedSheduleTasks[hour] = [];
          }
          groupedSheduleTasks[hour]!.add(schedule);
        }

        add(EmitScheduleData(groupedSheduleTasks));
      });
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(),
          isLoading: false,
          isEmpty: false,
          groupedScheduleTasks: {}));
    }
  }

  void onEmitScheduleData(EmitScheduleData event, Emitter<CalendarState> emit) {
    emit(state.copyWith(
        groupedScheduleTasks: event.groupedSheduleTasks,
        isLoading: false,
        isEmpty: false));
  }
}
