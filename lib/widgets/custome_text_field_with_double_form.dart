import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petani_cerdas/resources/style_config.dart';
import '../bloc/add_transactions_bloc.dart';
import '../models/transaction.dart';

class CustomeTextFieldWithDoubleForm extends StatefulWidget {
  final String firstTextHint;
  final String secondTextHint;
  final String thirdTextHint;
  final bool isCancelButtonShow;
  final Function(String)? onChangedName;
  final Function(String)? onChangedPrice;
  final Function(TransactionType?)? onChangedType;
  final int index;
  final AddTransactionsBloc textFieldBloc;
  final String? errorText;
  final bool isError;
  final FocusNode focusNodeName;
  final FocusNode focusNodePrice;

  const CustomeTextFieldWithDoubleForm({
    super.key,
    required this.firstTextHint,
    required this.secondTextHint,
    required this.thirdTextHint,
    this.isCancelButtonShow = false,
    this.onChangedName,
    this.onChangedPrice,
    this.index = 0,
    required this.textFieldBloc,
    required this.focusNodeName,
    required this.focusNodePrice,
    this.onChangedType,
    this.errorText,
    this.isError = false,
  });

  @override
  State<CustomeTextFieldWithDoubleForm> createState() =>
      _CustomeTextFieldWithDoubleFormState();
}

class _CustomeTextFieldWithDoubleFormState
    extends State<CustomeTextFieldWithDoubleForm> {
  String? selectedType;
  final List<TransactionType> transactionTypes = [
    TransactionType(
        'Pendapatan', ColorList.primaryColor, ColorList.secondaryColor),
    TransactionType(
        'Pengeluaran', ColorList.redColor200, ColorList.redColor100),
  ];

  @override
  void dispose() {
    widget.focusNodeName.dispose();
    widget.focusNodePrice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTransactionsBloc, AddTransactionsState>(
      bloc: widget.textFieldBloc,
      builder: (context, state) {
        return Column(
          spacing: FontList.font8,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: FontList.font8, vertical: FontList.font4),
              decoration: BoxDecoration(
                border: Border.all(color: ColorList.whiteColor100, width: 1.0),
                borderRadius: BorderRadius.circular(FontList.font8),
              ),
              child: DropdownButton<TransactionType>(
                isExpanded: true,
                value:
                    state.listDetailTransaction[widget.index].type.isNotEmpty
                        ? transactionTypes.firstWhere((type) =>
                            type.name ==
                            state.listDetailTransaction[widget.index].type)
                        : null,
                icon: SvgPicture.asset(
                  'assets/icons/ic_down.svg',
                  width: 24,
                  height: 24,
                ),
                hint: Text(
                  widget.firstTextHint,
                  style: TextStyle(
                      color: ColorList.grayColor200, fontSize: FontList.font16),
                ),
                style: TextStyle(
                    color: ColorList.blackColor, fontSize: FontList.font16),
                dropdownColor: ColorList.whiteColor,
                underline: SizedBox(),
                items: transactionTypes.map((type) {
                  return DropdownMenuItem<TransactionType>(
                    value: type,
                    child: Row(
                      spacing: FontList.font12,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: FontList.font30,
                              height: FontList.font30,
                              decoration: BoxDecoration(
                                color: type.colorPrimary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: FontList.font20,
                                height: FontList.font20,
                                decoration: BoxDecoration(
                                  color: type.secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(type.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: widget.onChangedType,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: FontList.font8, vertical: FontList.font8),
              decoration: BoxDecoration(
                border: Border.all(color: ColorList.whiteColor100, width: 1.0),
                borderRadius: BorderRadius.circular(FontList.font8),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    keyboardType: TextInputType.text,
                    controller: state.controllerDetailName[widget.index],
                    focusNode: widget.focusNodeName,
                    onChanged: widget.onChangedName,
                    style: TextStyle(
                        color: ColorList.blackColor,
                        fontSize: FontList.font16,
                        fontWeight: FontWeight.normal),
                    decoration: InputDecoration(
                      hintText: widget.secondTextHint,
                      hintStyle: TextStyle(
                          color: ColorList.grayColor200,
                          fontSize: FontList.font16,
                          fontWeight: FontWeight.normal),
                      filled: true,
                      fillColor: ColorList.whiteColor,
                      border: InputBorder.none,
                    ),
                  )),
                  Expanded(
                      child: TextField(
                    keyboardType: TextInputType.number,
                    controller: state.controllerDetailPrice[widget.index],
                    focusNode: widget.focusNodePrice,
                    onChanged: widget.onChangedPrice,
                    style: TextStyle(
                        color: state.listDetailTransaction[widget.index]
                                    .type ==
                                transactionTypes[0].name
                            ? ColorList.primaryColor
                            : state.listDetailTransaction[widget.index].type ==
                                    transactionTypes[1].name
                                ? ColorList.redColor200
                                : ColorList.blackColor,
                        fontSize: FontList.font16,
                        fontWeight: FontWeight.normal),
                    decoration: InputDecoration(
                      hintText: widget.thirdTextHint,
                      hintStyle: TextStyle(
                          color: ColorList.grayColor200,
                          fontSize: FontList.font16,
                          fontWeight: FontWeight.normal),
                      filled: true,
                      fillColor: ColorList.whiteColor,
                      border: InputBorder.none,
                    ),
                  )),
                ],
              ),
            ),
            if (widget.isCancelButtonShow)
              GestureDetector(
                onTap: () {
                  widget.textFieldBloc.add(OnRemoveDetailSection(widget.index));
                },
                child: Text(
                  'Hapus',
                  style: TextStyle(
                      color: ColorList.redColor100,
                      fontSize: FontList.font16,
                      fontWeight: FontWeight.normal),
                ),
              )
          ],
        );
      },
    );
  }
}

//to handling the currency on field
// final NumberFormat _currencyFormat =
//       NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

// void _onTextChanged(String value) {
//     // Remove currency formatting before re-applying it
//     String newValue = value.replaceAll(RegExp(r'[^\d]'), '');

//     // Update the TextField with formatted value
//     if (newValue.isNotEmpty) {
//       final formattedValue = _currencyFormat.format(int.parse(newValue));
//       _controller.value = TextEditingValue(
//         text: formattedValue,
//         selection:
//             TextSelection.collapsed(offset: formattedValue.length), // Keep cursor at the end
//       );
//     }
//   }
