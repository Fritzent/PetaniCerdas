import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:petani_cerdas/resources/bottomsheet_item.dart';
import 'package:petani_cerdas/resources/style_config.dart';
import 'package:petani_cerdas/widgets/button_primary.dart';

import '../bloc/dropdown_sort_data_bloc.dart';
import '../bloc/transactions_bloc.dart';
import 'drop_down_sort.dart';

String? selectedItem;

void showCustomModalBottomSheet({
  required BuildContext context,
  required TransactionsBloc bloc,
  bool isDismissible = false,
  bool enableDrag = false,
}) {
  showModalBottomSheet(
    useSafeArea: true,
    context: context,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: ColorList.whiteColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(FontList.font16),
      ),
    ),
    builder: (context) {
      return BlocProvider(
        create: (context) => DropdownSortDataBloc(),
        child: Padding(
          padding: const EdgeInsets.all(FontList.font24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Urutkan',
                      style: TextStyle(
                          fontSize: FontList.font24,
                          fontWeight: FontWeight.bold,
                          color: ColorList.blackColor),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      alignment: Alignment.topRight,
                      'assets/icons/ic_exits.svg',
                      height: FontList.font24,
                      width: FontList.font24,
                    ),
                  ),
                ],
              ),
              Gap(FontList.font32),
              Row(
                spacing: FontList.font8,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: BlocBuilder<DropdownSortDataBloc,
                        DropdownSortDataState>(
                      builder: (context, state) {
                        final bloc = context.read<DropdownSortDataBloc>();
                        return DropDownSort(
                          hintText: 'Pilih tipe data',
                          items: dataType,
                          value: state.selectedValue,
                          onChanged: (value) {
                            bloc.add(SelectDropdownItem(
                                value, state.selectedSortWayValue));
                          },
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<DropdownSortDataBloc,
                        DropdownSortDataState>(
                      builder: (context, state) {
                        final bloc = context.read<DropdownSortDataBloc>();
                        return DropDownSort(
                          hintText: 'Urutkan secara',
                          items: sortWay,
                          value: state.selectedSortWayValue,
                          onChanged: (value) {
                            bloc.add(
                                SelectDropdownItem(state.selectedValue, value));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              Gap(FontList.font167),
              BlocBuilder<DropdownSortDataBloc, DropdownSortDataState>(
                builder: (context, state) {
                  return ButtonPrimary(
                      onTap: () {
                        bloc.add(SelectedSortBottomSheet(
                          sortBy: state.selectedValue,
                          sortWay: state.selectedSortWayValue
                        ));
                        Navigator.pop(context);
                      },
                      buttonText: 'Urutkan');
                },
              )
            ],
          ),
        ),
      );
    },
  );
}


// List<Map<String, dynamic>> items = [
  //   {'name': 'Apple', 'date': DateTime(2024, 11, 1), 'price': 3.0},
  //   {'name': 'Banana', 'date': DateTime(2024, 10, 15), 'price': 1.5},
  //   {'name': 'Cherry', 'date': DateTime(2024, 11, 20), 'price': 5.0},
  // ];

  // // Current selected sorting method
  // String selectedSort = 'Name';

  // void sortItems(String sortBy) {
  //   setState(() {
  //     if (sortBy == 'Custom') {
  //       showSortMenu2();
  //       //items.sort((a, b) => a['name'].compareTo(b['name']));
  //     } else if (sortBy == 'Ascending') {
  //       items.sort((a, b) => a['date'].compareTo(b['date']));
  //     } else if (sortBy == 'Descending') {
  //       items.sort((a, b) => a['price'].compareTo(b['price']));
  //     }
  //   });
  // }

  // void showSortMenu(BuildContext context, Offset offset) async {
  //   final result = await showMenu<String>(
  //     context: context,
  //     position: RelativeRect.fromLTRB(
  //       offset.dx + FontList.font100,
  //       offset.dy + FontList.font100,
  //       offset.dx + FontList.font24,
  //       offset.dy,
  //     ),
  //     items: [
  //       PopupMenuItem(
  //         value: 'Ascending',
  //         child: Text('Urutkan dari tertinggi ke terendah'),
  //       ),
  //       PopupMenuItem(
  //         value: 'Descending',
  //         child: Text('Urutkan dari terendah ke tertinggi'),
  //       ),
  //       PopupMenuItem(
  //         value: 'Custom',
  //         child: Text('Kustom'),
  //       ),
  //     ],
  //   );

  //   if (result != null) {
  //     sortItems(result);
  //     setState(() {
  //       selectedSort = result;
  //     });
  //   }
  // }

  // // CODE TO MAKE THE MODAL BOTTOM SHEET
  // void showSortMenu2() {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (context) {
  //       return Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text(
  //               'Sort By',
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             const SizedBox(height: 8),
  //             ListTile(
  //               title: Text('Name'),
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 sortItems('Name');
  //                 setState(() {
  //                   selectedSort = 'Name';
  //                 });
  //               },
  //             ),
  //             ListTile(
  //               title: Text('Date'),
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 sortItems('Date');
  //                 setState(() {
  //                   selectedSort = 'Date';
  //                 });
  //               },
  //             ),
  //             ListTile(
  //               title: Text('Price'),
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 sortItems('Price');
  //                 setState(() {
  //                   selectedSort = 'Price';
  //                 });
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }


  // onTap: () {
                        //   //bloc.add(SortTransactionDescending());

                        //   // String dateString = "21 November 2024";
                        //   // DateFormat format = DateFormat("dd MMMM yyyy");
                        //   // DateTime parsedDate = format.parse(dateString);
                        //   // bloc.add(SortByTimeLowerThen(parsedDate));
                        // },



                        //AWAY TO CALL THE MODAL BOTTOM SHEET
                        //onTap: showSortMenu,


                        // final buttonRenderBox =
                          //     context.findRenderObject() as RenderBox;
                          // final buttonOffset =
                          //     buttonRenderBox.localToGlobal(Offset.zero);
                          // showSortMenu(context, buttonOffset);