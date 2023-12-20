import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:free_indeed/Screens/commons/BackButtonComponent.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:free_indeed/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class CreateBlogScreen extends StatefulWidget {
  final Function submit;

  const CreateBlogScreen({Key? key, required this.submit}) : super(key: key);

  @override
  _CreateBlogScreenState createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<CreateBlogScreen> {
  String? _blogText = "";
  String? _blogTitleText = "";
  String? _imageName = "";
  String? _imageExtension = "";
  String? _imageBase64 = "";
  XFile? photo;
  ImagePicker _picker = ImagePicker();
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            AppLocalization.of(context)!
                .getLocalizedText("new_blog_screen_title"),
            style: TextStyle(fontSize: 16),
          ),
          leading: FreeIndeedBackButton(),
        ),
        backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: GestureDetector(
            onTap: () {
              focusNode.unfocus();
            },
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 35,
                    child: TextFormField(
                      maxLines: 1,
                      style: TextStyle(color: GeneralConfigs.SECONDARY_COLOR),
                      onChanged: (value) {
                        setState(() {
                          _blogTitleText = value;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: AppLocalization.of(context)!.getLocalizedText(
                            "new_blog_screen_blog_title_hint"),
                        hintStyle:
                            TextStyle(color: GeneralConfigs.SECONDARY_COLOR),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: SizedBox(
                    height: ScreenConfig.screenHeight - 380,
                    child: TextFormField(
                      maxLines: null,
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        setState(() {
                          _blogText = value;
                        });
                      },
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: AppLocalization.of(context)!
                            .getLocalizedText("new_blog_screen_text_hint"),
                        hintStyle: TextStyle(
                            color: GeneralConfigs.SECONDARY_COLOR
                                .withOpacity(0.25)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  width: ScreenConfig.screenWidth,
                  child: Text(
                    AppLocalization.of(context)!
                        .getLocalizedText("new_blog_screen_image_copyright"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: GeneralConfigs
                            .STATS_CHART_BAR_CHART_DASH_LINE_COLOR,
                        fontSize: 13),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    focusNode.unfocus();
                    EasyLoading.show(status: "");
                    photo =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (photo != null) {
                      _imageName = photo!.name;
                      _imageExtension = lookupMimeType(photo!.path);
                      var imageResized = await FlutterNativeImage.compressImage(
                          photo!.path,
                          quality: 50);
                      List<int> imageBytes = imageResized.readAsBytesSync();
                      _imageBase64 = base64.encode(imageBytes);
                      setState(() {});
                      print(_imageBase64);
                    }
                    EasyLoading.dismiss();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: DottedBorder(
                      color: Colors.white.withOpacity(0.2),
                      dashPattern: [4],
                      strokeCap: StrokeCap.round,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: GeneralConfigs.COMMUNITY_CARD_BACKGROUND_COLOR,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: photo == null
                                    ? Icon(Icons.image)
                                    : SizedBox(
                                        width: 65,
                                        height: 65,
                                        child: Image.asset(
                                          photo!.path,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: ScreenConfig.screenWidth - 200,
                              child: Text(
                                photo == null
                                    ? AppLocalization.of(context)!
                                        .getLocalizedText(
                                            "new_blog_screen_image_hint")
                                    : photo!.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: GeneralConfigs.SECONDARY_COLOR,
                                    fontSize: 15),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Container(
                      width: 200,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(26)),
                        border:
                            Border.all(color: GeneralConfigs.SECONDARY_COLOR),
                      ),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: GeneralConfigs.BACKGROUND_COLOR,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26.0),
                              )),
                          onPressed: () {
                            submitJournal();
                          },
                          child: Text(
                            AppLocalization.of(context)!.getLocalizedText(
                                "new_blog_screen_text_submit_button"),
                            style: TextStyle(
                                color: GeneralConfigs.SECONDARY_COLOR,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ));
  }

  void submitJournal() {
    if (_blogTitleText != null &&
        _blogTitleText != null &&
        _imageName != null &&
        _imageExtension != null &&
        _imageBase64 != null) {
      widget.submit(
          _blogTitleText, _blogText, _imageName, _imageExtension, _imageBase64);
    }
    // print("submitDate \n $_blogText");
    // print("submitDate \n $_blogTitleText");
  }
}
