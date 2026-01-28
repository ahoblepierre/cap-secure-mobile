## Custom Dialog - Guide d'utilisation

Le widget `CustomDialog` fournit une solution réutilisable pour afficher des dialogs personnalisés dans toute l'application.

### Localisation

- [lib/widgets/custom_dialog.dart](lib/widgets/custom_dialog.dart)

### Utilisation

#### 1. Dialog d'erreur

```dart
CustomDialog.showErrorDialog(
  context,
  title: 'Erreur de connexion',
  message: 'Vérifiez vos identifiants',
  buttonText: 'Réessayer',
  onPressed: () {
    // Action à effectuer au clic du bouton
  },
);
```

#### 2. Dialog de succès

```dart
CustomDialog.showSuccessDialog(
  context,
  title: 'Succès',
  message: 'Mot de passe modifié avec succès',
  buttonText: 'OK',
  onPressed: () {
    context.go(Routes.home);
  },
);
```

#### 3. Dialog d'avertissement

```dart
CustomDialog.showWarningDialog(
  context,
  title: 'Attention',
  message: 'Les mots de passe ne correspondent pas',
  buttonText: 'Compris',
  onPressed: () {
    // Action
  },
);
```

### Méthodes disponibles

- **showErrorDialog()** - Affiche un dialog d'erreur avec titre rouge
- **showSuccessDialog()** - Affiche un dialog de succès avec titre vert
- **showWarningDialog()** - Affiche un dialog d'avertissement avec titre orange

### Paramètres

- `context` (BuildContext) - Requis
- `message` (String) - Requis - Message à afficher
- `title` (String) - Optionnel - Titre du dialog (défaut: "Erreur", "Succès", "Attention")
- `buttonText` (String) - Optionnel - Texte du bouton (défaut: "OK")
- `onPressed` (VoidCallback?) - Optionnel - Callback au clic du bouton

## Implémentation dans Change Password

Le module de changement de mot de passe utilise `CustomDialog` pour:

1. **Validation des champs** - Dialog d'avertissement si les mots de passe ne correspondent pas
2. **Erreurs API** - Dialog d'erreur en cas de problème de connexion
3. **Succès** - Dialog de succès avec redirection vers l'accueil

### Flux complet

```
Utilisateur saisit nouveau mot de passe
         ↓
Validation des champs (bloc)
         ↓
    SI valide → Appel API (loginRepository.changePassword())
    SI invalid → CustomDialog.showWarningDialog()
         ↓
    SI succès → Sauvegarde du token + agent
                CustomDialog.showSuccessDialog() → Redirection vers /home
    SI erreur  → CustomDialog.showErrorDialog()
```

### Avantages

✅ Réutilisable dans toute l'application
✅ Design consistant
✅ Gestion cohérente des erreurs
✅ Facilement personnalisable (couleurs, textes, callbacks)
