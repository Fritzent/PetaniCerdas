part of 'dropdown_sort_data_bloc.dart';

abstract class DropdownSortDataEvent {}

class SelectDropdownItem extends DropdownSortDataEvent {
  final String? selectedItem;
  final String? selectedSortWayItem;

  SelectDropdownItem(this.selectedItem, this.selectedSortWayItem);
}
