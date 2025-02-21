import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  final String calendarId;
  final DateTime scheduleDate;
  final DateTime scheduleEndTime;
  final String scheduleName;
  final String scheduleNote;
  final DateTime scheduleStartTime;
  final String userId;

  Schedule({
    required this.calendarId,
    required this.scheduleDate,
    required this.scheduleEndTime,
    required this.scheduleName,
    required this.scheduleNote,
    required this.scheduleStartTime,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'kalendar_id' : calendarId,
      'schedule_date' : scheduleDate,
      'schedule_end_time' : scheduleEndTime,
      'schedule_name' : scheduleName,
      'schedule_note' : scheduleNote,
      'schedule_start_time' : scheduleStartTime,
      'user_id' : userId,
    };
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule (
      calendarId: json['kalendar_id'] as String,
      scheduleDate: (json['schedule_date'] as Timestamp).toDate(),
      scheduleEndTime: (json['schedule_end_time'] as Timestamp).toDate(),
      scheduleName : json['schedule_name'] as String,
      scheduleNote : json['schedule_note'] as String,
      scheduleStartTime : (json['schedule_start_time'] as Timestamp).toDate(),
      userId: json['user_id'] as String,
    );
  }
}