import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:petani_cerdas/bloc/add_transactions_bloc.dart';
import 'package:petani_cerdas/widgets/custom_toast.dart';
import 'package:petani_cerdas/widgets/custome_text_field_with_double_form.dart';
import 'package:petani_cerdas/widgets/custome_text_field_with_title.dart';

import '../../../resources/style_config.dart';
import '../../../widgets/button_primary.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode noteFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  final nameBloc = AddTransactionsBloc();
  final noteBloc = AddTransactionsBloc();
  final dateBloc = AddTransactionsBloc();
  final detailBloc = AddTransactionsBloc();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => nameBloc),
        BlocProvider(create: (_) => noteBloc),
        BlocProvider(create: (_) => dateBloc),
        BlocProvider(create: (_) => detailBloc),
      ],
      child: BlocListener<AddTransactionsBloc, AddTransactionsState>(
        listener: (context, state) {
          if (!state.isLoading &&
              state.errorMessagePush.isEmpty &&
              state.isSuccessAdd) {
            Navigator.pop(context, 'Transaction Added');
          }
        },
        child: BlocBuilder<AddTransactionsBloc, AddTransactionsState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: ColorList.whiteColor,
              body: ListView(
                  padding: EdgeInsets.only(
                      top: FontList.font24 + MediaQuery.of(context).padding.top,
                      right: FontList.font24,
                      left: FontList.font24),
                  children: [
                    Row(
                      spacing: FontList.font16,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                            alignment: Alignment.topRight,
                            'assets/icons/ic_left.svg',
                            height: FontList.font24,
                            width: FontList.font24,
                          ),
                        ),
                        Text(
                          'Tambah Transaksi',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: FontList.font32,
                              color: ColorList.blackColor),
                        ),
                      ],
                    ),
                    Gap(FontList.font24),
                    Form(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: FontList.font16,
                      children: [
                        CustomeTextFieldWithTitle(
                          textHint: 'masukkan nama transaksi',
                          textTitle: 'Nama Transaksi',
                          keypadType: TextInputType.text,
                          formSection: 'Name',
                          isError: state.errorText.isEmpty,
                          textFieldBloc: nameBloc,
                          controller: nameController,
                          focusNode: nameFocusNode,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              nameBloc.add(OnUpdateTransactionSectionError(
                                  true, 'Nama Transaksi Tidak Boleh Kosong'));
                            } else {
                              nameBloc.add(OnUpdateTransactionName(value));
                            }
                          },
                        ),
                        CustomeTextFieldWithTitle(
                          textHint: 'masukkan note transaksi',
                          textTitle: 'Catatan Transaksi',
                          keypadType: TextInputType.text,
                          formSection: 'Note',
                          textFieldBloc: noteBloc,
                          controller: noteController,
                          focusNode: noteFocusNode,
                          onChanged: (value) {
                            noteBloc.add(OnUpdateTransactionNote(value));
                          },
                        ),
                        CustomeTextFieldWithTitle(
                          textHint: 'masukkan tanggal transaksi',
                          textTitle: 'Tanggal Transaksi',
                          keypadType: TextInputType.text,
                          formSection: 'Date',
                          textFieldBloc: dateBloc,
                          controller: dateBloc.state.controller,
                          focusNode: dateFocusNode,
                          isDateSection: true,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              dateBloc.add(OnUpdateTransactionSectionError(true,
                                  'Tanggal Transaksi Tidak Boleh Kosong'));
                            } else {
                              DateTime dateValue =
                                  DateFormat("yyyy-MM-dd").parse(value);
                              dateBloc.add(OnUpdateTransactionDate(dateValue));
                            }
                          },
                        ),
                        Text(
                          'Rincian Transaksi',
                          style: TextStyle(
                            color: ColorList.blackColor,
                            fontSize: FontList.font20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: state.listDetailTransaction.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: FontList.font16),
                            itemBuilder: (context, index) {
                              return CustomeTextFieldWithDoubleForm(
                                firstTextHint: 'Pilih tipe rincian',
                                secondTextHint: 'Nama rincian',
                                thirdTextHint: '0',
                                index: index,
                                textFieldBloc: detailBloc,
                                isCancelButtonShow: index >= 1 ? true : false,
                                focusNodeName: state.focusNodeName[index],
                                focusNodePrice: state.focusNodePrice[index],
                                onChangedType: (value) {
                                  if (value != null) {
                                    detailBloc.add(
                                        OnUpdateDetailTransactionDropDownType(
                                            index: index, type: value.name));
                                  }
                                },
                                onChangedName: (value) {
                                  detailBloc.add(OnUpdateDetailTransactionName(
                                      index: index, value: value));
                                },
                                onChangedPrice: (value) {
                                  detailBloc.add(OnUpdateDetailTransactionPrice(
                                      index: index, value: value));
                                },
                              );
                            }),
                        GestureDetector(
                          onTap: () {
                            detailBloc.add(OnAddDetailSection());
                          },
                          child: Container(
                            width: double.infinity,
                            height: FontList.font48,
                            padding: EdgeInsets.symmetric(
                                horizontal: FontList.font8,
                                vertical: FontList.font4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorList.whiteColor100, width: 1.0),
                              borderRadius:
                                  BorderRadius.circular(FontList.font8),
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/ic_add.svg',
                              colorFilter: ColorFilter.mode(
                                  ColorList.grayColor200, BlendMode.srcIn),
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: FontList.font24
                          ),
                          child: ButtonPrimary(
                            onTap: () {
                              if (nameBloc.state.isError) {
                                ToastService.showToast(
                                    context, nameBloc.state.errorText, true);
                                return;
                              }
                              var nameValue = nameBloc.state.transactionName;
                              var noteValue = noteBloc.state.transactionNote;
                              var dateValue = dateBloc.state.transactionDate;
                              var detailValue =
                                  detailBloc.state.listDetailTransaction;
                          
                              detailBloc.add(OnSubmitAddTransactions(
                                  nameTransaction: nameValue,
                                  noteTransaction: noteValue,
                                  dateTimeValue: dateValue!,
                                  listDetailTransaction: detailValue));
                            },
                            buttonText: 'Selanjutnya',
                          ),
                        ),
                      ],
                    )),
                  ]),
            );
          },
        ),
      ),
    );
  }
}
