import 'package:event_app/presentation/views/auth/sign_up/sign_up_view.dart';
import 'package:event_app/presentation/views/events/view_events/display_event_view.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../../../../../application/error_string.dart';
import '../../../../../application/login_business_logic.dart';
import '../../../../../configs/enums.dart';
import '../../../../../configs/front_end_configs.dart';
import '../../../../../infrastructure/services/auth.dart';
import '../../../../elements/app_button.dart';
import '../../../../elements/auth_field.dart';
import '../../../../elements/custom_text.dart';
import '../../../../elements/error_dialog.dart';
import '../../../../elements/flush_bar.dart';
import '../../../../elements/processing_widget.dart';

class LogInBody extends StatefulWidget {
  LogInBody({Key? key}) : super(key: key);

  @override
  State<LogInBody> createState() => _LogInBodyState();
}

class _LogInBodyState extends State<LogInBody> {

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  LoginBusinessLogic data = LoginBusinessLogic();

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthServices>(context);
    return SafeArea(
      child: LoadingOverlay(
        isLoading: auth.status == Status.Authenticating,
        progressIndicator: ProcessingWidget(),
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          text: 'Sign in to continue',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 54,
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
                  height: 34,
                ),
                AppButton(
                    onPressed: () async {
                      if (_emailController.text.isEmpty) {
                        getFlushBar(context, title: "Email cannot be empty.");
                        return;
                      }
                      if (_passwordController.text.isEmpty) {
                        getFlushBar(context,
                            title: "Password cannot be empty.");
                        return;
                      }
                      loginUser(
                          context: context,
                          data: data,
                          email: _emailController.text,
                          password: _passwordController.text);
                    },
                    btnLabel: 'Sign in'),
                SizedBox(height: 50,),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpView()));
                    },
                    child: RichText(
                        text: TextSpan(
                            text: 'Dont have an account?',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w400),
                            children: [
                              TextSpan(
                                  text: '  Sign Up',
                                  style: TextStyle(
                                      color: FrontendConfigs.kPrimaryColor,
                                      fontSize: 14,
                                      letterSpacing: 0.3,
                                      fontWeight: FontWeight.w500))
                            ])),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  loginUser(
      {required BuildContext context,
      required LoginBusinessLogic data,
      required String email,
      required String password}) async {
    var auth = Provider.of<AuthServices>(context, listen: false);
    if (!mounted) return;
    data
        .loginUserLogic(context, email: email, password: password)
        .then((val) async {
      print(auth.status);
      if (auth.status == Status.Authenticated) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DisplayEventView()),
            (route) => false);
      } else {
        showErrorDialog(context,
            message: Provider.of<ErrorString>(context, listen: false)
                .getErrorString());
      }
    });
  }
}
