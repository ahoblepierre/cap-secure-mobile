import 'package:cap_secure_mobile/config/app_style.dart';
import 'package:flutter/material.dart';

class EmptyShiftState extends StatelessWidget {
  const EmptyShiftState({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icône élégante
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: kBleue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              size: 80,
              color: kBleue.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 32),

          // Titre
          const Text(
            'Aucun shift à afficher',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Il n\'y a actuellement aucun shift disponible pour votre compte.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),

          // Bouton de rafraîchissement optionnel
          ElevatedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text('Rafraîchir', style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: kBleue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
