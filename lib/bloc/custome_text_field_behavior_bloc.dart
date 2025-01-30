import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petani_cerdas/bloc/pin_input_behavior_bloc.dart';

part 'custome_text_field_behavior_event.dart';
part 'custome_text_field_behavior_state.dart';

class CustomeTextFieldBehaviorBloc
    extends Bloc<CustomeTextFieldBehaviorEvent, CustomeTextFieldBehaviorState> {
  final PinInputBehaviorBloc? pinInputBehaviorBloc;
  final int? index;

  CustomeTextFieldBehaviorBloc({this.pinInputBehaviorBloc, this.index})
      : super(CustomeTextFieldBehaviorState(false, true, false, '', '')) {
    pinInputBehaviorBloc?.stream.listen((pinInputState) {
      if (pinInputState.progress == 'Add' ||
          pinInputState.progress == 'Remove') {
        if (pinInputState.currentIndex - 1 == index! - 1) {
          add(OnCustomeTextFieldFocusChange(true));
        } else {
          add(OnCustomeTextFieldFocusChange(false));
        }
      }
    });

    on<OnCustomeTextFieldFocusChange>(customeTextFieldFocusChange);
    on<OnCustomeTextFieldTextChange>(customeTextFieldTextChange);
    on<OnCustomeTextFieldTextError>(customeTextFieldTextError);
  }

  FutureOr<void> customeTextFieldFocusChange(event, emit) {
    emit(CustomeTextFieldBehaviorState(event.isFocused, state.isEmpty,
        state.isError, state.errorMessageName, state.errorMessagePhone));
  }

  FutureOr<void> customeTextFieldTextChange(event, emit) {
    emit(CustomeTextFieldBehaviorState(state.isFocused, event.isEmpty,
        state.isError, state.errorMessageName, state.errorMessagePhone));
  }

  FutureOr<void> customeTextFieldTextError(event, emit) {
    emit(CustomeTextFieldBehaviorState(state.isFocused, state.isEmpty,
        event.isError, event.errorMessageName, event.errorMessagePhone));
  }
}
