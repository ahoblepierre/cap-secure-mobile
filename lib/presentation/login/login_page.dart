import 'package:cap_secure_mobile/config/app_style.dart';
import 'package:cap_secure_mobile/widgets/password_input.dart';
import 'package:cap_secure_mobile/widgets/primary_button.dart';
import 'package:cap_secure_mobile/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              child: Image.asset(
                "assets/images/logo_cs.png",
                width: 200,
                height: 50,
              ),
            ),
            Padding(padding: EdgeInsetsGeometry.all(10)),
            Text("Bienvenue chez Cap Secure", style: signStyle),

            Text(
              "  Veuillez vous connecter pour continuer",
              style: userNameStyle.copyWith(color: kGrey),
            ),

            Padding(padding: EdgeInsetsGeometry.all(10)),

            TextInput(labelText: "N° Matricule", hintText: "N° Matricule"),
            Padding(padding: EdgeInsetsGeometry.all(10)),
            PasswordInput(labelText: "Mot de passe", hintText: "Mot des passe"),
            Padding(padding: EdgeInsetsGeometry.all(20)),
            PrimaryButton(
              labelText: "Connexion",
              onPress: () {
                context.go('/home');
              },
            ),
            Padding(padding: EdgeInsetsGeometry.all(5)),
            Align(
              alignment: AlignmentGeometry.bottomRight,
              child: Text(
                "Mot de passe oublié ?",
                style: TextStyle(color: kBleue, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
