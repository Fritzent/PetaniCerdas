part of 'pin_input_behavior_bloc.dart';

@immutable
sealed class PinInputBehaviorEvent {}

class OnPinInputAddBehavior extends PinInputBehaviorEvent {
  final String number;
  OnPinInputAddBehavior(this.number);
}

class OnPinInputRemoveBehavior extends PinInputBehaviorEvent {
}

class OnPinInputSaved extends PinInputBehaviorEvent {
  final String viewedPage;

  OnPinInputSaved(this.viewedPage);
}