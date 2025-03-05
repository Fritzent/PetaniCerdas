part of 'general_custome_text_field_bloc.dart';

class GeneralCustomeTextFieldState {
  final bool isFocused;
  final bool isEmpty;
  final String errorMessage;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String fieldValue;
  final int countInit;

  GeneralCustomeTextFieldState({
    this.isFocused = false,
    this.isEmpty = false,
    this.errorMessage = '',
    FocusNode? focusNode,
    TextEditingController? controller,
    this.fieldValue = '',
    this.countInit = 0,
  }) : controller = controller ?? TextEditingController(
    text: ''),
    focusNode = focusNode ?? FocusNode();

  GeneralCustomeTextFieldState copyWith({
    bool? isFocused,
    bool? isEmpty,
    String? errorMessage,
    FocusNode? focusNode,
    TextEditingController? controller,
    String? fieldValue,
    int? countInit,
  }) {
    return GeneralCustomeTextFieldState(
      isFocused: isFocused ?? this.isFocused,
      isEmpty: isEmpty ?? this.isEmpty,
      errorMessage: errorMessage ?? this.errorMessage,
      focusNode: focusNode ?? this.focusNode,
      controller: controller ?? this.controller,
      fieldValue: fieldValue ?? this.fieldValue,
      countInit : countInit ?? this.countInit,
    );
  }
}
