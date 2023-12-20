import 'package:free_indeed/Managers/Implementation/Local-data-manager.impl.dart';
import 'package:free_indeed/Managers/Implementation/named_navigator_impl.dart';
import 'package:free_indeed/Managers/LocalDataManager.dart';
import 'package:free_indeed/Managers/named-navigator.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    NamedNavigator namedNavigator = NamedNavigatorImpl();
    return Scaffold(
      backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: ScreenConfig.screenWidth,
            height: ScreenConfig.screenHeight / 8,
            child: Center(
              child: SmoothPageIndicator(
                controller: pageController,
                count: 3,
                axisDirection: Axis.horizontal,
                effect: WormEffect(
                  dotHeight: 7,
                  spacing: 25,
                  dotWidth: 7,
                  dotColor: Colors.white.withOpacity(0.3),
                  activeDotColor: Colors.white,
                  type: WormType.normal,
                  // strokeWidth: 5,
                ),
              ),
            ),
          ),
          SizedBox(
            height: ScreenConfig.screenHeight,
            width: ScreenConfig.screenWidth,
            child: PageView(
              controller: pageController,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getImage(context, 'onboarding1.png'),
                      getTextWidget(context,
                          title: 'onboarding_page_one_title',
                          textOne: "onboarding_page_one_text"),
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getImage(context, 'onboarding2.png'),
                      getTextWidget(context,
                          title: 'onboarding_page_two_title',
                          textOne: "onboarding_page_two_text"),
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getImage(context, 'onboarding3.png'),
                      getTextWidget(context,
                          title: 'onboarding_page_three_title',
                          textOne: "onboarding_page_three_text_part_one",
                          textTwo: "onboarding_page_three_text_part_two",
                          textThree: "onboarding_page_three_text_part_three"),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  LocalDataManagerImpl()
                                      .writeData(CachingKey.OLD_USER, true);
                                  namedNavigator.push(Routes.SIGN_UP_ROUTER);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: GeneralConfigs
                                      .BACKGROUND_COLOR, // Background color
                                ),
                                child: Text(
                                  AppLocalization.of(context)!.getLocalizedText(
                                      "onboarding_page_three_sign_up_button"),
                                  style: TextStyle(
                                      color: GeneralConfigs.SECONDARY_COLOR),
                                )),
                          ],
                        ),
                      ),
                    ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getTextWidget(BuildContext context,
      {required String title,
      required String textOne,
      String? textTwo,
      String? textThree}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 34, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalization.of(context)!.getLocalizedText(title),
            style: TextStyle(
                color: GeneralConfigs.SECONDARY_COLOR,
                fontSize: 25,
                fontWeight: FontWeight.w800,
                fontFamily: "PT-Serif"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              thickness: 2,
              color: GeneralConfigs.TEXT_COLOR,
              endIndent: 2 * ScreenConfig.screenWidth / 3,
            ),
          ),
          RichText(
            text: TextSpan(
              text: AppLocalization.of(context)!.getLocalizedText(textOne),
              style: TextStyle(
                color: GeneralConfigs.TEXT_COLOR,
                wordSpacing: 1.25,
                fontSize: 15,
                height: 1.3,
                fontWeight: FontWeight.w400,
              ),
              children: <TextSpan>[
                textTwo != null
                    ? TextSpan(
                        text: AppLocalization.of(context)!
                            .getLocalizedText(textTwo),
                        style: TextStyle(
                            color: GeneralConfigs.TEXT_COLOR,
                            wordSpacing: 1.25,
                            fontSize: 15,
                            height: 1.3,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Badboy-Aliance"),
                      )
                    : TextSpan(text: ""),
                textThree != null
                    ? TextSpan(
                        text: AppLocalization.of(context)!
                            .getLocalizedText(textThree),
                        style: TextStyle(
                          color: GeneralConfigs.TEXT_COLOR,
                          wordSpacing: 1.25,
                          fontSize: 15,
                          height: 1.3,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : TextSpan(text: ""),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getImage(BuildContext context, String imageURL) {
    return SizedBox(
      height: (ScreenConfig.screenHeight * 0.6),
      width: ScreenConfig.screenWidth,
      child: Image.asset(
        GeneralConfigs.IMAGE_ASSETS_PATH + imageURL,
        fit: BoxFit.fill,
      ),
    );
  }
}
