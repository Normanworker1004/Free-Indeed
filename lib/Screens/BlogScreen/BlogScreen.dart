import 'package:flutter/material.dart';
import 'package:free_indeed/Models/BlogModel.dart';
import 'package:free_indeed/Screens/commons/BackButtonComponent.dart';
import 'package:free_indeed/configs/ScreenConfig.dart';
import 'package:free_indeed/configs/general_configs.dart';

class BlogScreen extends StatefulWidget {
  final BlogModel blog;

  const BlogScreen({Key? key, required this.blog}) : super(key: key);

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
        leading: FreeIndeedBackButton(),
      ),
      backgroundColor: GeneralConfigs.BACKGROUND_COLOR,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: ScreenConfig.screenWidth,
                  height: ScreenConfig.screenHeight / 3,
                  child: Image.network(
                    widget.blog.imageURL!,
                    fit: BoxFit.fitHeight,
                  )),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                child: Text(
                  widget.blog.blogName!,
                  style: TextStyle(
                      color: GeneralConfigs.SECONDARY_COLOR, fontSize: 25),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                child: Text(
                  // DateFormat('MM/dd/yy')
                  //     .format(DateTime.parse(widget.blog.timeStamp!)),
                  widget.blog.timeStampNew ?? "",
                  style: TextStyle(
                      color: GeneralConfigs.POST_TIME_STAMP_COLOR,
                      fontSize: 14),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                child: Text(
                  //TODO: THIS IS STILL MOCKED AND NEED TO BE VERIFIED WITH THE BACKEND
                  widget.blog.blogdata!,
                  style: TextStyle(
                      color: GeneralConfigs.SECONDARY_COLOR, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
