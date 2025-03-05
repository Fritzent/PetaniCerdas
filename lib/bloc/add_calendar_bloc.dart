import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petani_cerdas/models/schedule.dart';
import 'package:petani_cerdas/repository/user_service.dart';
import 'package:uuid/uuid.dart';

part 'add_calendar_event.dart';
part 'add_calendar_state.dart';

class AddCalendarBloc extends Bloc<AddCalendarEvent, AddCalendarState> {
  final UserService userService;
  AddCalendarBloc({required this.userService}) : super(AddCalendarState()) {
    on<OnSubmitNewCalendar>(onSubmitNewCalendar);
  }

  FutureOr<void> onSubmitNewCalendar(
      OnSubmitNewCalendar event, Emitter<AddCalendarState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      var uuid = Uuid();
      String generateCalendarId = uuid.v4();

      CollectionReference calendar = FirebaseFirestore.instance.collection('Schedule');
      String userId = await userService.getUserData();

      await calendar.add({
        'kalendar_id' : generateCalendarId,
        'schedule_date' : event.newCalendar.scheduleDate,
        'schedule_end_time' : event.newCalendar.scheduleEndTime,
        'schedule_name' : event.newCalendar.scheduleName,
        'schedule_note' : event.newCalendar.scheduleNote,
        'schedule_start_time' : event.newCalendar.scheduleStartTime,
        'user_id' : userId
      });

      emit(state.copyWith(isLoading: false, isSuccesAdd: true, errorMessagePush: ''));

    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isError: true, errorMessagePush: e.toString()));
    }
  }
}
