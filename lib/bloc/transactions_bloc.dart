import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:petani_cerdas/models/detail_transaction.dart';
import 'package:petani_cerdas/resources/bottomsheet_item.dart';
import '../models/transaction.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  StreamSubscription<QuerySnapshot>? _transactionSubscription;

  TransactionsBloc() : super(TransactionsState()) {
    on<FetchTransaction>(OnFetchTransactions);
    on<LoadMoreTransactions>(LoadMore);
    on<EmitTransactionData>(OnEmitData);
    on<SelectedSortBottomSheet>(OnSelectedSortBottomSheet);

    on<SortTransactionName>(OnSortTransactionName);
    on<SortByTotalTransaction>(OnSortByTotalTransaction);
    on<SortByDate>(OnSortByDate);
    on<SortByType>(OnSortByType);

    on<FetchDetailTransaction>(fetchDetailTransactions);
    on<EmitDetailTransactionData>(OnEmitDetailTransactionData);
  }

  Future<String> getData() async {
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

  void OnEmitData(EmitTransactionData event, Emitter<TransactionsState> emit) {
    emit(TransactionsState(
      isLoading: false,
      groupedTransactions: event.groupedTransactionsData,
      errorMessage: '',
      hasNewUpdate: false,
    ));
  }

  void OnEmitDetailTransactionData(
      EmitDetailTransactionData event, Emitter<TransactionsState> emit) {
    emit(TransactionsState(
      isLoading: false,
      errorMessage: '',
      listDetailTransaction: event.list,
    ));
  }

  void OnSelectedSortBottomSheet(
      SelectedSortBottomSheet event, Emitter<TransactionsState> emit) {
    if (event.sortBy == dataType[0]) {
      add(SortTransactionName(sortWay: event.sortWay));
    }
    if (event.sortBy == dataType[1]) {
      add(SortByTotalTransaction(sortWay: event.sortWay));
    }
    if (event.sortBy == dataType[2]) {
      add(SortByDate(sortWay: event.sortWay));
    }
    if (event.sortBy == dataType[3]) {
      add(SortByType(sortWay: event.sortWay));
    }
  }

  void LoadMore(
      LoadMoreTransactions event, Emitter<TransactionsState> emit) async {
    if (state.isLoading || state.lastDocument == null) {
      return;
    }
    emit(state.copyWith(isLoading: true));
    try {
      String userId = await getData();

      Query query = FirebaseFirestore.instance
          .collection('Transaction')
          .where('user_id', isEqualTo: userId)
          .orderBy('transaction_date', descending: true)
          .startAfterDocument(state.lastDocument!)
          .limit(10);

      QuerySnapshot snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        emit(state.copyWith(
            isLoading: false, hasNewUpdate: false, groupedTransactions: state.groupedTransactions));
        return;
      }

      List<Transactions> data = snapshot.docs.map((doc) {
        return Transactions.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      Map<String, List<Transactions>> groupedTransactionsData = {};
      for (var transaction in data) {
        String month = DateFormat.yMMMM().format(transaction.date);
        if (!groupedTransactionsData.containsKey(month)) {
          groupedTransactionsData[month] = [];
        }
        groupedTransactionsData[month]!.add(transaction);
      }

      Map<String, List<Transactions>> mergedTransactions =
          Map.from(state.groupedTransactions);
      groupedTransactionsData.forEach((month, transactions) {
        if (mergedTransactions.containsKey(month)) {
          mergedTransactions[month]!.addAll(transactions);
        } else {
          mergedTransactions[month] = transactions;
        }
      });

      emit(state.copyWith(
        groupedTransactions: mergedTransactions,
        isLoading: false,
        hasNewUpdate: data.isNotEmpty,
        lastDocument: snapshot.docs.last,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        groupedTransactions: state.groupedTransactions,
      ));
    }
  }

  void OnFetchTransactions(
      FetchTransaction event, Emitter<TransactionsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      String userId = await getData();

      Query query = FirebaseFirestore.instance
          .collection('Transaction')
          .where('user_id', isEqualTo: userId)
          .orderBy('transaction_date', descending: true)
          .limit(10);
      QuerySnapshot snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        emit(state.copyWith(
            isLoading: false, hasNewUpdate: false, groupedTransactions: {}));
        return;
      }

      List<Transactions> data = snapshot.docs.map((doc) {
        return Transactions.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      Map<String, List<Transactions>> groupedTransactionsData = {};
      for (var transaction in data) {
        String month = DateFormat.yMMMM().format(transaction.date);
        if (!groupedTransactionsData.containsKey(month)) {
          groupedTransactionsData[month] = [];
        }
        groupedTransactionsData[month]!.add(transaction);
      }

      Map<String, List<Transactions>> mergedTransactions =
          Map.from(state.groupedTransactions);
      groupedTransactionsData.forEach((month, transactions) {
        if (mergedTransactions.containsKey(month)) {
          mergedTransactions[month]!.addAll(transactions);
        } else {
          mergedTransactions[month] = transactions;
        }
      });

      emit(state.copyWith(
        groupedTransactions: mergedTransactions,
        isLoading: false,
        hasNewUpdate: data.isNotEmpty,
        lastDocument: snapshot.docs.last,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        groupedTransactions: {},
      ));
    }
  }

  void fetchDetailTransactions(
      FetchDetailTransaction event, Emitter<TransactionsState> emit) async {
    emit(TransactionsState(isLoading: true));
    try {
      List<DetailTransaction> data = List.empty();

      FirebaseFirestore.instance
          .collection('Detail Transaction')
          .where('transaction_id', isEqualTo: event.transactionId)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        data = snapshot.docs.map((doc) {
          return DetailTransaction.fromJsonForDetailBs(
              doc.data() as Map<String, dynamic>);
        }).toList();
        add(EmitDetailTransactionData(data));
      });
    } catch (e) {
      emit(TransactionsState(
          isLoading: false,
          errorMessage: e.toString(),
          listDetailTransaction: state.listDetailTransaction));
    }
  }

  void OnSortTransactionName(
      SortTransactionName event, Emitter<TransactionsState> emit) async {
    emit(TransactionsState(isLoading: true));

    try {
      String userId = await getData();
      List<Transactions> data = List.empty();
      bool isDescending = true;

      if (event.sortWay == sortWay[0]) {
        isDescending = false;
      }
      FirebaseFirestore.instance
          .collection('Transaction')
          .where('user_id', isEqualTo: userId)
          .orderBy('transaction_name', descending: isDescending)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        data = snapshot.docs.map((doc) {
          return Transactions.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();

        Map<String, List<Transactions>> groupedTransactionsData = {};
        for (var transaction in data) {
          String month = DateFormat.yMMMM().format(transaction.date);
          if (!groupedTransactionsData.containsKey(month)) {
            groupedTransactionsData[month] = [];
          }
          groupedTransactionsData[month]!.add(transaction);
        }

        add(EmitTransactionData(groupedTransactionsData));
      });
    } catch (e) {
      emit(TransactionsState(
        isLoading: false,
        errorMessage: e.toString(),
        groupedTransactions: {},
      ));
    }
  }

  void OnSortByTotalTransaction(
      SortByTotalTransaction event, Emitter<TransactionsState> emit) async {
    try {
      String userId = await getData();
      List<Transactions> data = List.empty();
      bool isDescending = true;

      if (event.sortWay == sortWay[0]) {
        isDescending = false;
      }

      FirebaseFirestore.instance
          .collection('Transaction')
          .where(
            'user_id',
            isEqualTo: userId,
          )
          .orderBy('transaction_total_price', descending: isDescending)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        data = snapshot.docs.map((doc) {
          return Transactions.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();

        Map<String, List<Transactions>> groupedTransactionsData = {};
        for (var transaction in data) {
          String month = DateFormat.yMMMM().format(transaction.date);
          if (!groupedTransactionsData.containsKey(month)) {
            groupedTransactionsData[month] = [];
          }
          groupedTransactionsData[month]!.add(transaction);
        }

        add(EmitTransactionData(groupedTransactionsData));
      });
    } catch (e) {
      emit(TransactionsState(
        isLoading: false,
        errorMessage: e.toString(),
        groupedTransactions: {},
      ));
    }
  }

  void OnSortByDate(SortByDate event, Emitter<TransactionsState> emit) async {
    try {
      String userId = await getData();
      List<Transactions> data = List.empty();

      bool isDescending = true;

      if (event.sortWay == sortWay[0]) {
        isDescending = false;
      }

      FirebaseFirestore.instance
          .collection('Transaction')
          .where(
            'user_id',
            isEqualTo: userId,
          )
          .orderBy('transaction_date', descending: isDescending)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        data = snapshot.docs.map((doc) {
          return Transactions.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();

        Map<String, List<Transactions>> groupedTransactionsData = {};
        for (var transaction in data) {
          String month = DateFormat.yMMMM().format(transaction.date);
          if (!groupedTransactionsData.containsKey(month)) {
            groupedTransactionsData[month] = [];
          }
          groupedTransactionsData[month]!.add(transaction);
        }

        add(EmitTransactionData(groupedTransactionsData));
      });
    } catch (e) {
      emit(TransactionsState(
        isLoading: false,
        errorMessage: e.toString(),
        groupedTransactions: {},
      ));
    }
  }

  void OnSortByType(SortByType event, Emitter<TransactionsState> emit) async {
    try {
      String userId = await getData();
      List<Transactions> data = List.empty();

      bool isDescending = true;

      if (event.sortWay == sortWay[0]) {
        isDescending = false;
      }

      FirebaseFirestore.instance
          .collection('Transaction')
          .where(
            'user_id',
            isEqualTo: userId,
          )
          .orderBy('transaction_type', descending: isDescending)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        data = snapshot.docs.map((doc) {
          return Transactions.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();

        Map<String, List<Transactions>> groupedTransactionsData = {};
        for (var transaction in data) {
          String month = DateFormat.yMMMM().format(transaction.date);
          if (!groupedTransactionsData.containsKey(month)) {
            groupedTransactionsData[month] = [];
          }
          groupedTransactionsData[month]!.add(transaction);
        }

        add(EmitTransactionData(groupedTransactionsData));
      });
    } catch (e) {
      emit(TransactionsState(
        isLoading: false,
        errorMessage: e.toString(),
        groupedTransactions: {},
      ));
    }
  }
}
