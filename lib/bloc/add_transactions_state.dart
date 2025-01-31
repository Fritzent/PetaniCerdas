part of 'add_transactions_bloc.dart';

class AddTransactionsState {
  final String transactionId;
  final String transactionName;
  final String transactionNote;
  final DateTime? transactionDate;
  final List<DetailTransaction> listDetailTransaction;
  final String errorText;
  final bool isFocused;
  final bool isError;
  final bool isEmpty;
  final TextEditingController controller;
  final List<TextEditingController> controllerDetailName;
  final List<TextEditingController> controllerDetailPrice;
  final FocusNode? focusNode;
  final List<FocusNode> focusNodeName;
  final List<FocusNode> focusNodePrice;
  final int countDetailSection;

  AddTransactionsState({
    this.transactionId = '',
    this.transactionName = '',
    this.transactionNote = '',
    this.transactionDate,
    List<DetailTransaction>? listDetailTransaction,
    this.errorText = '',
    this.isFocused = false,
    this.isError = false,
    this.isEmpty = false,
    TextEditingController? controller,
    this.focusNode,
    this.countDetailSection = 1,
    List<TextEditingController>? controllerDetailName,
    List<TextEditingController>? controllerDetailPrice,
    List<FocusNode>? focusNodeName,
    List<FocusNode>? focusNodePrice,
  })  : controller = controller ??
            TextEditingController(
                text: transactionNote.isEmpty ? '' : transactionNote),
        listDetailTransaction = listDetailTransaction ??
            [
              DetailTransaction(
                name: '',
                type: '',
                price: '',
                transactionId: '',
                transactionDetailId: '',
              )
            ],
        controllerDetailName = controllerDetailName ??
            List.generate(
                (listDetailTransaction ?? []).isNotEmpty
                    ? listDetailTransaction!.length
                    : 1,
                (index) => TextEditingController(
                    text: (listDetailTransaction ?? [])[index].name)),
        controllerDetailPrice = controllerDetailPrice ??
            List.generate(
                (listDetailTransaction ?? []).isNotEmpty
                    ? listDetailTransaction!.length
                    : 1,
                (index) => TextEditingController(
                    text: (listDetailTransaction ?? [])[index].price)),
        focusNodeName = focusNodeName ??
            List.generate(
                (listDetailTransaction ?? []).isNotEmpty
                    ? listDetailTransaction!.length
                    : 1,
                (index) => FocusNode()),
        focusNodePrice = focusNodePrice ??
            List.generate(
                (listDetailTransaction ?? []).isNotEmpty
                    ? listDetailTransaction!.length
                    : 1,
                (index) => FocusNode());

  AddTransactionsState copyWith({
    String? transactionName,
    String? transactionNote,
    DateTime? transactionDate,
    List<DetailTransaction>? listDetailTransaction,
    String? errorText,
    bool? isFocused,
    bool? isError,
    bool? isEmpty,
    TextEditingController? controller,
    List<TextEditingController>? controllerDetailName,
    List<TextEditingController>? controllerDetailPrice,
    FocusNode? focusNode,
    List<FocusNode>? focusNodeName,
    List<FocusNode>? focusNodePrice,
    int? countDetailSection,
  }) {
    return AddTransactionsState(
      transactionName: transactionName ?? this.transactionName,
      transactionNote: transactionNote ?? this.transactionNote,
      transactionDate: transactionDate ?? this.transactionDate,
      listDetailTransaction:
          listDetailTransaction ?? this.listDetailTransaction,
      errorText: errorText ?? this.errorText,
      isFocused: isFocused ?? this.isFocused,
      isError: isError ?? this.isError,
      isEmpty: isEmpty ?? this.isEmpty,
      controller: controller ?? this.controller,
      controllerDetailName: controllerDetailName ?? this.controllerDetailName,
      controllerDetailPrice:
          controllerDetailPrice ?? this.controllerDetailPrice,
      focusNode: focusNode ?? this.focusNode,
      focusNodeName: focusNodeName ?? this.focusNodeName,
      focusNodePrice: focusNodePrice ?? this.focusNodePrice,
      countDetailSection: countDetailSection ?? this.countDetailSection,
    );
  }
}
