import 'package:equatable/equatable.dart';
import 'package:cap_secure_mobile/models/shift.dart';

abstract class ShiftState extends Equatable {
  const ShiftState();

  @override
  List<Object> get props => [];
}

class ShiftInitial extends ShiftState {
  const ShiftInitial();
}

class ShiftLoading extends ShiftState {
  const ShiftLoading();
}

class ShiftLoaded extends ShiftState {
  final List<Shift> shifts;

  const ShiftLoaded(this.shifts);

  @override
  List<Object> get props => [shifts];
}

class ShiftEmpty extends ShiftState {
  const ShiftEmpty();
}

class ShiftError extends ShiftState {
  final String message;

  const ShiftError({required this.message});

  @override
  List<Object> get props => [message];
}
