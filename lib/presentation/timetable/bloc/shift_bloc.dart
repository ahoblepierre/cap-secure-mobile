import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cap_secure_mobile/models/shift.dart';
import 'shift_event.dart';
import 'shift_state.dart';

class ShiftBloc extends Bloc<ShiftEvent, ShiftState> {
  ShiftBloc() : super(ShiftInitial()) {
    on<LoadShifts>(_onLoadShifts);
  }

  Future<void> _onLoadShifts(LoadShifts event, Emitter<ShiftState> emit) async {
    emit(ShiftLoading());
    // Simuler un délai de chargement
    await Future.delayed(const Duration(seconds: 2));

    // Générer des données mockées pour 3 mois
    final now = DateTime.now();
    final shifts = <Shift>[];

    for (int i = 0; i < 90; i++) {
      // 90 jours
      final date = now.add(Duration(days: i));
      if (date.weekday != DateTime.saturday &&
          date.weekday != DateTime.sunday) {
        // Jours de travail : lundi à vendredi
        shifts.add(
          Shift(
            id: 'shift_$i',
            site: 'Site ${i % 3 + 1}',
            start: DateTime(date.year, date.month, date.day, 8, 0),
            end: DateTime(date.year, date.month, date.day, 16, 0),
            description: 'Shift de sécurité standard',
          ),
        );
      }
    }

    emit(ShiftLoaded(shifts));
  }
}
