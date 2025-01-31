import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:petani_cerdas/bloc/transactions_bloc.dart';
import 'package:petani_cerdas/resources/style_config.dart';
import 'package:petani_cerdas/widgets/transactions_item.dart';

import '../../widgets/custom_toast.dart';
import '../../widgets/modal_bottom_sheet_sort.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionsBloc()..add(FetchTransaction()),
      child: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (!state.isLoading && state.groupedTransactions.isEmpty) {
            return Stack(children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/empty_transaction.png'),
                    Gap(FontList.font18),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: FontList.font24,
                      ),
                      child: Text(
                        'Belum ada transaksi tercatat saat ini',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: FontList.font20,
                            color: ColorList.blackColor),
                      ),
                    ),
                    Gap(FontList.font4),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: FontList.font48),
                      child: Text(
                        'Yuk, mulai catat dan kelola keuanganmu dengan mudah!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: FontList.font14,
                            color: ColorList.grayColor300),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: FontList.font24,
                bottom: FontList.font105,
                child: FloatingActionButton(
                  onPressed: () async {
                    var result =
                        await Navigator.pushNamed(context, '/add_transaction');
                    
                    if (result != null) {
                      ToastService.showToast(context, 'Transaksi berhasil disimpan', false);
                    }
                  },
                  tooltip: 'Tambah transaksi',
                  backgroundColor: ColorList.primaryColor,
                  shape: StadiumBorder(),
                  child: SvgPicture.asset(
                    alignment: Alignment.topRight,
                    'assets/icons/ic_add.svg',
                    height: FontList.font32,
                    width: FontList.font32,
                  ),
                ),
              )
            ]);
          }

          return Stack(
            children: [
              ListView(
                  padding: EdgeInsets.only(
                      top: FontList.font24 + MediaQuery.of(context).padding.top,
                      right: FontList.font24,
                      left: FontList.font24),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Transaksi',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: FontList.font32,
                                color: ColorList.blackColor),
                          ),
                        ),
                        if (state.groupedTransactions.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              showCustomModalBottomSheet(
                                context: context,
                                bloc: context.read<TransactionsBloc>(),
                              );
                            },
                            child: SvgPicture.asset(
                              alignment: Alignment.topRight,
                              'assets/icons/ic_filter.svg',
                              height: FontList.font24,
                              width: FontList.font24,
                            ),
                          ),
                      ],
                    ),
                    ...state.groupedTransactions.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(FontList.font16),
                          Text(
                            entry.key,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: FontList.font16,
                                color: ColorList.blackColor),
                          ),
                          Gap(FontList.font16),
                          ...entry.value.map((transaction) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: FontList.font16),
                              child: TransactionsItem(
                                transactions: transaction,
                              ),
                            );
                          }),
                        ],
                      );
                    }),
                  ]),
              Positioned(
                right: FontList.font24,
                bottom: FontList.font105,
                child: FloatingActionButton(
                  onPressed: () async {
                    var result =
                        await Navigator.pushNamed(context, '/add_transaction');
                    
                    if (result != null) {
                      ToastService.showToast(context, 'Transaksi berhasil disimpan', false);
                    }
                  },
                  tooltip: 'Tambah transaksi',
                  backgroundColor: ColorList.primaryColor,
                  shape: StadiumBorder(),
                  child: SvgPicture.asset(
                    alignment: Alignment.topRight,
                    'assets/icons/ic_add.svg',
                    height: FontList.font32,
                    width: FontList.font32,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
