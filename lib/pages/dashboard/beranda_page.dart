import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:petani_cerdas/bloc/auth_user_bloc.dart';
import 'package:petani_cerdas/bloc/dashboard_bloc.dart';
import 'package:petani_cerdas/widgets/transactions_item.dart';

import '../../repository/user_service.dart';
import '../../resources/style_config.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  late UserService userService;
  Stream<DateTime> get timeStream =>
      Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userService = RepositoryProvider.of<UserService>(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthUserBloc()..add(OnGetUserName()),
          ),
          BlocProvider(
            create: (context) => DashboardBloc()..add(OnGetLatestTransaction()),
            //create: (context) => DashboardBloc(),
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
                  'Jadwal Kegiatan',
                  style: GoogleFonts.inriaSans(
                      fontSize: FontList.font20,
                      fontWeight: FontWeight.bold,
                      color: ColorList.blackColor),
                ),
                Gap(FontList.font8),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      vertical: FontList.font21, horizontal: FontList.font14),
                  decoration: BoxDecoration(
                    color: ColorList.whiteColor,
                    border: Border.all(
                      color: ColorList.whiteColor100,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(FontList.font8),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(64, 0, 0, 0),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    spacing: FontList.font8,
                    children: [
                      Container(
                        padding: EdgeInsets.all(FontList.font10),
                        decoration: BoxDecoration(
                          color: ColorList.primaryColor,
                          borderRadius: BorderRadius.circular(FontList.font6),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Rab',
                              style: TextStyle(
                                  fontSize: FontList.font16,
                                  fontWeight: FontWeight.bold,
                                  color: ColorList.whiteColor),
                            ),
                            Text(
                              '21',
                              style: TextStyle(
                                  fontSize: FontList.font36,
                                  fontWeight: FontWeight.bold,
                                  color: ColorList.whiteColor),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Container(
                              padding: EdgeInsets.all(FontList.font8),
                              decoration: BoxDecoration(
                                color: ColorList.whiteColor,
                                border: Border.all(
                                  color: ColorList.whiteColor100,
                                  width: 1.0,
                                ),
                                borderRadius:
                                    BorderRadius.circular(FontList.font8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: FontList.font2,
                                children: [
                                  Text(
                                    'Panen Hari Ke - 1',
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: FontList.font20,
                                        fontWeight: FontWeight.bold,
                                        color: ColorList.blackColor),
                                  ),
                                  Text(
                                    'Jangan lupa bawa nasi dan rokok untuk tukang panen',
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: FontList.font14,
                                        fontWeight: FontWeight.normal,
                                        color: ColorList.blackColor),
                                  ),
                                  Text(
                                    '10.00 WIB - 15.00 WIB',
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: FontList.font12,
                                        fontWeight: FontWeight.bold,
                                        color: ColorList.grayColor200),
                                  ),
                                ],
                              ))),
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
                ),
                Gap(FontList.font8),
                BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {
                  if (state.isLoadingLoadLatestTransaction) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: ColorList.primaryColor,
                      ),
                    );
                  } else if (!state.isLoadingLoadLatestTransaction &&
                      state.listLatestTransaction.isEmpty &&
                      state.isEmpty) {
                    return Expanded(
                      child: Center(
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
                    );
                  }

                  return Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(bottom: FontList.font16),
                      children: [
                        ...state.listLatestTransaction.map((transaction) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: FontList.font16),
                            child: TransactionsItem(transactions: transaction, userService:  userService,),
                          );
                        })
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ));
  }
}
