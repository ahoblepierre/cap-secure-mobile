import 'package:equatable/equatable.dart';

abstract class ScannerState extends Equatable {
  const ScannerState();

  @override
  List<Object> get props => [];
}

class ScannerInitial extends ScannerState {}

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
