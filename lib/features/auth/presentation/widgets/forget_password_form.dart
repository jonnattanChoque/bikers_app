import 'package:bikers_app/core/i18n/strings.dart';
import 'package:bikers_app/core/ui/helpers/custom_snackbar.dart';
import 'package:bikers_app/core/ui/viewmodels/view_message.dart';
import 'package:bikers_app/core/ui/widgets/social_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class ForgetPasswordForm extends StatefulWidget {
  const ForgetPasswordForm({super.key});

  @override
  State<ForgetPasswordForm> createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final FocusNode _emailFocus = FocusNode();

  @override
  void dispose() {
    _emailCtrl.dispose();
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
            if (vm.message != null && vm.message?.flowType == MessageFlowType.forget) {
              CustomSnackBar.show(
                context,
                message: vm.message!.text,
                type: vm.message!.type,
                icon: vm.message!.icon,
                top: false
              );
              if (vm.message?.type == MessageType.success) {
                Navigator.pop(context);
              }
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
                    controller: _emailCtrl, 
                    style: TextStyle(color: Colors.primaries.first),
                    decoration: InputDecoration(labelText: LoginStrings.emailRequired),
                    keyboardType: TextInputType.emailAddress,
                    focusNode: _emailFocus,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      vm.isLoading
                      ? null
                      : vm.forgetPassword(_emailCtrl.text);
                    }
                  ),
                  const SizedBox(height: 16),
                  SocialButton(
                    type: SocialButtonType.recovery,
                    onPressed: () {
                      vm.isLoading
                      ? null
                      : vm.forgetPassword(_emailCtrl.text);
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
