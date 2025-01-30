part of 'custome_text_field_behavior_bloc.dart';

class CustomeTextFieldBehaviorState {
  final bool isFocused;
  final bool isEmpty;
  final bool isError;
  final String errorMessageName;
  final String errorMessagePhone;

  const CustomeTextFieldBehaviorState(
    this.isFocused,
    this.isEmpty,
    this.isError,
    this.errorMessageName,
    this.errorMessagePhone
  );
}
