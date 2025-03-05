part of 'general_custome_text_field_bloc.dart';

@immutable
sealed class GeneralCustomeTextFieldEvent {}


class OnFocusChange extends GeneralCustomeTextFieldEvent {
  final bool isFocused;

  OnFocusChange(this.isFocused);
}

class OnTextChange extends GeneralCustomeTextFieldEvent {
  final bool isEmpty;
  final String value;

  OnTextChange(this.isEmpty, this.value);
}

class OnUpdateField extends GeneralCustomeTextFieldEvent {
  final String value;
  OnUpdateField (this.value);
}