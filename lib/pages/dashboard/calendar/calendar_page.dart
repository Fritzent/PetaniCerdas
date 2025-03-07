import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:petani_cerdas/bloc/calendar_bloc.dart';
import 'package:petani_cerdas/widgets/page_header.dart';

import '../../../models/schedule.dart';
import '../../../repository/user_service.dart';
import '../../../resources/style_config.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late UserService userService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userService = RepositoryProvider.of<UserService>(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CalendarBloc(userService: userService)..add(InitialCalendar()),
      child: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          final bloc = context.read<CalendarBloc>();
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.only(
                top: FontList.font24 + MediaQuery.of(context).padding.top,
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: FontList.font24),
                        child: PageHeader(
                          pageTitle: DateFormat('MMMM yyyy')
                              .format(state.selectedDate),
                          hasRightIcon: true,
                          rightIcon: 'assets/icons/ic_filter.svg',
                        ),
                      ),
                      Gap(FontList.font32),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: FontList.font24),
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.14,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: state.dateList.length,
                                itemBuilder: (context, index) {
                                  DateTime date = state.dateList[index];
                                  bool isSelected = date.day ==
                                          state.selectedDate.day &&
                                      date.month == state.selectedDate.month &&
                                      date.year == state.selectedDate.year;

                                  return GestureDetector(
                                    onTap: () {
                                      bloc.add(SelectedDate(date));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: index != 0 && index != 7
                                              ? FontList.font10
                                              : 0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: FontList.font6,
                                          vertical: FontList.font10),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? ColorList.primaryColor
                                            : ColorList.whiteColor,
                                        borderRadius: BorderRadius.circular(
                                            FontList.font6),
                                        border: Border.all(
                                          color: isSelected
                                              ? ColorList.primaryColor
                                              : ColorList.primaryColor,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            DateFormat.E('id_ID').format(date),
                                            style: TextStyle(
                                              fontSize: FontList.font16,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? ColorList.whiteColor
                                                  : ColorList.primaryColor,
                                            ),
                                          ),
                                          Text(
                                            "${date.day}",
                                            style: TextStyle(
                                              fontSize: FontList.font36,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? ColorList.whiteColor
                                                  : ColorList.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(FontList.font16),
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          color: ColorList.whiteColor,
                          border: Border.all(
                            color: ColorList.grayColor200,
                            width: 1.0,
                          ),
                        ),
                      ),
                      Gap(FontList.font16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.timeSlots.length,
                            itemBuilder: (context, index) {
                              String formattedTime = DateFormat('HH:mm a')
                                  .format(state.timeSlots[index]);
                              DateTime dateIndex = state.timeSlots[index];
                              List<Schedule> taskDetails = state.groupedScheduleTasks.entries
                              .where((entry) => entry.value.any((e) => e.scheduleDate.day == dateIndex.day && e.scheduleDate.hour == dateIndex.hour))
                              .map((entry) => entry.value)
                              .expand((list) => list)
                              .toList();

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 8),
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(0),
                                          width: 1,
                                          decoration: BoxDecoration(
                                            color: ColorList.whiteColor,
                                            border: Border(
                                              top: BorderSide(
                                                  color:
                                                      ColorList.whiteColor100,
                                                  width: 1.0),
                                            ),
                                          ),
                                          child: Text(
                                            formattedTime,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.all(0),
                                          width: 1,
                                          color: ColorList.whiteColor100),
                                      Gap(FontList.font8),
                                      Expanded(
                                          flex: 3,
                                          child: taskDetails.isNotEmpty
                                              ? Column(
                                                  children:
                                                      taskDetails.map((task) {
                                                    return Container(
                                                        width: double.infinity,
                                                        margin: EdgeInsets.only(
                                                            bottom: 4),
                                                        padding: EdgeInsets.all(
                                                            FontList.font8),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black12,
                                                              blurRadius: 4,
                                                              offset:
                                                                  Offset(0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              task.scheduleName,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: ColorList
                                                                      .blackColor),
                                                            ),
                                                            Text(
                                                              task.scheduleNote,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: ColorList
                                                                      .blackColor),
                                                            ),
                                                          ],
                                                        ));
                                                  }).toList(),
                                                )
                                              : SizedBox(height: 50)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    bottom: FontList.font105,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/add_calendar');
                      },
                      tooltip: 'Tambah Jadwal',
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
            ),
          );
        },
      ),
    );
  }
}
