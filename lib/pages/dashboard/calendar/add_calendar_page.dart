import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:petani_cerdas/bloc/add_calendar_bloc.dart';
import 'package:petani_cerdas/models/schedule.dart';
import '../../../repository/user_service.dart';
import '../../../resources/style_config.dart';
import '../../../widgets/button_primary.dart';
import '../../../widgets/custome_text_field_with_title_calendar.dart';
import '../../../widgets/page_header.dart';

class AddCalendarPage extends StatefulWidget {
  const AddCalendarPage({super.key});

  @override
  State<AddCalendarPage> createState() => _AddCalendarPageState();
}

class _AddCalendarPageState extends State<AddCalendarPage> {
  late AddCalendarBloc calendarBloc;
  late UserService userService;

  String nameValue = '';
  String noteValue = '';
  DateTime dateValue = DateTime.now();
  DateTime hourValue = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userService = RepositoryProvider.of<UserService>(context);

    calendarBloc = AddCalendarBloc(userService: userService);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => calendarBloc,
      child: BlocListener<AddCalendarBloc, AddCalendarState>(
        listener: (context, state) {
          if (!state.isLoading &&
              state.errorMessagePush.isEmpty &&
              state.isSuccesAdd) {
            Navigator.pop(context, 'CalendarEvent Added');
          }
        },
        child: BlocBuilder<AddCalendarBloc, AddCalendarState>(
          builder: (context, state) {
            return Scaffold(
                body: ListView(
              padding: EdgeInsets.only(
                  top: FontList.font24 + MediaQuery.of(context).padding.top,
                  right: FontList.font24,
                  left: FontList.font24),
              children: [
                PageHeader(
                  pageTitle: 'Tambah Jadwal',
                  hasLeftIcon: true,
                  leftIcon: 'assets/icons/ic_left.svg',
                  leftIconOnTap: () {
                    Navigator.pop(context);
                  },
                ),
                Gap(FontList.font24),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: FontList.font16,
                    children: [
                      CustomeTextFieldWithTitleCalendar(
                        textHint: 'masukkan nama jadwal kegiatan',
                        textTitle: 'Nama Kegiatan',
                        keypadType: TextInputType.text,
                        formSection: 'Name',
                        onChanged: (value) {
                          nameValue = value;
                        },
                      ),
                      CustomeTextFieldWithTitleCalendar(
                        textHint: 'masukkan catatan kegiatan',
                        textTitle: 'Catatan Kegiatan',
                        keypadType: TextInputType.text,
                        formSection: 'Note',
                        onChanged: (value) {
                          noteValue = value;
                        },
                      ),
                      CustomeTextFieldWithTitleCalendar(
                        textHint: 'masukkan tanggal kegiatan',
                        textTitle: 'Tanggal Kegiatan',
                        keypadType: TextInputType.text,
                        formSection: 'Date',
                        isDateSection: true,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            DateTime selectedDate =
                                DateFormat("dd-MM-yyyy").parse(value);
                            dateValue = selectedDate;
                          }
                        },
                      ),
                      CustomeTextFieldWithTitleCalendar(
                        textHint: 'masukkan jam kegiatan',
                        textTitle: 'Jam Kegiatan',
                        keypadType: TextInputType.text,
                        formSection: 'DateHour',
                        isDateHourSection: true,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            DateTime dateHourSelected =
                                DateFormat('HH:mm').parse(value);
                            hourValue = dateHourSelected;
                          }
                        },
                      ),
                      Gap(FontList.font24),
                      ButtonPrimary(
                        onTap: () {
                          DateTime combinedDateTime = DateTime(
                            dateValue.year,
                            dateValue.month,
                            dateValue.day,
                            hourValue.hour,
                            hourValue.minute,
                          );
                          Schedule newCalendar = Schedule(
                              calendarId: '',
                              scheduleDate: combinedDateTime,
                              scheduleEndTime: combinedDateTime,
                              scheduleName: nameValue,
                              scheduleNote: noteValue,
                              scheduleStartTime: combinedDateTime,
                              userId: '');
                          calendarBloc.add(OnSubmitNewCalendar(newCalendar));
                        },
                        buttonText: 'Simpan',
                      ),
                    ],
                  ),
                )
              ],
            ));
          },
        ),
      ),
    );
  }
}
