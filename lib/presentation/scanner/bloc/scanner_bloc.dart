import 'package:bloc/bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'scanner_event.dart';
import 'scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  QRViewController? _controller;
  bool _isFlashOn = false;

  ScannerBloc() : super(ScannerInitial()) {
    on<StartScan>(_onStartScan);
    on<StopScan>(_onStopScan);
    on<ToggleFlash>(_onToggleFlash);
    on<CodeScanned>(_onCodeScanned);
    on<ResetScanner>(_onResetScanner);
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
    emit(ScannerInitial());
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

  @override
  Future<void> close() {
    // _controller?.dispose(); // Deprecated, auto-disposed
    return super.close();
  }
}
