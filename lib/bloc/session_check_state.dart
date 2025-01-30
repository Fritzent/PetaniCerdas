part of 'session_check_bloc.dart';

enum SessionStatus {
  loading, found, notFound
}

class SessionCheckState {
  final SessionStatus status;

  const SessionCheckState (
    this.status
  );
}