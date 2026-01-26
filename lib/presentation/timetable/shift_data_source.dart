import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cap_secure_mobile/models/shift.dart';

class ShiftDataSource extends CalendarDataSource {
  ShiftDataSource(List<Shift> shifts) {
    appointments = shifts.map((shift) {
      return Appointment(
        id: shift.id,
        startTime: shift.start,
        endTime: shift.end,
        subject: shift.site,
        color: Colors.green, // Vert pour les shifts
        notes: shift.description,
      );
    }).toList();
  }

  List<Shift> getShifts() {
    return appointments!.map((appointment) {
      return Shift(
        id: appointment.id as String,
        site: appointment.subject,
        start: appointment.startTime,
        end: appointment.endTime,
        description: appointment.notes ?? '',
      );
    }).toList();
  }

  List<Shift> getShiftsForDate(DateTime date) {
    return getShifts().where((shift) {
      return shift.start.year == date.year &&
          shift.start.month == date.month &&
          shift.start.day == date.day;
    }).toList();
  }
}
