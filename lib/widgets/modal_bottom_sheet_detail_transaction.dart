import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:petani_cerdas/bloc/transactions_bloc.dart';
import 'package:petani_cerdas/resources/style_config.dart';
import '../models/transaction.dart';

void showCustomModalBottomSheetDetailTransaction({
  required BuildContext context,
  bool isDismissible = false,
  bool enableDrag = false,
  required Transactions transaction,
}) {
  showModalBottomSheet(
    useSafeArea: true,
    context: context,
    isDismissible: isDismissible,
    backgroundColor: ColorList.whiteColor,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusDirectional.vertical(
        top: Radius.circular(FontList.font16),
      ),
    ),
    builder: (context) {
      return BlocProvider(
        create: (context) => TransactionsBloc()
          ..add(FetchDetailTransaction(transaction.transactionId)),
        child: BlocBuilder<TransactionsBloc, TransactionsState>(
          builder: (context, state) {
            return FractionallySizedBox(
              heightFactor: 0.65,
              child: Padding(
                padding: EdgeInsets.all(FontList.font24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            'Detail',
                            style: TextStyle(
                              fontSize: FontList.font24,
                              fontWeight: FontWeight.bold,
                              color: ColorList.blackColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                            'assets/icons/ic_exits.svg',
                            height: FontList.font24,
                            width: FontList.font24,
                          ),
                        ),
                      ],
                    ),
                    Gap(FontList.font24),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: FontList.font24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      width: FontList.font8,
                                      decoration: BoxDecoration(
                                        color: transaction.type == "Pendapatan" ? ColorList.primaryColor : ColorList.redColor200,
                                        borderRadius: BorderRadius.only(
                                          topLeft:
                                              Radius.circular(FontList.font8),
                                          bottomLeft:
                                              Radius.circular(FontList.font8),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: FontList.font12,
                                          vertical: FontList.font8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: ColorList.whiteColor,
                                          borderRadius: BorderRadius.only(
                                            topRight:
                                                Radius.circular(FontList.font8),
                                            bottomRight:
                                                Radius.circular(FontList.font8),
                                          ),
                                          border: Border.all(
                                            color: ColorList.whiteColor100,
                                            width: 1.0,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromARGB(64, 0, 0, 0),
                                              spreadRadius: 0,
                                              blurRadius: 2,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    DateFormat('dd MMM yyyy')
                                                        .format(transaction.date),
                                                    style: TextStyle(
                                                      color:
                                                          ColorList.grayColor200,
                                                      fontSize: FontList.font12,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    transaction.transactionName,
                                                    style: TextStyle(
                                                      color: ColorList.blackColor,
                                                      fontSize: FontList.font16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Rp ${transaction.totalPrice.toString().replaceAllMapped(
                                                          RegExp(
                                                              r'(\d)(?=(\d{3})+$)'),
                                                          (match) =>
                                                              '${match[1]}.',
                                                        )}',
                                                    style: TextStyle(
                                                      color:
                                                          transaction.type == "Pendapatan" ? ColorList.primaryColor : ColorList.redColor200,
                                                      fontSize: FontList.font20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: transaction.type ==
                                                              "Pendapatan"
                                                          ? ColorList.primaryColor
                                                          : ColorList.redColor200,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  height: FontList.font48,
                                                  width: FontList.font48,
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: transaction.type ==
                                                                "Pendapatan"
                                                            ? ColorList
                                                                .secondaryColor
                                                            : ColorList
                                                                .redColor100,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                50)),
                                                    height: FontList.font32,
                                                    width: FontList.font32,
                                                  ),
                                                ),
                                                Text(
                                                  transaction.transactionName
                                                      .split(' ')
                                                      .take(2)
                                                      .map((word) =>
                                                          word[0].toUpperCase())
                                                      .join(''),
                                                  style: TextStyle(
                                                      color: ColorList.whiteColor,
                                                      fontSize: FontList.font24,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Gap(FontList.font16),
                              Text(
                                'Rincian Transaksi',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: FontList.font20,
                                  color: ColorList.blackColor,
                                ),
                              ),
                              Gap(FontList.font8),
                              Container(
                                  padding: EdgeInsets.all(FontList.font16),
                                  decoration: BoxDecoration(
                                    color: ColorList.whiteColor,
                                    border: Border.all(
                                      color: ColorList.whiteColor100,
                                      width: 1.0,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(FontList.font8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(64, 0, 0, 0),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      ListView.separated(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        separatorBuilder: (context, index) =>
                                            SizedBox(height: FontList.font16),
                                        itemCount:
                                            state.listDetailTransaction.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      state
                                                          .listDetailTransaction[
                                                              index]
                                                          .name,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: FontList.font16,
                                                        color: ColorList
                                                            .grayColor200,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Rp ${state.listDetailTransaction[index].price.split('.')[0].replaceAllMapped(
                                                          RegExp(
                                                              r'(\d)(?=(\d{3})+(?!\d))'),
                                                          (match) =>
                                                              '${match[1]}.',
                                                        )}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: FontList.font16,
                                                      color: state
                                                                  .listDetailTransaction[
                                                                      index]
                                                                  .type ==
                                                              'Pendapatan'
                                                          ? ColorList.primaryColor
                                                          : ColorList.redColor100,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Gap(FontList.font16),
                                              Container(
                                                height: 1,
                                                decoration: BoxDecoration(
                                                  color: ColorList.grayColor200,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      Gap(FontList.font16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Total',
                                              style: TextStyle(
                                                  color: ColorList.blackColor,
                                                  fontSize: FontList.font16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(
                                            'Rp ${transaction.totalPrice.toString().replaceAllMapped(
                                                  RegExp(r'(\d)(?=(\d{3})+$)'),
                                                  (match) => '${match[1]}.',
                                                )}',
                                            style: TextStyle(
                                                color: transaction.type ==
                                                        "Pendapatan"
                                                    ? ColorList.primaryColor
                                                    : ColorList.redColor200,
                                                fontWeight: FontWeight.bold,
                                                fontSize: FontList.font16),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
