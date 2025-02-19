import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'session_check_event.dart';
part 'session_check_state.dart';

class SessionCheckBloc extends Bloc<SessionCheckEvent, SessionCheckState> {
  SessionCheckBloc() : super(SessionCheckState(SessionStatus.loading)) {
    on<CheckSession>(sessionCheck);
    add(CheckSession());
  }

  FutureOr<void> sessionCheck(event, emit) async {
    try {
      final FlutterSecureStorage secureStorage = FlutterSecureStorage();
      String? user = await secureStorage.read(key: 'login_user');
      if (user != null && user.isNotEmpty) {
        emit(SessionCheckState(SessionStatus.found));
      }
      else {
        emit(SessionCheckState(SessionStatus.notFound));
      }
    } catch (e) {
      emit(SessionCheckState(SessionStatus.notFound));
    }
  }
}
