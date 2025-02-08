import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:petani_cerdas/cubit/bottom_nav_cubit.dart';
import 'package:petani_cerdas/pages/dashboard/beranda_page.dart';
import 'package:petani_cerdas/pages/dashboard/calendar_page.dart';
import 'package:petani_cerdas/pages/dashboard/settings_page.dart';
import 'package:petani_cerdas/pages/dashboard/transaction_page.dart';
import 'package:petani_cerdas/resources/style_config.dart';

import '../../widgets/custom_toast.dart';

class DashboardPage extends StatefulWidget {
  final FlutterLocalNotificationsPlugin notificationsPlugin;
  const DashboardPage({super.key, required this.notificationsPlugin});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final String userUid;

  final fragments = [
    const BerandaPage(),
    const TransactionPage(),
    const CalendarPage(),
    const SettingsPage(),
  ];

  Future<void> requestNotificationPermission(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    if (Platform.isIOS) {
      final iosImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      if (iosImplementation != null) {
        final bool? result = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        print('iOS notification permission granted: $result');
      }
    } else if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      if (status.isGranted) {
        print('Android notification permission granted');
      } else {
        print('Android notification permission denied');
      }
    }
  }

  @override
  void initState() {
    readUserDataInStorage();
    requestNotificationPermission(widget.notificationsPlugin);
    super.initState();
  }

  Future<void> readUserDataInStorage() async {
    final FlutterSecureStorage secureStorage = FlutterSecureStorage();
    String? getUserId = (await secureStorage.read(key: 'login_user'));
    if (getUserId != null) {
      userUid = getUserId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: BlocProvider(
        create: (context) => BottomNavCubit(),
        child: Scaffold(
          extendBody: true,
          body: BlocBuilder<BottomNavCubit, int>(
            builder: (context, currentIndex) {
              return fragments[currentIndex];
            },
          ),
          bottomNavigationBar: BlocBuilder<BottomNavCubit, int>(
            builder: (context, currentIndex) {
              final bottomNavCubit = context.read<BottomNavCubit>();
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ToastService.buildToast(),
                  Container(
                    margin: EdgeInsets.only(bottom: FontList.font24),
                    padding: const EdgeInsets.symmetric(
                      horizontal: FontList.font16,
                      vertical: FontList.font15,
                    ),
                    decoration: BoxDecoration(
                      color: ColorList.whiteColor,
                      border: Border.all(
                        color: ColorList.whiteColor200,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(FontList.font8),
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
                      spacing: FontList.font16,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildItemNav(
                            label: 'Beranda',
                            icon: 'assets/icons/ic_dashboard.svg',
                            iconOn: 'assets/icons/ic_dashboard.svg',
                            isActive: currentIndex == 0,
                            onTap: () {
                              bottomNavCubit.changeTab(0);
                            }),
                        buildItemNav(
                            label: 'Transaksi',
                            icon: 'assets/icons/ic_transaction.svg',
                            iconOn: 'assets/icons/ic_transaction.svg',
                            isActive: currentIndex == 1,
                            onTap: () {
                              bottomNavCubit.changeTab(1);
                            }),
                        buildItemNav(
                            label: 'Jadwal',
                            icon: 'assets/icons/ic_calendar.svg',
                            iconOn: 'assets/icons/ic_calendar.svg',
                            isActive: currentIndex == 2,
                            onTap: () {
                              bottomNavCubit.changeTab(2);
                            }),
                        buildItemNav(
                            label: 'Setelan',
                            icon: 'assets/icons/ic_settings.svg',
                            iconOn: 'assets/icons/ic_settings.svg',
                            isActive: currentIndex == 3,
                            onTap: () {
                              bottomNavCubit.changeTab(3);
                            }),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildItemNav({
    required String label,
    required String icon,
    required String iconOn,
    bool isActive = false,
    required VoidCallback onTap,
    bool hasNewUpdate = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: isActive
            ? BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: ColorList.primaryColor,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8),
              )
            : BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: ColorList.whiteColor100,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
        child: Row(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              isActive ? iconOn : icon,
              colorFilter: ColorFilter.mode(
                  isActive ? ColorList.primaryColor : ColorList.grayColor200,
                  BlendMode.srcIn),
              height: 15,
              width: 15,
            ),
            if (isActive)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: FontList.font14,
                        color: ColorList.primaryColor),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
