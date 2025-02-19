import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:petani_cerdas/widgets/page_header.dart';

import '../../resources/style_config.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDate = DateTime.now();
  List<DateTime> timeSlots = [];

  List<DateTime> get dateList {
    return List.generate(
        7, (index) => selectedDate.subtract(Duration(days: 3 - index)));
  }

  Map<String, List<String>> scheduledTasks = {
    "16:00 WIB": [
      "Panen Hari Ke - 1\nJangan lupa bawa nasi dan rokok untuk tukang panen",
      "Panen Hari Ke - 4\nJangan lupa bawa nasi dan rokok untuk tukang panen",
      "Panen Hari Ke - 4\nJangan lupa bawa nasi dan rokok untuk tukang panen",
      "Panen Hari Ke - 4\nJangan lupa bawa nasi dan rokok untuk tukang panen",
    ],
    "17:00 WIB": [
      "Panen Hari Ke - 2\nJangan lupa bawa nasi dan rokok untuk tukang panen",
      "Panen Hari Ke - 4\nJangan lupa bawa nasi dan rokok untuk tukang panen",
      "Panen Hari Ke - 4\nJangan lupa bawa nasi dan rokok untuk tukang panen",
      "Panen Hari Ke - 4\nJangan lupa bawa nasi dan rokok untuk tukang panen",
    ],
    "18:00 WIB": [
      "Panen Hari Ke - 3\nJangan lupa bawa nasi dan rokok untuk tukang panen",
      "Panen Hari Ke - 4\nJangan lupa bawa nasi dan rokok untuk tukang panen",
      "Panen Hari Ke - 4\nJangan lupa bawa nasi dan rokok untuk tukang panen",
      "Panen Hari Ke - 4\nJangan lupa bawa nasi dan rokok untuk tukang panen",
      "Panen Hari Ke - 4\nJangan lupa bawa nasi dan rokok untuk tukang panen",
    ],
    "00:00 WIB": [
      "Panen Hari Ke - 3\nJangan lupa bawa nasi dan rokok untuk tukang panen",
      "Panen Hari Ke - 4\nJangan lupa bawa nasi dan rokok untuk tukang panen",
    ]
  };

  void onDateSelected(DateTime date) {
    //need to translate this into the bloc code
    setState(() {
      selectedDate = date;
    });
  }

  void generateTimeSlots() {
    DateTime now = DateTime.now();
    int currentHour = now.hour;

    for (int hour = currentHour; hour <= 24; hour++) {
      timeSlots.add(DateTime(now.year, now.month, now.day, hour));
    }
  }

  @override
  void initState() {
    super.initState();
    generateTimeSlots();
  }

  @override
  Widget build(BuildContext context) {
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: FontList.font24),
                  child: PageHeader(
                    pageTitle: 'Desember 2024',
                    hasRightIcon: true,
                    rightIcon: 'assets/icons/ic_filter.svg',
                  ),
                ),
                Gap(FontList.font32),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: FontList.font24),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.14,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: dateList.length,
                          itemBuilder: (context, index) {
                            DateTime date = dateList[index];
                            bool isSelected = date.day == selectedDate.day &&
                                date.month == selectedDate.month &&
                                date.year == selectedDate.year;

                            return GestureDetector(
                              onTap: () => onDateSelected(date),
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
                                  borderRadius:
                                      BorderRadius.circular(FontList.font6),
                                  border: Border.all(
                                    color: isSelected
                                        ? ColorList.primaryColor
                                        : ColorList.primaryColor,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                      itemCount: timeSlots.length,
                      itemBuilder: (context, index) {
                        String formattedTime =
                            DateFormat('HH:00 WIB').format(timeSlots[index]);

                        List<String> taskDetails =
                            scheduledTasks[formattedTime] ?? [];

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 8),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(0),
                                    width: 1,
                                    decoration: BoxDecoration(
                                      color: ColorList.whiteColor,
                                      border: Border(
                                        top: BorderSide(
                                            color: ColorList.whiteColor100,
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
                                            children: taskDetails.map((task) {
                                              return Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 8),
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 4,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  task,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              );
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
                onPressed: () {},
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
  }
}
