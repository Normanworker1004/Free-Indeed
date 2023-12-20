import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:free_indeed/Managers/Implementation/Local-data-manager.impl.dart';
import 'package:free_indeed/Managers/LocalDataManager.dart';
import 'package:free_indeed/Screens/overlayNotification/OverlayNotification.dart';
import 'package:free_indeed/configs/Config.dart';
import 'package:free_indeed/configs/Network.dart';
import 'package:free_indeed/configs/general_configs.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';


import '../Models/ChatModel.dart';

class FirebaseRepo {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Network network = Network();

  Future<void> updateFireStoreData(
      String collectionPath, String path, Map<String, dynamic> updateData) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(updateData);
  }

  Stream<QuerySnapshot> getFireStoreData(
      String collectionPath, int limit, String? textSearch) {
    if (textSearch?.isNotEmpty == true) {
      return firebaseFirestore
          .collection(collectionPath)
          .limit(limit)
          // .where(FirestoreConstants.displayName, isEqualTo: textSearch)
          .snapshots();
    } else {
      return firebaseFirestore
          .collection(collectionPath)
          .limit(limit)
          .snapshots();
    }
  }

  Stream<QuerySnapshot> getChatMessage(String groupChatId, int limit) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection.value)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreConstants.timestamp.value, descending: true)
        .limit(limit)
        .snapshots();
  }

  Future<ChatMessages?> getLastMessage(String groupChatId) async {
    ChatMessages? chatMessage;
    var collection = FirebaseFirestore.instance
        .collection(FirestoreConstants.pathMessageCollection.value)
        .doc(groupChatId)
        .collection(groupChatId);
    var docSnapshot = await collection
        .doc(FirestoreConstants.lastMessageCollection.value)
        .get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      chatMessage = ChatMessages(
          idFrom: data?['idFrom'] ?? "",
          idTo: data?['idTo'] ?? "",
          timestamp: data?['timestamp'] ?? "",
          content: data?['content'] ?? "",
          type: data?['type'] ?? "");
      return chatMessage;
    }
    return chatMessage;
  }

  void sendChatMessage(String content, String type, String groupChatId,
      String currentUserId, String peerId) async {
    ///Investigate in the MessageTimeStamps
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection.value)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    ChatMessages chatMessages = ChatMessages(
        idFrom: currentUserId,
        idTo: peerId,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        type: type);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, chatMessages.toJson());
    });
  }

  // void saveLastMessage(String content, String type, String groupChatId,
  //     String currentUserId, String peerId) async {
  //   DocumentReference documentReference = firebaseFirestore
  //       .collection(FirestoreConstants.pathMessageCollection.value)
  //       .doc(groupChatId)
  //       .collection(groupChatId)
  //       .doc(FirestoreConstants.lastMessageCollection.value);
  //   ChatMessages chatMessages = ChatMessages(
  //       idFrom: currentUserId,
  //       idTo: peerId,
  //       timestamp: DateTime
  //           .now()
  //           .millisecondsSinceEpoch
  //           .toString(),
  //       content: content,
  //       type: type);
  //
  //   FirebaseFirestore.instance.runTransaction((transaction) async {
  //     transaction.set(documentReference, chatMessages.toJson());
  //   });
  // }

  Future<void> updateFirestoreData(
      String collectionPath, String docPath, Map<String, dynamic> dataUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(docPath)
        .update(dataUpdate);
  }

  void _handleMessage(RemoteMessage message) {
    print("when coming from background .. ");
  }

  void _handleLocalMessage(RemoteMessage message) {
    if (message.notification != null) {
      String notificationTitle = message.notification!.title != null
          ? message.notification!.title!
          : "";
      String notificationBody =
          message.notification!.body != null ? message.notification!.body! : "";

      showSimpleNotification(OverlayNotification(title: notificationTitle),
          subtitle: OverlayNotification(title: notificationBody),
          background: GeneralConfigs.BACKGROUND_COLOR);
      print("handling notification while inApp .. ");
    }
  }

  Future<void> initializeFireBaseMessaging() async {
    // await FirebaseMessaging.instance.setAutoInitEnabled(true);
    await firebaseMessaging.getInitialMessage();

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onMessage.listen(_handleLocalMessage);
    if (defaultTargetPlatform == TargetPlatform.android) {
      bool isPermissionDenied = await Permission.notification.isDenied;
      bool isPermissionLimited = await Permission.notification.isLimited;

      if (isPermissionDenied || isPermissionLimited) {
        await Permission.notification.request();
      }
    } else {
      NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      String accessToken =
          LocalDataManagerImpl().readString(CachingKey.ACCESS_TOKEN);
      if (accessToken.isNotEmpty) {
        sendNotificationTokenBackend(fcmToken);
      }
    }).onError((err) {
      print(err);
    });
  }

  Future<void> sendNotificationTokenBackend(String fcmToken) async {
    try {
      await network.getDataPostMethod(
          UrlConfigurations().baseURL +
              UrlConfigurations().insertUserNotificationTokenURL,
          {"token": fcmToken},
          token: "");
    } catch (e) {
      print(e);
    }
  }

  Future<void> disableNotifications() async {
    await FirebaseMessaging.instance.setAutoInitEnabled(false);
  }

  Future<void> enableNotifications() async {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
  }
}
