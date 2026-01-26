import 'package:equatable/equatable.dart';
import 'package:cap_secure_mobile/models/shift.dart';

abstract class ShiftState extends Equatable {
  const ShiftState();

  @override
  List<Object> get props => [];
}

class ShiftInitial extends ShiftState {}

class ShiftLoading extends ShiftState {}

class ShiftLoaded extends ShiftState {
  final List<Shift> shifts;

  const ShiftLoaded(this.shifts);

  @override
  List<Object> get props => [shifts];
}

class ShiftError extends ShiftState {
  final String message;

  const ShiftError(this.message);

  @override
  List<Object> get props => [message];
}
