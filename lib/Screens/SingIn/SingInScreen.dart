import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Repo/FirebaseRepo.dart';
import 'package:free_indeed/Repo/login_repo.dart';
import 'package:free_indeed/Screens/commons/HeaderWithLogo.dart';
import 'package:free_indeed/Screens/commons/LoadingState.dart';
import 'package:free_indeed/Screens/commons/PrimaryButton.dart';
import 'package:free_indeed/Screens/commons/SignUpTextForm.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Blocs/login/authentication_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscure = true;
  bool checkbox = false;

  AuthenticationBloc _authenticationBloc = AuthenticationBloc(
      loginRepo: LoginRepo(), namedNavigator: NamedNavigatorImpl(),firebaseRepo: FirebaseRepo());

  @override
  void initState() {
    _authenticationBloc.add(AuthenticationInitializeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return _authenticationBloc;
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
        if (state is AuthenticationLoading) {
          return LoadingState();
        } else if (state is AuthenticationReady) {
          return Scaffold(
            backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWithLogo(headerTitle: "sign_in_page_title"),
                  getWhiteRectangle(context),
                ],
              ),
            ),
          );
        } else if (state is AuthenticationLoggedIn) {
          return Center(
            child: Text("Logged In"),
          );
        } else {
          return Center(
            child: Text("Fatal Error!"),
          );
        }
      }),
    );
  }

  Widget getWhiteRectangle(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Container(
            width: ScreenConfig.screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SignUpTextFormField(
                      label: "sign_in_page_email_label_text",
                      controller: emailController,
                      showIcon: false),
                  SignUpTextFormField(
                    label: "sign_up_page_password_title",
                    controller: passwordController,
                    showIcon: true,
                    obscure: obscure,
                    iconFunction: showHidePassword,
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // faceIdCheck(context),
                            Expanded(child: Container()),
                            GestureDetector(
                              onTap: () {
                                forgetPassword();
                              },
                              child: Text(
                                AppLocalization.of(context)!.getLocalizedText(
                                    "sign_in_page_allow_forget_password_text"),
                                style: TextStyle(
                                    color: GeneralConfigs.LABEL_COLOR),
                              ),
                            )
                          ])),
                  SizedBox(
                    height: ScreenConfig.screenHeight / 6,
                  ),
                  SizedBox(
                    width: ScreenConfig.screenWidth,
                    height: 50,
                    child: PrimaryButton(
                        onTap: () {
                          signIn();
                        },
                        buttonText: "sign_in_page_allow_Sign_in_button"),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 50),
                      child: GestureDetector(
                        onTap: () {
                          signUp();
                        },
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                                text: AppLocalization.of(context)!
                                    .getLocalizedText(
                                        "sign_in_page_do_not_have_account_text"),
                                style: TextStyle(
                                  color: GeneralConfigs.HAVE_ACCOUNT_COLOR,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: AppLocalization.of(context)!
                                        .getLocalizedText(
                                            "sign_in_page_allow_Sign_up"),
                                    style: TextStyle(
                                      color: GeneralConfigs.BACKGROUND_COLOR,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ]),
                          ),
                        ),
                      ))
                ],
              ),
            )));
  }

  Widget faceIdCheck(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          checkbox = !checkbox;
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 16,
            height: 15,
            child: Transform.scale(
              scale: 1,
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
                ),
                side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(
                      width: 1.0, color: GeneralConfigs.CHECKBOX_BOARDER_COLOR),
                ),
                activeColor: Colors.black,
                value: checkbox,
                onChanged: (bool? value) {
                  setState(() {
                    checkbox = !checkbox;
                    print(checkbox);
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 9, right: 9, left: 9),
            child: Text(
              AppLocalization.of(context)!
                  .getLocalizedText("sign_in_page_allow_face_ID_text"),
              style: TextStyle(color: GeneralConfigs.BACKGROUND_COLOR),
            ),
          ),
        ],
      ),
    );
  }

  void showHidePassword() {
    setState(() {
      obscure = !obscure;
    });
  }

  void forgetPassword() {
    _authenticationBloc.add(AuthenticationGoToForgetPassword());
  }

  void signIn() {
    _authenticationBloc.add(AuthenticationLoginEvent(
        userName: emailController.text, password: passwordController.text));
  }

  void signUp() {
    _authenticationBloc.add(AuthenticationGoToSignUp());
  }
}
