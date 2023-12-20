import 'package:free_indeed/Blocs/SignUpBloc/sign_up_bloc.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Repo/login_repo.dart';
import 'package:free_indeed/Screens/commons/HeaderWithLogo.dart';
import 'package:free_indeed/Screens/commons/LoadingState.dart';
import 'package:free_indeed/Screens/commons/SignUpTextForm.dart';
import 'package:free_indeed/Screens/commons/PrimaryButton.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscure = true;
  bool checkbox = false;

  SignUpBloc _signUpBloc =
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
              HeaderWithLogo(
                headerTitle: "sign_up_page_title",
                headerText: "sign_up_page_welcome_text",
              ),
              // getHeaderWidgets(context),
              BlocProvider(
                create: (BuildContext context) {
                  return _signUpBloc;
                },
                child: BlocBuilder<SignUpBloc, SignUpState>(
                    builder: (context, state) {
                  if (state is SignUpLoadingState) {
                    return LoadingState();
                  } else if (state is SignUpInitialState) {
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Container(
        width: ScreenConfig.screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SignUpTextFormField(
                  label: "sign_up_page_username_title",
                  controller: usernameController,
                  showIcon: false),
              SignUpTextFormField(
                  label: "sign_up_page_email_title",
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
                padding: EdgeInsets.symmetric(vertical: 25),
                child: SizedBox(
                    width: ScreenConfig.screenWidth,
                    height: 50,
                    child: PrimaryButton(
                      onTap: checkbox
                          ? () {
                              createAccount();
                            }
                          : () {},
                      buttonText: "sign_up_page_sign_up_button_text",
                    )),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: termsAndConditionsCheck(context)),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 40),
                child: GestureDetector(
                  onTap: () {
                    alreadyHaveAccount();
                  },
                  child: Center(
                    child: Text(
                      AppLocalization.of(context)!
                          .getLocalizedText("sign_up_page_sign_in_text"),
                      style: TextStyle(
                          color: GeneralConfigs.HAVE_ACCOUNT_COLOR,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget termsAndConditionsCheck(BuildContext context) {
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
          SizedBox(
            width: 3 * ScreenConfig.screenWidth / 5,
            child: Padding(
              padding: EdgeInsets.only(bottom: 9, right: 9, left: 9),
              child: Text(
                AppLocalization.of(context)!
                    .getLocalizedText("sign_up_page_terms_and_conditions_text"),
                style: TextStyle(color: GeneralConfigs.CHECKBOX_BOARDER_COLOR),
              ),
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

  void createAccount() {
    _signUpBloc.add(SigningUpEvent(
        userName: usernameController.text,
        email: emailController.text,
        password: passwordController.text));
  }

  void alreadyHaveAccount() {
    _signUpBloc.add(SignUpGoToSignInEvent());
  }
}
