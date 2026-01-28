import 'package:cap_secure_mobile/models/location_model.dart';
import 'package:equatable/equatable.dart';

abstract class ScannerEvent extends Equatable {
  const ScannerEvent();

  @override
  List<Object> get props => [];
}

class StartScan extends ScannerEvent {}

class StopScan extends ScannerEvent {}

class ToggleFlash extends ScannerEvent {}

class CodeScanned extends ScannerEvent {
  final String code;

  const CodeScanned(this.code);

  @override
  List<Object> get props => [code];
}

class ResetScanner extends ScannerEvent {}

// Nouvel event pour soumettre le pointage avec localisation
class SubmitAttendance extends ScannerEvent {
  final String scannedCode;
  final LocationModel location;

  const SubmitAttendance({required this.scannedCode, required this.location});

  @override
  List<Object> get props => [scannedCode, location];
}
