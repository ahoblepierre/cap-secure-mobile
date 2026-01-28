import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cap_secure_mobile/repository/scanner_repository.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'scanner_event.dart';
import 'scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  QRViewController? _controller;
  bool _isFlashOn = false;
  final ScannerRepository _scannerRepository = ScannerRepository();

  ScannerBloc() : super(const ScannerInitial()) {
    on<StartScan>(_onStartScan);
    on<StopScan>(_onStopScan);
    on<ToggleFlash>(_onToggleFlash);
    on<CodeScanned>(_onCodeScanned);
    on<ResetScanner>(_onResetScanner);
    on<SubmitAttendance>(_onSubmitAttendance);
  }

  void setController(QRViewController controller) {
    _controller = controller;
    _controller!.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        add(CodeScanned(scanData.code!));
      }
    });
  }

  void _onStartScan(StartScan event, Emitter<ScannerState> emit) async {
    if (_controller != null) {
      await _controller!.toggleFlash();
      _isFlashOn = true;
    }
    emit(ScannerScanning(_isFlashOn));
  }

  void _onStopScan(StopScan event, Emitter<ScannerState> emit) {
    _controller?.pauseCamera();
    emit(const ScannerInitial());
  }

  void _onToggleFlash(ToggleFlash event, Emitter<ScannerState> emit) async {
    if (_controller != null) {
      await _controller!.toggleFlash();
      _isFlashOn = !_isFlashOn;
      if (state is ScannerScanning) {
        emit(ScannerScanning(_isFlashOn));
      }
    }
  }

  void _onCodeScanned(CodeScanned event, Emitter<ScannerState> emit) {
    _controller?.pauseCamera();
    emit(ScannerSuccess(event.code));
  }

  void _onResetScanner(ResetScanner event, Emitter<ScannerState> emit) {
    _controller?.resumeCamera();
    emit(ScannerScanning(_isFlashOn));
  }

  Future<void> _onSubmitAttendance(
    SubmitAttendance event,
    Emitter<ScannerState> emit,
  ) async {
    emit(const AttendanceSubmitting());

    try {
      log('📍 Envoi du pointage: ${event.scannedCode}');
      log(
        '📍 Localisation: Lat ${event.location.latitude}, Long ${event.location.longitude}',
      );

      final response = await _scannerRepository.submitAttendance(
        scannedCode: event.scannedCode,
        location: event.location,
      );

      log('✅ Pointage envoyé avec succès: $response');

      emit(
        AttendanceSubmitted(
          message: response['message'] ?? 'Pointage enregistré avec succès',
          data: response['data'],
        ),
      );
    } catch (e) {
      log('❌ Erreur lors du pointage: $e');

      emit(AttendanceError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    // _controller?.dispose(); // Deprecated, auto-disposed
    return super.close();
  }
}
