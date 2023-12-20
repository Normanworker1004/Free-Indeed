import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:free_indeed/Managers/named-navigator.dart';
import 'package:free_indeed/Models/BlogPreviewModel.dart';
import 'package:free_indeed/Models/UserModel.dart';
import 'package:free_indeed/Models/VerseModel.dart';

import '../../Models/BlogModel.dart';
import '../../Repo/library_repo.dart';

part 'library_event.dart';

part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final NamedNavigator _namedNavigator;
  final BlogRepo _libraryRepo;

  late String accessToken;
  late UserModel userModel;
  late List<VerseModel> verses;
  late List<BlogPreviewModel> fellowIndeedBlogs;
  late List<BlogPreviewModel> moreBlogs;

  LibraryBloc(
      {required NamedNavigator namedNavigator, required BlogRepo libraryRepo})
      : this._namedNavigator = namedNavigator,
        this._libraryRepo = libraryRepo,
        super(LibraryInitial()) {
    on<LibraryInitialEvent>((event, emit) async {
      // EasyLoading.show(status: "");
      accessToken = "";
      fellowIndeedBlogs = [];
      moreBlogs = [];
      // EasyLoading.dismiss();
      emit(LibraryReadyState(fellowIndeedBlogs: [], moreBlogs: []));
      fellowIndeedBlogs = await _libraryRepo.getFellowIndeedBlogs(accessToken);
      moreBlogs = await _libraryRepo.getMoreBlogs(accessToken);
    });
    on<LibraryGetFreeIndeedBlogsEvent>((event, emit) async {
      EasyLoading.show(status: "");
      if (fellowIndeedBlogs.isEmpty) {
        fellowIndeedBlogs =
            await _libraryRepo.getFellowIndeedBlogs(accessToken);
      }
      EasyLoading.dismiss();
      emit(LibraryReadyState(
          fellowIndeedBlogs: fellowIndeedBlogs, moreBlogs: moreBlogs));
    });
    on<LibraryGetMoreTabBlogsEvent>((event, emit) async {
      EasyLoading.show(status: "");
      if (moreBlogs.isEmpty) {
        moreBlogs = await _libraryRepo.getMoreBlogs(accessToken);
      }
      EasyLoading.dismiss();
      emit(LibraryReadyState(
          fellowIndeedBlogs: fellowIndeedBlogs, moreBlogs: moreBlogs));
    });

    on<LibraryGoToBlogEvent>((event, emit) async {
      EasyLoading.show(status: "");
      BlogModel? blog = await _libraryRepo.getAdminBlog(accessToken, event.id);
      if (blog != null) {
        _namedNavigator.push(Routes.BLOG_ROUTER, arguments: blog);
      }
      EasyLoading.dismiss();
    });

    on<LibraryGoToUserBlogEvent>((event, emit) async {
      EasyLoading.show(status: "");
      BlogModel? blog =
          await _libraryRepo.getUserBlogDetails(accessToken, event.id);
      if (blog != null) {
        _namedNavigator.push(Routes.BLOG_ROUTER, arguments: blog);
      }
      EasyLoading.dismiss();
    });

    on<LibrarySubmitBlogEvent>((event, emit) async {
      _namedNavigator.push(Routes.CREATE_BLOG_ROUTER, arguments: (String title,
          String blogBody,
          String imageName,
          String extension,
          String imageBase64) async {
        try {
          EasyLoading.show(status: "");
          String finalName =
              imageName.replaceAll("." + imageName.split(".").last, "");
          String finalExtension = extension.replaceAll("image/", "");
          bool success = await _libraryRepo.submitBlog(
              accessToken: accessToken,
              title: title,
              imageBase64: imageBase64,
              blogBody: blogBody,
              extension: finalExtension,
              imageName: finalName);
          if (success) {
            EasyLoading.dismiss();
            _namedNavigator.pop();
          } else {
            EasyLoading.dismiss();

            EasyLoading.showToast("Something went wrong .. try again later");
          }
        } catch (e) {
          print(e);
          EasyLoading.dismiss();
          EasyLoading.showToast("Something went wrong .. try again later");
        }
      });
    });
  }
}
