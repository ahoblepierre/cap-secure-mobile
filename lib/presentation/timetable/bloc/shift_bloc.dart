import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cap_secure_mobile/repository/shift_repository.dart';
import 'shift_event.dart';
import 'shift_state.dart';

class ShiftBloc extends Bloc<ShiftEvent, ShiftState> {
  final ShiftRepository _shiftRepository;

  ShiftBloc({required ShiftRepository shiftRepository})
    : _shiftRepository = shiftRepository,
      super(ShiftInitial()) {
    on<LoadShifts>(_onLoadShifts);
  }

  Future<void> _onLoadShifts(LoadShifts event, Emitter<ShiftState> emit) async {
    emit(ShiftLoading());

    try {
      final shifts = await _shiftRepository.getAllShifts();

      if (shifts.isEmpty) {
        emit(const ShiftEmpty());
      } else {
        emit(ShiftLoaded(shifts));
      }
    } catch (e) {
      emit(ShiftError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
