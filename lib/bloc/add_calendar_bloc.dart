import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_calendar_event.dart';
part 'add_calendar_state.dart';

class AddCalendarBloc extends Bloc<AddCalendarEvent, AddCalendarState> {
  AddCalendarBloc() : super(AddCalendarState());
}
