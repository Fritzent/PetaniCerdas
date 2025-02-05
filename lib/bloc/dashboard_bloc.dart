import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:petani_cerdas/models/transaction.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  StreamSubscription<QuerySnapshot>? _transactionSubscription;
  DashboardBloc() : super(DashboardState()) {
    on<OnGetLatestTransaction>(getLatestTransaction);
    on<OnEmitLatestTransaction>(emitLatestTransaction);
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
    emit(DashboardState(
      isLoadingLoadLatestTransaction: false,
      errorMessageLoadLatestTransaction: '',
      listLatestTransaction: event.list,
    ));
  }

  FutureOr<void> getLatestTransaction(
      OnGetLatestTransaction event, Emitter<DashboardState> emit) async {
    emit(DashboardState(isLoadingLoadLatestTransaction: true));
    try {
      final userId = await getUserId();
      List<Transactions> latestTransaction = List.empty();
      _transactionSubscription = FirebaseFirestore.instance
          .collection('Transaction')
          .where('user_id', isEqualTo: userId)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        latestTransaction = snapshot.docs.map((doc) {
          return Transactions.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();

        if (!isClosed) {
          add(OnEmitLatestTransaction(latestTransaction));
        }
      });
    } catch (e) {
      emit(DashboardState(
          isLoadingLoadLatestTransaction: false,
          errorMessageLoadLatestTransaction: e.toString(),
          listLatestTransaction: List.empty()));
    }
  }
}
