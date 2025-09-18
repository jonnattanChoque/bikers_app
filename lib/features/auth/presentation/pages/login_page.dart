import 'dart:io';

import 'package:bikers_app/core/extensions/text_style_extension.dart';
import 'package:bikers_app/core/ui/helpers/custom_snackbar.dart';
import 'package:bikers_app/core/i18n/strings.dart';
import 'package:bikers_app/core/ui/widgets/social_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  
  // bool _obscurePassword = true;

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context,listen: false);

    return ChangeNotifierProvider<AuthViewModel>.value(
      value: auth,
      child: Consumer<AuthViewModel>(
        builder: (context, vm, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (vm.message != null) {
              CustomSnackBar.show(
                context,
                message: vm.message!.text,
                type: vm.message!.type,
                icon: vm.message!.icon,
              );
              vm.clearMessage();
            }
          });
          
          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                currentFocus.focusedChild!.unfocus();
              }
            },
            child: Scaffold(
              appBar: AppBar(title: Text('Login')),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, top: 80, right: 16),
                      child: Column(
                        children: [
                          TextField(
                            controller: emailController, 
                            style: TextStyle(color: Colors.primaries.first),
                            decoration: InputDecoration(labelText: LoginStrings.emailRequired),
                            keyboardType: TextInputType.emailAddress,
                            focusNode: emailFocus,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) {
                              FocusScope.of(context).requestFocus(passwordFocus);
                            }
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: passwordController,
                            focusNode: passwordFocus,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) {
                              vm.login(emailController.text, passwordController.text);
                            },
                            style: TextStyle(color: Colors.primaries.first),
                            decoration: InputDecoration(
                              label: Text(LoginStrings.passwordRequired)
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  vm.obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () => vm.togglePassword(),
                              ),
                            ),
                            obscureText: vm.obscurePassword,
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              //onTap: () => showForgotPasswordSheet(context),
                              child: Text(
                                LoginStrings.recoveryLink,
                                style: Theme.of(context).textTheme.bodyMedium?.link,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SocialButton(
                            type: SocialButtonType.login,
                            onPressed: () {
                              vm.isLoading
                              ? null
                              : vm.login(emailController.text, passwordController.text);
                            },
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(child: Divider(color: Color(0xFF30363D))),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'o',
                                  style: TextStyle(
                                    color: Color(0xFF7D8590),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(color: Color(0xFF30363D))),
                            ],
                          ),        
                          SizedBox(height: 24),
                          SocialButton(
                            type: SocialButtonType.google,
                            onPressed: () => vm.isLoading ? null : vm.loginWithGoogle(),
                          ),
                          const SizedBox(height: 16),
                          if (Platform.isIOS)
                            SocialButton(
                              type: SocialButtonType.apple,
                              onPressed: () => vm.isLoading ? null : vm.loginWithApple(),
                            ),
                          const SizedBox(height: 24),
                          // TextButton(
                          //   onPressed: () => showRegisterSheet(context),
                          //   child: Text(LoginStrings.registerLink, style: Theme.of(context).textTheme.bodyLarge?.link),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  if (vm.isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.5),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ]
              ),
            ),
          );
        },
      ),
    );
  }
}
