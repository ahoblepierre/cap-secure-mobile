import 'dart:developer';

import 'package:cap_secure_mobile/config/app_style.dart';
import 'package:cap_secure_mobile/repository/shift_repository.dart';
import 'package:cap_secure_mobile/widgets/empty_shift_state.dart';
import 'package:cap_secure_mobile/widgets/loading_dialog.dart';
import 'package:cap_secure_mobile/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:cap_secure_mobile/presentation/timetable/bloc/shift_bloc.dart';
import 'package:cap_secure_mobile/presentation/timetable/bloc/shift_event.dart';
import 'package:cap_secure_mobile/presentation/timetable/bloc/shift_state.dart';
import 'package:cap_secure_mobile/presentation/timetable/shift_data_source.dart';
import 'package:cap_secure_mobile/models/shift.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  late ShiftDataSource _dataSource;
  late ShiftBloc _shiftBloc;
  bool _isLoadingDialogShown = false;

  @override
  void initState() {
    super.initState();
    // Créer le bloc UNE SEULE FOIS
    _shiftBloc = ShiftBloc(shiftRepository: ShiftRepository());
    // Déclencher le chargement
    _shiftBloc.add(LoadShifts());
    log('ShiftBloc created and LoadShifts triggered');
  }

  @override
  void dispose() {
    // Fermer le bloc pour libérer les ressources
    _shiftBloc.close();
    super.dispose();
  }

  void _onCalendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.calendarCell &&
        details.date != null) {
      final shifts = _dataSource.getShiftsForDate(details.date!);
      if (shifts.isNotEmpty) {
        _showShiftDetailsModal(context, shifts, details.date!);
      }
    }
  }

  void _showShiftDetailsModal(
    BuildContext context,
    List<Shift> shifts,
    DateTime date,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          title: Text(
            'Shifts du ${DateFormat('dd/MM/yyyy').format(date)}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: shifts
                  .map(
                    (shift) => Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Site: ${shift.site}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Heure: ${DateFormat('HH:mm').format(shift.start)} - ${DateFormat('HH:mm').format(shift.end)}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Description: ${shift.description}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          actions: [
            PrimaryButton(
              onPress: () => Navigator.of(context).pop(),
              labelText: 'Fermer',
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _shiftBloc,
      child: Container(
        padding: EdgeInsets.all(kpadding),
        child: BlocListener<ShiftBloc, ShiftState>(
          listener: (context, state) {
            if (state is ShiftLoading) {
              // Afficher le dialog de chargement
              if (!_isLoadingDialogShown) {
                LoadingDialog.show(
                  context,
                  message: 'Chargement des shifts...',
                );
                _isLoadingDialogShown = true;
              }
            } else {
              // Fermer le dialog de chargement
              if (_isLoadingDialogShown) {
                LoadingDialog.hide(context);
                _isLoadingDialogShown = false;
              }
            }

            // Gestion des erreurs
            if (state is ShiftError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erreur: ${state.message}'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          },
          child: BlocBuilder<ShiftBloc, ShiftState>(
            builder: (context, state) {
              if (state is ShiftInitial || state is ShiftLoading) {
                return const SizedBox.expand();
              } else if (state is ShiftLoaded) {
                _dataSource = ShiftDataSource(state.shifts);
                return SfCalendar(
                  view: CalendarView.month,
                  dataSource: _dataSource,
                  onTap: _onCalendarTapped,
                  monthViewSettings: const MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment,
                    showAgenda: true,
                  ),
                  appointmentBuilder: (context, calendarAppointmentDetails) {
                    final Appointment appointment =
                        calendarAppointmentDetails.appointments.first;
                    return Container(
                      width: calendarAppointmentDetails.bounds.width,
                      height: calendarAppointmentDetails.bounds.height,
                      decoration: BoxDecoration(
                        color: appointment.color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          appointment.subject,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                );
              } else if (state is ShiftEmpty) {
                return const EmptyShiftState();
              } else if (state is ShiftError) {
                return Center(child: Text('Erreur: ${state.message}'));
              }
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48),
                    Text(
                      'Aucun shift trouvé',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
