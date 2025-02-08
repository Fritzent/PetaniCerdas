import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationService({required this.flutterLocalNotificationsPlugin});

  Future<void> showTransactionNotification() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      'Transaksi Berhasil Di Simpan',
      'Anda baru saja berhasil menambahkan transaksi baru',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'transaction_channel',
          'Transaction Notifications',
          channelDescription: 'Notification channel for transaction status',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: 'Transaction Payload',
    );
  }
}