part of 'custome_text_field_behavior_bloc.dart';

@immutable
sealed class CustomeTextFieldBehaviorEvent {}

class OnCustomeTextFieldFocusChange extends CustomeTextFieldBehaviorEvent {
  final bool isFocused;

  OnCustomeTextFieldFocusChange(this.isFocused);
}

class OnCustomeTextFieldTextChange extends CustomeTextFieldBehaviorEvent {
  final bool isEmpty;

  OnCustomeTextFieldTextChange(this.isEmpty);
}

class OnCustomeTextFieldTextError extends CustomeTextFieldBehaviorEvent {
  final bool isError;
  final String errorMessageName;
  final String errorMessagePhone;

  OnCustomeTextFieldTextError(this.isError, this.errorMessageName, this.errorMessagePhone);
}
