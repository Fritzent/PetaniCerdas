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

  TransactionsBloc() : super(TransactionsState()) {
    on<FetchTransaction>(OnFetchTransactions);
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

  void OnFetchTransactions(
      FetchTransaction event, Emitter<TransactionsState> emit) async {
    emit(TransactionsState(isLoading: true));

    try {
      String userId = await getData();
      List<Transactions> data = List.empty();

      FirebaseFirestore.instance
          .collection('Transaction')
          .where('user_id', isEqualTo: userId)
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
