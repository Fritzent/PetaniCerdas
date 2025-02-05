import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  final ScrollController _scrollController = ScrollController();
  late TransactionsBloc bloc;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    bloc = TransactionsBloc()..add(FetchTransaction());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    bloc.close();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(milliseconds: 300), () {
        if (!bloc.state.isLoading) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            bloc.add(LoadMoreTransactions());
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      //create: (context) => TransactionsBloc()..add(FetchTransaction()),
      child: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) {
          // if (state.isLoading) {
          //   return Center(child: CircularProgressIndicator());
          // } else if (!state.isLoading && state.groupedTransactions.isEmpty) {
          //   return Stack(children: [
          //     Center(
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           Image.asset('assets/images/empty_transaction.png'),
          //           Gap(FontList.font18),
          //           Padding(
          //             padding: const EdgeInsets.symmetric(
          //               horizontal: FontList.font24,
          //             ),
          //             child: Text(
          //               'Belum ada transaksi tercatat saat ini',
          //               textAlign: TextAlign.center,
          //               style: TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: FontList.font20,
          //                   color: ColorList.blackColor),
          //             ),
          //           ),
          //           Gap(FontList.font4),
          //           Padding(
          //             padding: const EdgeInsets.symmetric(
          //                 horizontal: FontList.font48),
          //             child: Text(
          //               'Yuk, mulai catat dan kelola keuanganmu dengan mudah!',
          //               textAlign: TextAlign.center,
          //               style: TextStyle(
          //                   fontWeight: FontWeight.normal,
          //                   fontSize: FontList.font14,
          //                   color: ColorList.grayColor300),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //     Positioned(
          //       right: FontList.font24,
          //       bottom: FontList.font105,
          //       child: FloatingActionButton(
          //         onPressed: () async {
          //           var result =
          //               await Navigator.pushNamed(context, '/add_transaction');

          //           if (result != null) {
          //             ToastService.showToast(
          //                 context, 'Transaksi berhasil disimpan', false);
          //           }
          //         },
          //         tooltip: 'Tambah transaksi',
          //         backgroundColor: ColorList.primaryColor,
          //         shape: StadiumBorder(),
          //         child: SvgPicture.asset(
          //           alignment: Alignment.topRight,
          //           'assets/icons/ic_add.svg',
          //           height: FontList.font32,
          //           width: FontList.font32,
          //         ),
          //       ),
          //     )
          //   ]);
          // }

          return Stack(
            children: [
              ListView.builder(
                controller: _scrollController,
                itemCount: state.groupedTransactions.length +
                    1,
                itemBuilder: (context, index) {
                  if (index == state.groupedTransactions.length) {
                    return state.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox.shrink();
                  }

                  var entry =
                      state.groupedTransactions.entries.elementAt(index);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          entry.key,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),
                      ...entry.value.map((transaction) => TransactionsItem(
                            transactions: transaction,
                          )),
                    ],
                  );
                },
              ),
              Positioned(
                right: FontList.font24,
                bottom: FontList.font105,
                child: FloatingActionButton(
                  onPressed: () async {
                    var result =
                        await Navigator.pushNamed(context, '/add_transaction');

                    if (result != null) {
                      ToastService.showToast(
                          context, 'Transaksi berhasil disimpan', false);
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
