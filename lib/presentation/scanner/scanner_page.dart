// ignore_for_file: unused_element

import 'package:cap_secure_mobile/presentation/scanner/bloc/scanner_bloc.dart';
import 'package:cap_secure_mobile/presentation/scanner/bloc/scanner_event.dart';
import 'package:cap_secure_mobile/presentation/scanner/bloc/scanner_state.dart';
import 'package:cap_secure_mobile/services/location_service.dart';
import 'package:cap_secure_mobile/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    context.read<ScannerBloc>().add(StartScan());
  }

  @override
  void dispose() {
    // controller?.dispose(); // Deprecated, auto-disposed
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    context.read<ScannerBloc>().setController(controller);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: BlocConsumer<ScannerBloc, ScannerState>(
        listener: (context, state) {
          if (state is ScannerSuccess) {
            _showResultDialog(state.scannedCode);
          } else if (state is AttendanceSubmitted) {
            CustomDialog.showSuccessDialog(
              context,
              title: 'Succès',
              message: state.message,
              buttonText: 'OK',
              onPressed: () {
                Navigator.of(context).pop();
                context.read<ScannerBloc>().add(ResetScanner());
              },
            );
          } else if (state is AttendanceError) {
            CustomDialog.showErrorDialog(
              context,
              title: 'Erreur',
              message: state.message,
              buttonText: 'Réessayer',
            );
          } else if (state is ScannerError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Erreur: ${state.message}')));
          }
        },
        builder: (context, state) {
          if (state is ScannerInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Theme.of(context).primaryColor,
                  borderRadius: 16,
                  borderLength: 30,
                  borderWidth: 8,
                  cutOutSize: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
              // Overlay avec instructions

              // Bouton flash en haut à droite
              Positioned(
                top: 5,
                right: 20,
                child: BlocBuilder<ScannerBloc, ScannerState>(
                  builder: (context, state) {
                    if (state is ScannerScanning) {
                      return FloatingActionButton(
                        onPressed: () {
                          context.read<ScannerBloc>().add(ToggleFlash());
                        },
                        backgroundColor: Colors.black.withValues(alpha: 0.7),
                        child: Icon(
                          state.isFlashOn ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Placez le code QR dans le cadre pour le scanner',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Afficher le loader lors du pointage
              if (state is AttendanceSubmitting)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Envoi du pointage...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showResultDialog(String code) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          title: const Text(
            'Code QR Scanné',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.qr_code, size: 48, color: Colors.green),
              const SizedBox(height: 16),
              const Text(
                'Contenu du code :',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  code,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<ScannerBloc>().add(ResetScanner());
              },
              child: const Text('Scanner un autre'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _submitAttendance(code);
              },
              style: ElevatedButton.styleFrom(
                //backgroundColor: kBleue,
                // shape: ContinuousRectangleBorder(),
                // textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                // foregroundColor: Colors.white,
              ),
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }

  /// Récupérer la localisation et envoyer le pointage
  Future<void> _submitAttendance(String scannedCode) async {
    try {
      // Afficher un loader
      _showLoadingDialog();

      // Récupérer la localisation
      final location = await _locationService.getCurrentLocation();

      // Fermer le loader
      if (!mounted) return;
      Navigator.of(context).pop();

      // Envoyer le pointage via le BLoC
      if (!mounted) return;
      context.read<ScannerBloc>().add(
        SubmitAttendance(scannedCode: scannedCode, location: location),
      );
    } catch (e) {
      // Fermer le loader
      if (!mounted) return;
      Navigator.of(context).pop();

      // Afficher l'erreur
      if (!mounted) return;
      CustomDialog.showErrorDialog(
        context,
        title: 'Erreur de localisation',
        message: 'Impossible d\'obtenir votre localisation: $e',
        buttonText: 'Réessayer',
      );
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
