import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:petani_cerdas/models/transaction.dart';

import '../models/schedule.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  StreamSubscription<QuerySnapshot>? _transactionSubscription;
  DashboardBloc() : super(DashboardState()) {
    on<OnGetLatestTransaction>(getLatestTransaction);
    on<OnEmitLatestTransaction>(emitLatestTransaction);

    on<OnGetTodaySchedule>(getTodaySchedule);
    on<OnEmitTodaySchedule>(emitTodaySchedule);
  }

  Future<String> getUserId() async {
    final FlutterSecureStorage secureStorage = FlutterSecureStorage();
    final String? value = await secureStorage.read(key: 'login_user');
    return value ?? '';
  }

  @override
  Future<void> close() {
    if (_transactionSubscription != null) {
      _transactionSubscription?.cancel();
    }
    return super.close();
  }

  void emitLatestTransaction(
      OnEmitLatestTransaction event, Emitter<DashboardState> emit) {
    emit(state.copyWith(
      isLoadingLoadLatestTransaction: false,
      errorMessageLoadLatestTransaction: '',
      listLatestTransaction: event.list,
      isEmpty: event.list.isEmpty ? true : false,
    ));
  }

  void emitTodaySchedule(
      OnEmitTodaySchedule event, Emitter<DashboardState> emit) {
    emit(state.copyWith(
        isEmptySchedule:
            event.todaySchedule.calendarId.isNotEmpty ? false : true,
        todaySchedule: event.todaySchedule,
        isLoadingLoadTodaySchedule: false,
        errorMessageLoadTodaySchedule: ''));
  }

  FutureOr<void> getLatestTransaction(
      OnGetLatestTransaction event, Emitter<DashboardState> emit) async {
    emit(state.copyWith(isLoadingLoadLatestTransaction: true));
    try {
      final userId = await getUserId();
      List<Transactions> latestTransaction = List.empty();
      _transactionSubscription = FirebaseFirestore.instance
          .collection('Transaction')
          .where('user_id', isEqualTo: userId)
          .limit(5)
          .orderBy('transaction_date', descending: true)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        if (snapshot.docs.isEmpty) {
          if (!isClosed) {
            add(OnEmitLatestTransaction(latestTransaction));
          }
          return;
        }
        latestTransaction = snapshot.docs.map((doc) {
          return Transactions.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();

        if (!isClosed) {
          add(OnEmitLatestTransaction(latestTransaction));
        }
      });
    } catch (e) {
      emit(state.copyWith(
          isLoadingLoadLatestTransaction: false,
          isEmpty: true,
          errorMessageLoadLatestTransaction: e.toString(),
          listLatestTransaction: List.empty()));
    }
  }

  FutureOr<void> getTodaySchedule(
      OnGetTodaySchedule event, Emitter<DashboardState> emit) async {
        emit(state.copyWith(
          isLoadingLoadTodaySchedule: true
        ));
        try{
          final userId = await getUserId();
          late Schedule schedule;

          FirebaseFirestore.instance
          .collection('Schedule')
          .where('user_id', isEqualTo: userId)
          .limit(1)
          .orderBy('schedule_start_time', descending: true)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
            if (snapshot.docs.isEmpty) {
              if (!isClosed) {
                emit(state.copyWith(
                isEmptySchedule: true,
                isLoadingLoadTodaySchedule: false,
                todaySchedule: null,
                errorMessageLoadTodaySchedule: ''
              ));
              }
              return;
            }
            schedule = snapshot.docs.map((date) {
              return Schedule.fromJson(date.data() as Map<String, dynamic>);
            }) as Schedule;

            if (!isClosed) {
              emit(state.copyWith(
                isEmptySchedule: false,
                isLoadingLoadTodaySchedule: false,
                todaySchedule: schedule,
                errorMessageLoadTodaySchedule: ''
              ));
            }
          });
        }
        catch(e) {
          emit(state.copyWith(
            isEmptySchedule: true,
            todaySchedule: null,
            isLoadingLoadTodaySchedule: false,
            errorMessageLoadTodaySchedule: e.toString()
          ));
        }
      }
}
