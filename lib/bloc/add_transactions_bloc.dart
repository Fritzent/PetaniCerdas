import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:petani_cerdas/models/detail_transaction.dart';
import 'package:uuid/uuid.dart';
part 'add_transactions_event.dart';
part 'add_transactions_state.dart';

class AddTransactionsBloc
    extends Bloc<AddTransactionsEvent, AddTransactionsState> {
  AddTransactionsBloc() : super((_initializeState())) {
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
  static AddTransactionsState _initializeState() {
    var uuid = Uuid();
    String generateDetailId = uuid.v4();

    return AddTransactionsState(
      listDetailTransaction: [
        DetailTransaction(
          name: '',
          type: '',
          price: '',
          transactionId: '',
          transactionDetailId: generateDetailId,
        )
      ],
    );
  }

  FutureOr<void> updateTransactionName(OnUpdateTransactionName event, emit) {
    if (event.nameTransaction.isEmpty) {
      return emit(state.copyWith(
          transactionName: event.nameTransaction,
          isError: true,
          errorText: 'Nama Transaksi Tidak Boleh Kosong'));
    }
    emit(state.copyWith(
      transactionName: event.nameTransaction,
    ));
  }

  FutureOr<void> updateTransactionNote(OnUpdateTransactionNote event, emit) {
    emit(state.copyWith(
      transactionNote: event.noteTransaction,
    ));
  }

  FutureOr<void> updateTransactionDate(OnUpdateTransactionDate event, emit) {
    emit(state.copyWith(transactionDate: event.dateTransaction));
    add(OnUpdateTransactionDateField(event.dateTransaction.toString()));
  }

  FutureOr<void> updateTransactionDateField(
      OnUpdateTransactionDateField event, emit) {
    final newController = TextEditingController(text: event.dateTimeValue);
    emit(state.copyWith(controller: newController));
  }

  FutureOr<void> updateTransactionDetails(
      OnUpdateTransactionDetail event, emit) {}

  FutureOr<void> customeTextFieldFocusChange(OnFocusChange event, emit) {
    emit(state.copyWith(isFocused: event.isFocused));
  }

  FutureOr<void> customeTextFieldTextChange(OnTextChange event, emit) {
    emit(state.copyWith(isEmpty: event.isEmpty, isError: false, errorText: ''));
  }

  FutureOr<void> updateTransactionSectionError(
      OnUpdateTransactionSectionError event, emit) {
    emit(state.copyWith(isError: event.isError, errorText: event.errorText));
  }

  FutureOr<void> addDetailSection(OnAddDetailSection event, emit) {
    final newDetails = List<DetailTransaction>.from(state.listDetailTransaction)
      ..add(DetailTransaction(
        name: '',
        type: '',
        price: '',
        transactionId: '',
        transactionDetailId: Uuid().v4(),
      ));
    emit(AddTransactionsState(listDetailTransaction: newDetails));
  }

  FutureOr<void> removeDetailSection(OnRemoveDetailSection event, emit) {
    final newDetails = List<DetailTransaction>.from(state.listDetailTransaction)
      ..removeAt(event.index);

    emit(AddTransactionsState(listDetailTransaction: newDetails));
  }

  FutureOr<void> updateDetailTransactionDropDownType(
      OnUpdateDetailTransactionDropDownType event, emit) {
    List<DetailTransaction> updatedList =
        List<DetailTransaction>.from(state.listDetailTransaction);

    updatedList[event.index] =
        updatedList[event.index].copyWith(type: event.type);

    emit(state.copyWith(listDetailTransaction: updatedList));
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

  FutureOr<void> submitTransactions(OnSubmitAddTransactions event, emit) {
    var uuid = Uuid();
    String generateTransactionId = uuid.v4();

    var check = event;
  }
}
