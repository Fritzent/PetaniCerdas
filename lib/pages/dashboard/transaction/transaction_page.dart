import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:petani_cerdas/bloc/transactions_bloc.dart';
import 'package:petani_cerdas/repository/user_service.dart';
import 'package:petani_cerdas/resources/style_config.dart';
import 'package:petani_cerdas/widgets/page_header.dart';
import 'package:petani_cerdas/widgets/transactions_item.dart';

import '../../../widgets/custom_toast.dart';
import '../../../widgets/modal_bottom_sheet_sort.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final ScrollController _scrollController = ScrollController();
  late TransactionsBloc bloc;
  late UserService userService;
  Timer? _debounce;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userService = RepositoryProvider.of<UserService>(context);

    bloc = TransactionsBloc(userService: userService);
  }

  @override
  void initState() {
    super.initState();
    //bloc = TransactionsBloc()..add(FetchTransaction());
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
    return BlocProvider(
      //value: bloc,
      create: (context) => bloc..add(FetchTransaction()),
      child: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (!state.isLoading &&
              state.groupedTransactions.isEmpty &&
              state.isEmpty) {
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
                right: 0,
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
            ]);
          }

          return Padding(
            padding: EdgeInsets.only(
                top: FontList.font24 + MediaQuery.of(context).padding.top,
                right: FontList.font24,
                left: FontList.font24),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: FontList.font20,
                  children: [
                    PageHeader(
                      pageTitle: 'Transaksi',
                      hasRightIcon: state.groupedTransactions.isNotEmpty,
                      rightIcon: 'assets/icons/ic_filter.svg',
                      rightIconOnTap: () {
                        showCustomModalBottomSheet(
                          context: context,
                          bloc: context.read<TransactionsBloc>(),
                        );
                      },
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(0),
                        controller: _scrollController,
                        itemCount: state.groupedTransactions.length + 1,
                        itemBuilder: (context, index) {
                          if (index == state.groupedTransactions.length) {
                            return state.isLoadingLoadMore
                                ? Center(child: CircularProgressIndicator())
                                : SizedBox.shrink();
                          }

                          var entry = state.groupedTransactions.entries
                              .elementAt(index);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: FontList.font16,
                                    color: ColorList.blackColor),
                              ),
                              ...entry.value.map((transaction) => Padding(
                                    padding: const EdgeInsets.only(
                                        top: FontList.font16,
                                        bottom: FontList.font16),
                                    child: TransactionsItem(
                                      transactions: transaction,
                                      userService: userService,
                                    ),
                                  )),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  bottom: FontList.font105,
                  child: FloatingActionButton(
                    onPressed: () async {
                      var result = await Navigator.pushNamed(
                          context, '/add_transaction');

                      if (result != null) {
                        if (!context.mounted) return;
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
            ),
          );
        },
      ),
    );
  }
}
