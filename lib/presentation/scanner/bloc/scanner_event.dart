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
