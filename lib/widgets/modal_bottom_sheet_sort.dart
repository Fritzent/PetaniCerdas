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