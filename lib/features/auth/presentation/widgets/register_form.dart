import 'package:bikers_app/core/i18n/strings.dart';
import 'package:bikers_app/core/ui/helpers/custom_snackbar.dart';
import 'package:bikers_app/core/ui/viewmodels/view_message.dart';
import 'package:bikers_app/core/ui/widgets/social_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context,listen: false);

    return ChangeNotifierProvider<AuthViewModel>.value(
      value: auth,
      child: Consumer<AuthViewModel>(
        builder: (context, vm, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (vm.message != null && vm.message?.flowType == MessageFlowType.register) {
              CustomSnackBar.show(
                context,
                message: vm.message!.text,
                type: vm.message!.type,
                icon: vm.message!.icon,
                top: false
              );
              vm.clearMessage();
            }
          });
          
          return GestureDetector(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _nameCtrl, 
                    style: TextStyle(color: Colors.primaries.first),
                    decoration: InputDecoration(labelText: RegisterStrings.userName),
                    keyboardType: TextInputType.emailAddress,
                    focusNode: _nameFocus,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_emailFocus);
                    }
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailCtrl, 
                    style: TextStyle(color: Colors.primaries.first),
                    decoration: InputDecoration(labelText: LoginStrings.emailRequired),
                    keyboardType: TextInputType.emailAddress,
                    focusNode: _emailFocus,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocus);
                    }
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordCtrl,
                    focusNode: _passwordFocus,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      vm.login(_emailCtrl.text, _passwordCtrl.text);
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
                  SocialButton(
                    type: SocialButtonType.register,
                    onPressed: () {
                      vm.isLoading
                      ? null
                      : vm.register(_nameCtrl.text, _emailCtrl.text, _passwordCtrl.text);
                    },
                  ),
                  const SizedBox(height: 16)
                ],
              ),
            ),
          );
      })
    );
  }
}
