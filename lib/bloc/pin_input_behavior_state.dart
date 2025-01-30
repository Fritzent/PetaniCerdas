part of 'pin_input_behavior_bloc.dart';

class PinInputBehaviorState {
  List<String> pinValues;
  final int currentIndex;
  final bool isLoading;
  final String? errorMessage;
  final String progress;
  final String? viewedPage;

  PinInputBehaviorState(
      {required this.pinValues,
      required this.currentIndex,
      this.isLoading = false,
      this.errorMessage = '',
      this.progress = '',
      this.viewedPage = ''});
}
