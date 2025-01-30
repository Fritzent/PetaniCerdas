import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:petani_cerdas/models/detail_transaction.dart';

part 'add_transactions_event.dart';
part 'add_transactions_state.dart';

class AddTransactionsBloc
    extends Bloc<AddTransactionsEvent, AddTransactionsState> {
  AddTransactionsBloc()
      : super(AddTransactionsState(listDetailTransaction: [
          DetailTransaction(
            name: '',
            type: '',
            price: '',
            transactionId: '',
            transactionDetailId: '',
          )
        ])) {
    on<OnUpdateTransactionName>(updateTransactionName);
    on<OnUpdateTransactionNote>(updateTransactionNote);
    on<OnUpdateTransactionDate>(updateTransactionDate);
    on<OnUpdateTransactionDateField>(updateTransactionDateField);
    on<OnUpdateTransactionDetail>(updateTransactionDetails);
    on<OnFocusChange>(customeTextFieldFocusChange);
    on<OnTextChange>(customeTextFieldTextChange);
    on<OnSubmitAddTransactions>(submitTransactions);
    on<OnUpdateTransactionSectionError>(updateTransactionSectionError);
    on<OnAddDetailSection>(addDetailSection);
    on<OnRemoveDetailSection>(removeDetailSection);
    on<OnUpdateDetailTransactionDropDownType>(
        updateDetailTransactionDropDownType);
    on<OnUpdateDetailTransactionName>(updateDetailTransactionName);
    on<OnUpdateDetailTransactionPrice>(updateDetailTransactionPrice);
  }
  FutureOr<void> updateTransactionName(OnUpdateTransactionName event, emit) {
    if (event.nameTransaction.isEmpty) {
      return emit(AddTransactionsState(
          transactionName: event.nameTransaction,
          transactionNote: state.transactionNote,
          transactionDate: state.transactionDate,
          listDetailTransaction: state.listDetailTransaction,
          isError: true,
          errorText: 'Nama Transaksi Tidak Boleh Kosong'));
    }
    emit(AddTransactionsState(
        transactionName: event.nameTransaction,
        transactionNote: state.transactionNote,
        transactionDate: state.transactionDate,
        listDetailTransaction: state.listDetailTransaction));
  }

  FutureOr<void> updateTransactionNote(OnUpdateTransactionNote event, emit) {
    emit(AddTransactionsState(
        transactionName: state.transactionName,
        transactionNote: event.noteTransaction,
        transactionDate: state.transactionDate,
        listDetailTransaction: state.listDetailTransaction));
  }

  FutureOr<void> updateTransactionDate(OnUpdateTransactionDate event, emit) {
    if (event.dateTransaction == null) {
      return emit(AddTransactionsState(
          transactionName: state.transactionName,
          transactionNote: state.transactionNote,
          transactionDate: event.dateTransaction,
          listDetailTransaction: state.listDetailTransaction,
          errorText: 'Tanggal Transaksi Tidak Boleh Kosong'));
    }
    emit(AddTransactionsState(
        transactionName: state.transactionName,
        transactionNote: state.transactionNote,
        transactionDate: event.dateTransaction,
        listDetailTransaction: state.listDetailTransaction));
  }

  FutureOr<void> updateTransactionDateField(
      OnUpdateTransactionDateField event, emit) {
    final newController = TextEditingController(text: event.dateTimeValue);
    emit(AddTransactionsState(controller: newController));
  }

  FutureOr<void> updateTransactionDetails(
      OnUpdateTransactionDetail event, emit) {
    // List<DetailTransaction>? previousList = state.listDetailTransaction;
    // if (previousList != null) {
    //   previousList.add(event.detailTransaction);
    // } else {
    //   previousList = event.detailTransaction as List<DetailTransaction>?;
    // }
    // emit(AddTransactionsState(
    //     transactionName: state.transactionName,
    //     transactionNote: state.transactionNote,
    //     transactionDate: state.transactionDate,
    //     listDetailTransaction: previousList));
  }

  FutureOr<void> customeTextFieldFocusChange(OnFocusChange event, emit) {
    emit(AddTransactionsState(isFocused: event.isFocused));
  }

  FutureOr<void> customeTextFieldTextChange(OnTextChange event, emit) {
    emit(AddTransactionsState(isEmpty: event.isEmpty));
  }

  FutureOr<void> updateTransactionSectionError(
      OnUpdateTransactionSectionError event, emit) {
    emit(AddTransactionsState(
        isError: event.isError, errorText: event.errorText));
  }

  FutureOr<void> addDetailSection(OnAddDetailSection event, emit) {
    final newDetails =
        List<DetailTransaction>.from(state.listDetailTransaction)
          ..add(DetailTransaction(
            name: '',
            type: '',
            price: '',
            transactionId: '',
            transactionDetailId: '',
          ));
    emit(AddTransactionsState(listDetailTransaction: newDetails));
  }

  FutureOr<void> removeDetailSection(OnRemoveDetailSection event, emit) {
    final newDetails =
        List<DetailTransaction>.from(state.listDetailTransaction)
          ..removeAt(event.index);

    emit(AddTransactionsState(listDetailTransaction: newDetails));
  }

  FutureOr<void> updateDetailTransactionDropDownType(
      OnUpdateDetailTransactionDropDownType event, emit) {
    List<DetailTransaction> updatedList =
        List<DetailTransaction>.from(state.listDetailTransaction);

    updatedList[event.index] =
        updatedList[event.index].copyWith(type: event.type);

    emit(AddTransactionsState(listDetailTransaction: updatedList));
  }

  FutureOr<void> updateDetailTransactionName(
      OnUpdateDetailTransactionName event, emit) {
    List<DetailTransaction> updatedList =
        List<DetailTransaction>.from(state.listDetailTransaction);

    state.controllerDetailName[event.index].text = event.value;

    updatedList[event.index] =
        updatedList[event.index].copyWith(name: event.value);

    final oldController = state.controllerDetailName[event.index];
    final cursorPosition = oldController.selection.baseOffset +
        (event.value.length - oldController.text.length);

    oldController.text = event.value;
    oldController.selection = TextSelection.collapsed(
        offset: cursorPosition.clamp(0, event.value.length));

    emit(state.copyWith(
      listDetailTransaction: updatedList,
      controllerDetailName: state.controllerDetailName,
      focusNodeName: state.focusNodeName,
    ));
  }

  FutureOr<void> updateDetailTransactionPrice(
      OnUpdateDetailTransactionPrice event, emit) {
    List<DetailTransaction> updatedList =
        List<DetailTransaction>.from(state.listDetailTransaction);

    state.controllerDetailPrice[event.index].text = event.value;

    updatedList[event.index] =
        updatedList[event.index].copyWith(price: event.value);

    final oldController = state.controllerDetailPrice[event.index];
    final cursorPosition = oldController.selection.baseOffset +
        (event.value.length - oldController.text.length);

    oldController.text = event.value;
    oldController.selection = TextSelection.collapsed(
        offset: cursorPosition.clamp(0, event.value.length));

    emit(state.copyWith(
      listDetailTransaction: updatedList,
      controllerDetailPrice: state.controllerDetailPrice,
      focusNodePrice: state.focusNodePrice,
    ));
  }
  FutureOr<void> submitTransactions(OnSubmitAddTransactions event, emit) {}
}
