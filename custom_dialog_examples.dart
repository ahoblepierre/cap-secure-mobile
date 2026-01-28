// EXEMPLE D'UTILISATION DU CUSTOM DIALOG DANS TOUTE L'APP
// Ce fichier montre comment réutiliser CustomDialog dans d'autres pages

import 'package:cap_secure_mobile/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';

// ==========================================
// EXEMPLE 1 : Dans une page Login
// ==========================================
class LoginExampleUsage {
  static void handleLoginError(BuildContext context, String errorMessage) {
    CustomDialog.showErrorDialog(
      context,
      title: 'Erreur de connexion',
      message: errorMessage,
      buttonText: 'Réessayer',
      onPressed: () {
        Navigator.pop(context);
        // Effacer les champs de saisie
      },
    );
  }

  static void handleLoginSuccess(BuildContext context) {
    CustomDialog.showSuccessDialog(
      context,
      title: 'Bienvenue!',
      message: 'Connexion réussie',
      onPressed: () {
        // Redirection vers home
        Navigator.of(context).pushReplacementNamed('/home');
      },
    );
  }
}

// ==========================================
// EXEMPLE 2 : Dans une page Profile
// ==========================================
class ProfileExampleUsage {
  static void handleProfileUpdate(BuildContext context, bool success) {
    if (success) {
      CustomDialog.showSuccessDialog(
        context,
        title: 'Profil modifié',
        message: 'Vos informations ont été mises à jour',
      );
    } else {
      CustomDialog.showErrorDialog(
        context,
        message: 'Impossible de mettre à jour le profil',
      );
    }
  }

  static void confirmDeletion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text(
            'Êtes-vous sûr de vouloir supprimer votre compte?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Effectuer la suppression
                CustomDialog.showSuccessDialog(
                  context,
                  title: 'Compte supprimé',
                  message: 'Votre compte a été supprimé avec succès',
                );
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}

// ==========================================
// EXEMPLE 3 : Dans une page de synchronisation
// ==========================================
class SyncExampleUsage {
  static void handleSyncCompletion(
    BuildContext context, {
    required bool success,
    required int itemsSync,
  }) {
    if (success) {
      CustomDialog.showSuccessDialog(
        context,
        title: 'Synchronisation complète',
        message: '$itemsSync éléments synchronisés',
      );
    } else {
      CustomDialog.showWarningDialog(
        context,
        title: 'Synchronisation partielle',
        message: '$itemsSync éléments synchronisés avec des erreurs',
      );
    }
  }

  static void handleSyncError(BuildContext context, String error) {
    CustomDialog.showErrorDialog(
      context,
      title: 'Erreur de synchronisation',
      message: error,
      buttonText: 'Réessayer',
    );
  }
}

// ==========================================
// EXEMPLE 4 : Dans un Bloc avec BlocListener
// ==========================================
/*
class MonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<MonBloc, MonState>(
      listener: (context, state) {
        if (state is MonErrorState) {
          CustomDialog.showErrorDialog(
            context,
            message: state.errorMessage,
          );
        } else if (state is MonSuccessState) {
          CustomDialog.showSuccessDialog(
            context,
            message: state.successMessage,
            onPressed: () {
              context.go('/home');
            },
          );
        }
      },
      child: // votre widget
    );
  }
}
*/

// ==========================================
// EXEMPLE 5 : Dialog pour confirmation
// ==========================================
class ConfirmationExampleUsage {
  static Future<bool?> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }
}

// ==========================================
// EXEMPLE 6 : Patterns courants
// ==========================================
class CommonPatterns {
  // Pattern 1 : Erreur avec bouton de renvoi
  static void showErrorWithRetry(
    BuildContext context,
    String message,
    VoidCallback onRetry,
  ) {
    CustomDialog.showErrorDialog(
      context,
      message: message,
      buttonText: 'Réessayer',
      onPressed: onRetry,
    );
  }

  // Pattern 2 : Succès avec redirection
  static void showSuccessAndNavigate(
    BuildContext context,
    String message,
    String route,
  ) {
    CustomDialog.showSuccessDialog(
      context,
      message: message,
      onPressed: () {
        Navigator.of(context).pushReplacementNamed(route);
      },
    );
  }

  // Pattern 3 : Avertissement avec action
  static void showWarningWithAction(
    BuildContext context,
    String message,
    String buttonText,
    VoidCallback onAction,
  ) {
    CustomDialog.showWarningDialog(
      context,
      message: message,
      buttonText: buttonText,
      onPressed: onAction,
    );
  }

  // Pattern 4 : Validation d'erreur
  static void showValidationError(
    BuildContext context,
    String fieldName,
    String error,
  ) {
    CustomDialog.showWarningDialog(
      context,
      title: 'Erreur de saisie',
      message: '$fieldName : $error',
    );
  }
}

/*
RÉSUMÉ DES CAS D'UTILISATION :

✅ Erreurs API → showErrorDialog
✅ Validation des champs → showWarningDialog
✅ Actions réussies → showSuccessDialog
✅ Confirmations → AlertDialog standard ou ConfirmationExampleUsage
✅ Synchronisation → showWarningDialog ou showSuccessDialog selon le cas
✅ Suppressions → ConfirmationExampleUsage + showSuccessDialog
✅ Uploads/Téléchargements → showSuccessDialog ou showErrorDialog
✅ Expiration de session → showWarningDialog + redirection vers login
*/
