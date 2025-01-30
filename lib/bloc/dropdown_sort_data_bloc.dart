import 'package:flutter_bloc/flutter_bloc.dart';
part 'dropdown_sort_data_event.dart';
part 'dropdown_sort_data_state.dart';

class DropdownSortDataBloc extends Bloc<DropdownSortDataEvent, DropdownSortDataState> {
  DropdownSortDataBloc() : super(DropdownSortDataState()) {
    on<SelectDropdownItem>(OnSelectDropdownItem);
  }

  void OnSelectDropdownItem(SelectDropdownItem event, Emitter<DropdownSortDataState> emit) {
    emit(DropdownSortDataState(selectedValue: event.selectedItem, selectedSortWayValue:  event.selectedSortWayItem));
  }
}
