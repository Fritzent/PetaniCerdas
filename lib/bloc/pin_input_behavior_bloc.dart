import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bcrypt/bcrypt.dart';

import '../models/users.dart';

part 'pin_input_behavior_event.dart';
part 'pin_input_behavior_state.dart';

class PinInputBehaviorBloc
    extends Bloc<PinInputBehaviorEvent, PinInputBehaviorState> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  PinInputBehaviorBloc(int fieldCount)
      : super(PinInputBehaviorState(
          pinValues: List.filled(fieldCount, ""),
          currentIndex: 0,
        )) {
    on<OnPinInputAddBehavior>(PinInputAdd);
    on<OnPinInputRemoveBehavior>(PinInputRemove);
    on<OnPinInputSaved>(PinInputSaved);
  }

  FutureOr<void> PinInputAdd(event, emit) {
    if (state.currentIndex < state.pinValues.length) {
      final updatedValues = List<String>.from(state.pinValues);
      updatedValues[state.currentIndex] = event.number;

      emit(PinInputBehaviorState(
          pinValues: updatedValues,
          currentIndex: state.currentIndex + 1,
          progress: 'Add'));
    }
  }

  FutureOr<void> PinInputRemove(event, emit) {
    if (state.currentIndex > 0) {
      final updatedValues = List<String>.from(state.pinValues);
      updatedValues[state.currentIndex - 1] = '';

      emit(PinInputBehaviorState(
          pinValues: updatedValues,
          currentIndex: state.currentIndex - 1,
          progress: 'Remove'));
    }
  }

  FutureOr<void> PinInputSaved(event, emit) async {
    emit(PinInputBehaviorState(
        pinValues: state.pinValues,
        currentIndex: state.currentIndex,
        isLoading: true));
    try {
      final user = auth.currentUser;
      if (user != null) {
        if (event.viewedPage == 'CreatePin') {
          await SaveUserPin(user, emit, state.pinValues);
        } else {
          await ValidateUserPin(user, emit, state.pinValues);
        }
      }
    } catch (e) {
      emit(PinInputBehaviorState(
        pinValues: state.pinValues,
        currentIndex: state.currentIndex,
        isLoading: false,
        errorMessage: e.toString(),
        progress: 'Error',
      ));
    }
  }

  Future<void> SaveUserPin(
      User userData, dynamic emit, List<String> pin) async {
    try {
      String hashedPin = BCrypt.hashpw(pin.join(), BCrypt.gensalt());
      Map<String, dynamic> data = {'user_pin': hashedPin};
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('Users');
      await collectionReference.doc(userData.uid).update(data);

      emit(PinInputBehaviorState(
        pinValues: state.pinValues,
        currentIndex: state.currentIndex,
        isLoading: false,
        progress: 'Saved',
      ));
    } catch (e) {
      emit(PinInputBehaviorState(
        pinValues: state.pinValues,
        currentIndex: state.currentIndex,
        isLoading: false,
        errorMessage: e.toString(),
        progress: 'Error',
      ));
    }
  }

  Future<void> ValidateUserPin(
      User userData, dynamic emit, List<String> pin) async {
    try {
      final datas = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userData.uid)
          .get();
      Users? user = datas.exists ? Users.fromJson(datas.data()!) : null;

      if (user != null) {
        bool isValid = verifyUserPin(pin.join(), user.userPin);
        if (isValid) {
          emit(PinInputBehaviorState(
            pinValues: state.pinValues,
            currentIndex: state.currentIndex,
            isLoading: false,
            progress: 'LoginSuccess',
          ));
        } else {
          emit(PinInputBehaviorState(
            pinValues: state.pinValues,
            currentIndex: state.currentIndex,
            isLoading: false,
            errorMessage: '⚠️ PIN yang Anda masukkan tidak tepat. Coba lagi, ya!',
            progress: 'Error',
          ));
        }
      }
    } catch (e) {
      emit(PinInputBehaviorState(
        pinValues: state.pinValues,
        currentIndex: state.currentIndex,
        isLoading: false,
        errorMessage: e.toString(),
        progress: 'Error',
      ));
    }
  }

  bool verifyUserPin(String inputPin, String storedHash) {
    return BCrypt.checkpw(inputPin, storedHash);
  }
}