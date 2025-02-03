import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:petani_cerdas/bloc/auth_user_bloc.dart';
import 'package:petani_cerdas/bloc/transactions_bloc.dart';

import '../../resources/style_config.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  Stream<DateTime> get timeStream =>
      Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthUserBloc()..add(OnGetUserName()),
          ),
          BlocProvider(
            create: (context) => TransactionsBloc(),
          ),
        ],
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
                top: FontList.font24 + MediaQuery.of(context).padding.top,
                right: FontList.font24,
                left: FontList.font24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Text(
                            'PeTani',
                            style: GoogleFonts.inriaSans(
                                fontSize: FontList.font16,
                                fontWeight: FontWeight.bold,
                                color: ColorList.blackColor),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(39, 15, 0, 0),
                            child: Text(
                              'Cerdas',
                              style: GoogleFonts.inriaSans(
                                  fontSize: FontList.font32,
                                  fontWeight: FontWeight.bold,
                                  color: ColorList.blackColor),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(FontList.font12),
                      decoration: BoxDecoration(
                        color: ColorList.whiteColor,
                        border: Border.all(
                          color: ColorList.whiteColor100,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(FontList.font16),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(64, 0, 0, 0),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        alignment: Alignment.topRight,
                        'assets/icons/ic_notif.svg',
                        height: FontList.font32,
                        width: FontList.font32,
                      ),
                    ),
                  ],
                ),
                Gap(FontList.font32),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: FontList.font8, vertical: FontList.font12),
                  decoration: BoxDecoration(
                    color: ColorList.whiteColor,
                    border: Border.all(
                      color: ColorList.whiteColor100,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(FontList.font16),
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
                    children: [
                      Expanded(
                        child: BlocBuilder<AuthUserBloc, AuthUserState>(
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sudah cek jadwal kebunmu hari ini?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorList.grayColor400,
                                      fontSize: FontList.font14),
                                ),
                                Text(
                                  '${state.userName},',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorList.blackColor,
                                      fontSize: FontList.font24),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                      Gap(FontList.font16),
                      StreamBuilder<DateTime>(
                        stream: timeStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator(
                              color: ColorList.primaryColor,
                            );
                          }
                          return Text(
                            DateFormat('HH:mm a').format(snapshot.data!),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorList.grayColor400,
                                fontSize: FontList.font14),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Gap(FontList.font16),
                Text(
                  'Transaksi Terakhir',
                  style: GoogleFonts.inriaSans(
                      fontSize: FontList.font20,
                      fontWeight: FontWeight.bold,
                      color: ColorList.blackColor),
                )
              ],
            ),
          ),
        ));
  }
}
