import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:petani_cerdas/models/transaction.dart';
import '../resources/style_config.dart';

class TransactionsItem extends StatefulWidget {
  final Transactions transactions;

  const TransactionsItem({super.key, required this.transactions});

  @override
  State<TransactionsItem> createState() => _TransactionsItemState();
}

class _TransactionsItemState extends State<TransactionsItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(FontList.font8),
          decoration: BoxDecoration(
            color: ColorList.whiteColor,
            border: Border.all(
              color: ColorList.whiteColor100,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(64, 0, 0, 0),
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: widget.transactions.type == "Pendapatan"
                            ? ColorList.primaryColor
                            : ColorList.redColor200,
                        borderRadius: BorderRadius.circular(50)),
                    height: FontList.font48,
                    width: FontList.font48,
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          color: widget.transactions.type == "Pendapatan"
                              ? ColorList.secondaryColor
                              : ColorList.redColor100,
                          borderRadius: BorderRadius.circular(50)),
                      height: FontList.font32,
                      width: FontList.font32,
                    ),
                  ),
                  Text(
                    widget.transactions.transactionName
                        .split(' ')
                        .take(2)
                        .map((word) => word[0].toUpperCase())
                        .join(''),
                    style: TextStyle(
                        color: ColorList.whiteColor,
                        fontSize: FontList.font24,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Gap(FontList.font8),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.transactions.transactionName,
                      style: TextStyle(
                          color: ColorList.blackColor,
                          fontSize: FontList.font16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rp ${widget.transactions.totalPrice.toString().replaceAllMapped(
                            RegExp(r'(\d)(?=(\d{3})+$)'),
                            (match) => '${match[1]}.',
                          )}',
                      style: TextStyle(
                          color: widget.transactions.type == "Pendapatan"
                              ? ColorList.primaryColor
                              : ColorList.redColor200,
                          fontWeight: FontWeight.bold,
                          fontSize: FontList.font20),
                    ),
                  ],
                ),
              ),
              Text(
                DateFormat('dd MMM yyyy').format(widget.transactions.date),
                style: TextStyle(
                    color: ColorList.grayColor200,
                    fontSize: FontList.font12,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }
}
