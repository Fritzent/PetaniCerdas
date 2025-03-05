import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:petani_cerdas/bloc/add_calendar_bloc.dart';
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
  TextEditingController nameCalendarController = TextEditingController();
  TextEditingController noteCalendarController = TextEditingController();
  TextEditingController dateCalendarController = TextEditingController();
  TextEditingController dateHourCalendarController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode noteFocusNode = FocusNode();
  FocusNode dateFocusNode = FocusNode();
  FocusNode dateHourFocusNode = FocusNode();

  late AddCalendarBloc nameBloc;
  late AddCalendarBloc noteBloc;
  late AddCalendarBloc dateBloc;
  late AddCalendarBloc dateHourBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    nameBloc = AddCalendarBloc();
    noteBloc = AddCalendarBloc();
    dateBloc = AddCalendarBloc();
    dateHourBloc = AddCalendarBloc();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => nameBloc),
        BlocProvider(create: (_) => noteBloc),
        BlocProvider(create: (_) => dateBloc),
        BlocProvider(create: (_) => dateHourBloc),
      ],
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
                        // textFieldBloc: nameBloc,
                        // controller: nameCalendarController,
                        focusNode: nameFocusNode),
                    CustomeTextFieldWithTitleCalendar(
                        textHint: 'masukkan catatan kegiatan',
                        textTitle: 'Catatan Kegiatan',
                        keypadType: TextInputType.text,
                        formSection: 'Note',
                        // textFieldBloc: noteBloc,
                        // controller: noteCalendarController,
                        focusNode: noteFocusNode),
                    CustomeTextFieldWithTitleCalendar(
                      textHint: 'masukkan tanggal kegiatan',
                      textTitle: 'Tanggal Kegiatan',
                      keypadType: TextInputType.text,
                      formSection: 'Date',
                      // textFieldBloc: dateBloc,
                      // controller: dateBloc.state.controller,
                      focusNode: dateFocusNode,
                      isDateSection: true,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          // dateBloc.add(OnUpdateTransactionSectionError(true,
                          //     'Tanggal Transaksi Tidak Boleh Kosong'));
                        } else {
                          // DateTime dateValue =
                          //     DateFormat("yyyy-MM-dd").parse(value);
                          // dateBloc.add(OnUpdateTransactionDate(dateValue));
                        }
                      },
                    ),
                    CustomeTextFieldWithTitleCalendar(
                        textHint: 'masukkan jam kegiatan',
                        textTitle: 'Jam Kegiatan',
                        keypadType: TextInputType.text,
                        formSection: 'DateHour',
                        // textFieldBloc: dateHourBloc,
                        // controller: dateHourCalendarController,
                        focusNode: dateHourFocusNode),
                    Gap(FontList.font24),
                    ButtonPrimary(
                      onTap: () {
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
    );
  }
}
