import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'general_custome_text_field_event.dart';
part 'general_custome_text_field_state.dart';

class GeneralCustomeTextFieldBloc
    extends Bloc<GeneralCustomeTextFieldEvent, GeneralCustomeTextFieldState> {
  GeneralCustomeTextFieldBloc() : super(GeneralCustomeTextFieldState()) {
    on<OnFocusChange>(onFocusChange);
    on<OnTextChange>(onTextChange);
    on<OnUpdateField>(onUpdateField);
  }

  FutureOr<void> onFocusChange(
      OnFocusChange event, Emitter<GeneralCustomeTextFieldState> emit) {
    if (state.countInit > 0) {
      emit(state.copyWith(countInit: 0));
    }
    emit(state.copyWith(isFocused: event.isFocused));
  }

  FutureOr<void> onTextChange(
      OnTextChange event, Emitter<GeneralCustomeTextFieldState> emit) {
    String error = '';

    if (event.value.isEmpty && state.countInit >= 1) {
      error = 'kolom tidak boleh kosong';
    }

    int sumCountInit = state.countInit + 1;
    
    emit(state.copyWith(
        isEmpty: event.isEmpty,
        fieldValue: event.value,
        errorMessage: error,
        countInit: sumCountInit));
  }

  FutureOr<void> onUpdateField(
      OnUpdateField event, Emitter<GeneralCustomeTextFieldState> emit) {
    final newController = TextEditingController(text: event.value);
    emit(state.copyWith(controller: newController));
  }
}
