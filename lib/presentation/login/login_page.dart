import 'package:cap_secure_mobile/config/app_style.dart';
import 'package:cap_secure_mobile/presentation/login/bloc/login_bloc.dart';
import 'package:cap_secure_mobile/routes/routes.dart';
import 'package:cap_secure_mobile/widgets/password_input.dart';
import 'package:cap_secure_mobile/widgets/primary_button.dart';
import 'package:cap_secure_mobile/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController matriculeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(20),
        child: BlocProvider(
          create: (context) => LoginBloc(),
          child: Form(
            key: formKey,
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

                TextInput(
                  labelText: "N° Matricule",
                  hintText: "N° Matricule",
                  controller: matriculeController,
                ),
                Padding(padding: EdgeInsetsGeometry.all(10)),
                PasswordInput(
                  labelText: "Mot de passe",
                  hintText: "Mot des passe",
                  controller: passwordController,
                ),
                Padding(padding: EdgeInsetsGeometry.all(20)),
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginSuccess) {
                      if (state.isFirstLogin) {
                        context.pushNamed(
                          'changePassword',
                          extra: state.resgistrationNumber,
                        );
                      } else {
                        context.go(Routes.home);
                      }
                    } else if (state is LoginFailure) {
                      _showErrorDialog(context, state.message);
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is LoginLoading;
                    return PrimaryButton(
                      labelText: isLoading ? "Chargement..." : "Connexion",
                      onPress: isLoading ? null : () => _handleLogin(context),
                    );
                  },
                ),
                Padding(padding: EdgeInsetsGeometry.all(5)),
                Align(
                  alignment: AlignmentGeometry.bottomRight,
                  child: Text(
                    "Mot de passe oublié ?",
                    style: TextStyle(
                      color: kBleue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      context.read<LoginBloc>().add(
        LoginSubmitted(
          registrationNumber: matriculeController.text,
          password: passwordController.text,
        ),
      );
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          icon: Icon(Icons.error, color: Colors.red, size: 40),
          title: Text("Erreur de connexion", style: TextStyle()),
          content: Text(message),
          actions: [
            PrimaryButton(
              onPress: () => Navigator.of(context).pop(),
              labelText: "Fermer",
            ),
          ],
        );
      },
    );
  }
}
