import 'package:equatable/equatable.dart';

abstract class ScannerState extends Equatable {
  const ScannerState();

  @override
  List<Object> get props => [];
}

class ScannerInitial extends ScannerState {
  const ScannerInitial();
}

class ScannerScanning extends ScannerState {
  final bool isFlashOn;

  const ScannerScanning(this.isFlashOn);

  @override
  List<Object> get props => [isFlashOn];
}

class ScannerSuccess extends ScannerState {
  final String scannedCode;

  const ScannerSuccess(this.scannedCode);

  @override
  List<Object> get props => [scannedCode];
}

class ScannerError extends ScannerState {
  final String message;

  const ScannerError(this.message);

  @override
  List<Object> get props => [message];
}

// Nouveaux states pour le pointage
class AttendanceSubmitting extends ScannerState {
  const AttendanceSubmitting();
}

class AttendanceSubmitted extends ScannerState {
  final String message;
  final dynamic data;

  const AttendanceSubmitted({required this.message, this.data});

  @override
  List<Object> get props => [message];
}

class AttendanceError extends ScannerState {
  final String message;

  const AttendanceError(this.message);

  @override
  List<Object> get props => [message];
}
