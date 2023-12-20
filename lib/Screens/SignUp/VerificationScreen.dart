import 'package:free_indeed/Blocs/SignUpBloc/sign_up_bloc.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Repo/login_repo.dart';
import 'package:free_indeed/Screens/commons/LoadingState.dart';
import 'package:free_indeed/Screens/commons/PrimaryButton.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationArgs {
  final String email;
  final bool fromSignIn;

  VerificationArgs({required this.email, required this.fromSignIn});
}

class VerificationScreen extends StatefulWidget {
  final VerificationArgs verificationArgs;

  const VerificationScreen({Key? key, required this.verificationArgs})
      : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController codeController = TextEditingController();
  String otpValue = "";
  LoginRepo loginRepo = LoginRepo();
  SignUpBloc _signupBloc =
      SignUpBloc(loginRepo: LoginRepo(), namedNavigator: NamedNavigatorImpl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // getHeaderWidgets(context),
              BlocProvider(
                create: (BuildContext context) {
                  return _signupBloc;
                },
                child: BlocBuilder<SignUpBloc, SignUpState>(
                    builder: (context, state) {
                  // context.read<SignUpBloc>().add(AuthenticationInitializeEvent());
                  if (state is SignUpLoadingState) {
                    return LoadingState();
                  } else if (state is SignUpInitialState) {
                    if (widget.verificationArgs.fromSignIn) {
                      _signupBloc.add(SignUpResendCodeEvent(
                          email: widget.verificationArgs.email));
                    }
                    return getWhiteRectangle(context);
                  } else {
                    return Center(
                      child: Text("Fatal Error!"),
                    );
                  }
                }),
              )
            ],
          ),
        ));
  }

  Widget getWhiteRectangle(BuildContext context) {
    return Container(
      height: ScreenConfig.screenHeight,
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(
                  child: SizedBox(
                    width: 75,
                    height: 75,
                    child: Image.asset(
                      GeneralConfigs.IMAGE_ASSETS_PATH + "logo.png",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  AppLocalization.of(context)!
                      .getLocalizedText("sign_up_page_welcome_title"),
                  style: TextStyle(
                    color: GeneralConfigs.TEXT_COLOR,
                    wordSpacing: 1.25,
                    fontSize: 17,
                    height: 1.5,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              SizedBox(
                height: ScreenConfig.screenHeight / 10,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  AppLocalization.of(context)!
                      .getLocalizedText("verification_code_screen_header"),
                  style: TextStyle(
                    color: GeneralConfigs.SECONDARY_COLOR,
                    wordSpacing: 1.25,
                    fontSize: 32,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Text(
                AppLocalization.of(context)!
                    .getLocalizedText("verification_code_screen_text"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: GeneralConfigs.TEXT_COLOR,
                  wordSpacing: 1.25,
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30.0),
            child: PinCodeTextField(
              length: 6,
              obscureText: false,
              enableActiveFill: true,
              animationType: AnimationType.fade,
              keyboardType: TextInputType.number,
              cursorColor: Colors.black,
              textStyle: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 40),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(4),
                inactiveColor: Colors.transparent,
                fieldHeight: 50,
                fieldWidth: 50,
                borderWidth: 0,
                disabledColor: Colors.white,
                inactiveFillColor: Colors.white,
                activeFillColor: Colors.white,
                activeColor: Colors.white,
                selectedFillColor: Colors.white,
                selectedColor: Colors.white,
              ),
              animationDuration: Duration(milliseconds: 300),
              hintCharacter: AppLocalization.of(context)!
                  .getLocalizedText("verification_page_hint"),
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 40),
              backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
              controller: codeController,
              onCompleted: (v) {
                print("Completed");
                verifyAccount();
              },
              onChanged: (value) {
                otpValue = value;
                print(otpValue);
              },
              beforeTextPaste: (text) {
                print("Allowing to paste $text");
                return false;
              },
              appContext: context,
            ),
          ),
          SizedBox(
            height: ScreenConfig.screenHeight / 10,
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: ScreenConfig.screenWidth / 4),
            child: SizedBox(
                width: ScreenConfig.screenWidth,
                height: 50,
                child: PrimaryButton(
                  onTap: () {
                    verifyAccount();
                  },
                  buttonText: "verification_screen_text_verify_button",
                )),
          ),
          SizedBox(
            height: ScreenConfig.screenHeight / 10,
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: 15, bottom: 40),
          //   child: GestureDetector(
          //     onTap: () {
          //       alreadyHaveAccount(context);
          //     },
          //     child: Center(
          //       child: Text(
          //         AppLocalization.of(context)!
          //             .getLocalizedText("sign_up_page_sign_in_text"),
          //         style: TextStyle(
          //             color: GeneralConfigs.HAVE_ACCOUNT_COLOR,
          //             fontSize: 12,
          //             fontWeight: FontWeight.w400),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  void verifyAccount() {
    _signupBloc.add(VerifyCodeEvent(
        code: codeController.text, email: widget.verificationArgs.email));

    print(codeController.text + "email:" + widget.verificationArgs.email);
  }

// void alreadyHaveAccount(BuildContext context) {
//   context.read<SignUpBloc>().add(SignUpGoToSignInEvent());
// }
}
