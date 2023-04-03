import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import '../../../../../application/app_state.dart';
import '../../../../../application/error_string.dart';
import '../../../../../application/sign_up_business_logic.dart';
import '../../../../../configs/front_end_configs.dart';
import '../../../../../infrastructure/models/user.dart';
import '../../../../../infrastructure/services/user.dart';
import '../../../../elements/app_button.dart';
import '../../../../elements/auth_field.dart';
import '../../../../elements/custom_text.dart';
import '../../../../elements/error_dialog.dart';
import '../../../../elements/flush_bar.dart';
import '../../../../elements/navigation_dialog.dart';
import '../../../../elements/processing_widget.dart';
import '../../log_in/log_in_view.dart';

class SignUpBody extends StatefulWidget {
  SignUpBody({Key? key}) : super(key: key);

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    SignUpBusinessLogic signUp = Provider.of<SignUpBusinessLogic>(context);
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: const ProcessingWidget(),
      color: Colors.transparent,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 44,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        CustomText(
                          text: 'Create Account',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                CustomTextField(
                    isSecure: false,
                    controller: _nameController,
                    text: 'Username',
                    onTap: () {},
                    keyBoardType: TextInputType.emailAddress),
                const SizedBox(
                  height: 18,
                ),
                CustomTextField(
                    isSecure: false,
                    controller: _emailController,
                    text: 'Email',
                    onTap: () {},
                    keyBoardType: TextInputType.emailAddress),
                const SizedBox(
                  height: 18,
                ),
                CustomTextField(
                  controller: _passwordController,
                  text: 'Password',
                  onTap: () {},
                  keyBoardType: TextInputType.text,
                  isSecure: true,
                  isPassword: true,
                ),
                const SizedBox(
                  height: 18,
                ),
                CustomTextField(
                  text: 'Confirm Password',
                  onTap: () {},
                  controller: _confirmPasswordController,
                  keyBoardType: TextInputType.text,
                  isSecure: true,
                  isPassword: true,
                ),
                const SizedBox(
                  height: 44,
                ),
                AppButton(
                    onPressed: () {
                      if (_nameController.text.isEmpty) {
                        getFlushBar(context, title: "Name cannot be empty.");
                        return;
                      }
                      if (_emailController.text.isEmpty) {
                        getFlushBar(context, title: "Email cannot be empty.");
                        return;
                      }
                      if (_passwordController.text.isEmpty) {
                        getFlushBar(context,
                            title: "Password cannot be empty.");
                        return;
                      }
                      if (_confirmPasswordController.text.isEmpty) {
                        getFlushBar(context,
                            title: "Confirm Password cannot be empty.");
                        return;
                      }
                      if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        getFlushBar(context, title: "Password does not match.");
                        return;
                      }
                      _signUpUser(context: context, signUp: signUp);
                    },
                    btnLabel: 'Sign up'),
                const SizedBox(
                  height: 18,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LogInView()));
                  },
                  child: RichText(
                      text: TextSpan(
                          text: 'Already have an account?',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              letterSpacing: 0.3,
                              fontWeight: FontWeight.w400),
                          children: [
                        TextSpan(
                            text: '  SignIn',
                            style: TextStyle(
                                color: FrontendConfigs.kPrimaryColor,
                                fontSize: 14,
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w500))
                      ])),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _signUpUser({
    required BuildContext context,
    required SignUpBusinessLogic signUp,
  }) async {
    isLoading = true;
    setState(() {});
    Provider.of<AppState>(context, listen: false)
        .stateStatus(StateStatus.IsBusy);

    await signUp
        .registerNewUser(
      email: _emailController.text,
      password: _passwordController.text,
      userModel: UserModel(
        email: _emailController.text,
        name: _nameController.text,
      ),
      context: context,
    )
        .then((user) async {
      isLoading = false;
      setState(() {});
      Provider.of<AppState>(context, listen: false)
          .stateStatus(StateStatus.IsFree);
      if (signUp.status == SignUpStatus.Registered) {
        showNavigationDialog(context,
            message: "Welcome to App!",
            buttonText: "Go to Login", navigation: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LogInView()));
        }, secondButtonText: "", showSecondButton: false);
      } else if (signUp.status == SignUpStatus.Failed) {
        showErrorDialog(context,
            message: Provider.of<ErrorString>(context, listen: false)
                .getErrorString());
      }
    }).onError((error, stackTrace) {
      isLoading = false;
      setState(() {});
      showErrorDialog(context, message: "An undefined error occurred.");
    });
  }
}
