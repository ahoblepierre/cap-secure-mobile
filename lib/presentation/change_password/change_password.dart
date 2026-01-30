import 'package:cap_secure_mobile/config/app_style.dart';
import 'package:cap_secure_mobile/presentation/change_password/bloc/password_bloc.dart';
import 'package:cap_secure_mobile/repository/login_repository.dart';
import 'package:cap_secure_mobile/routes/routes.dart';
import 'package:cap_secure_mobile/widgets/custom_app_bar.dart';
import 'package:cap_secure_mobile/widgets/custom_dialog.dart';
import 'package:cap_secure_mobile/widgets/password_input.dart';
import 'package:cap_secure_mobile/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key, required this.registerationNumber});

  final String registerationNumber;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordBloc(loginRepository: LoginRepository()),
      child: _ChangePasswordContent(registerationNumber: registerationNumber),
    );
  }
}

class _ChangePasswordContent extends StatefulWidget {
  const _ChangePasswordContent({required this.registerationNumber});

  final String registerationNumber;

  @override
  State<_ChangePasswordContent> createState() => _ChangePasswordContentState();
}

class _ChangePasswordContentState extends State<_ChangePasswordContent> {
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword() {
    context.read<PasswordBloc>().add(
      PasswordChangedEvent(
        registrationNumber: widget.registerationNumber,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordBloc, PasswordState>(
      listener: (context, state) {
        if (state is PasswordLoading) {
          setState(() => _isLoading = true);
        } else if (state is PasswordSuccess) {
          setState(() => _isLoading = false);
          CustomDialog.showSuccessDialog(
            context,
            title: 'Succès',
            message: state.message,
            onPressed: () {
              context.go(Routes.home);
            },
          );
        } else if (state is PasswordError) {
          setState(() => _isLoading = false);
          CustomDialog.showErrorDialog(
            context,
            title: 'Erreur',
            message: state.message,
          );
        } else if (state is PasswordValidationError) {
          setState(() => _isLoading = false);
          CustomDialog.showWarningDialog(
            context,
            title: 'Attention',
            message: state.message,
            buttonText: "Fermer",
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Changer le mot de passe",
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: kBleue),
          ),
        ),
        body: SafeArea(
          minimum: EdgeInsets.all(kpadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PasswordInput(
                controller: _newPasswordController,
                labelText: "Nouveau mot de passe",
                hintText: "Nouveau mot de passe",
              ),
              SizedBox(height: 20),
              PasswordInput(
                controller: _confirmPasswordController,
                labelText: "Confirmer le mot de passe",
                hintText: "Confirmer le mot de passe",
              ),
              SizedBox(height: 40),
              PrimaryButton(
                labelText: "Changer le mot de passe",
                onPress: _isLoading ? null : _handleChangePassword,
              ),
              if (_isLoading) ...[
                SizedBox(height: 20),
                CircularProgressIndicator(color: kBleue),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
