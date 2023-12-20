import 'package:equatable/equatable.dart';
import 'package:free_indeed/configs/base.bloc.dart';

class UrlConfigurations {
  String baseURL =
      "https://c8oxdx9ys1.execute-api.us-east-1.amazonaws.com/Dev/";
  String loginURL = "users/login";
  String signUpURL = "users/signup";
  String getUserDataURL = "users/loggedIn";
  String getAllPostsURL = "posts/all?page=[@]&limit=10";
  String getFriendsPostsURL = "posts/friends?page=[@]&limit=10";
  String getMyPostsURL = "posts/mine?page=[@]&limit=10";
  String createNewPostURL = "posts/create";
  String reportPostURL = "/posts/details/[@]/reports/create";
  String getPostsCommentsURL = "posts/details/";
  String addCommentURL = "posts/details/[@]/comments/create";
  String editPostURL = "posts/edit/[@]";
  String deletePostURL = "posts/delete/[@]";
  String deleteCommentURL = "posts/details/[@]/comments/delete/[#]";
  String likePostURL = "posts/details/[@]/likes/create";
  String unlikePostURL = "posts/details/[@]/likes/unlike";
  String getAllUsersURL = "users?page=[@]&limit=10";
  String getMyFriendsOnlyURL = "friends/mine?page=[@]&limit=10";
  String getNamedUsersURL = "users?page=[@]&limit=10&userName=[#]";
  String addFriendURL = "friends/add";
  String removeFriendURL = "friends/remove";
  String muteUserURL = "users/mute";
  String getMyJournalsURL = "journals/mine?page=[@]&limit=10";
  String getMyNotificationsURL = "push/notifications?page=[@]&limit=10";
  String addJournalsURL = "journals/create";
  String editJournalsURL = "journals/edit/[@]";
  String deleteJournalsURL = "journals/delete/[@]";
  String getRelapsesListURL = "iRelapsed/relapses";
  String getTriggersListURL = "iRelapsed/triggers";
  String createIRelapsedURL = "iRelapsed/create";
  String editIRelapsedURL = "iRelapsed/edit/[@]";
  String deleteIRelapsedURL = "iRelapsed/delete/[@]";
  String iRelapsedListURL = "iRelapsed/mine";
  String triggersChartURL = "iRelapsed/myStats/getTriggersChart";
  String cleanDaysStreakChartURL = "iRelapsed/myStats/getCleanDaysChart";
  String relapsesPerChartURL =
      "iRelapsed/myStats/getRelapsesPerMonthChart?relapseId=[@]";
  String relapsesPerDayChartURL = "iRelapsed/myStats/getRelapsesPerDayChart";
  String createKindaWannaRelapseURL = "iRelapsed/kindaWannaRelapse/create";
  String getKindaWannaRelapseURL =
      "iRelapsed/kindaWannaRelapse/list?page=[@]&limit=10";
  String updateKindaWannaRelapseURL = "/iRelapsed/kindaWannaRelapse/edit/[@]";
  String deleteKindaWannaRelapseURL = "iRelapsed/kindaWannaRelapse/delete/[@]";
  String categoryVersesURL = "blogs/verses?page=[@]&limit=10&categoryId=[#]";
  String versesCategoriesURL = "blogs/verses/categories";
  String setGoalURL = "iRelapsed/goal/create";
  String getGoalURL = "iRelapsed/goal/getDetails";
  String submitBlogURL = "blogs/create";
  String getAdminBlogsURL = "blogs/admin/all";
  String getUsersBlogsURL = "blogs/all";
  String getAdminBlogDetailsURL = "blogs/admin/details/[@]";
  String getUserBlogDetailsURL = "blogs/details/[@]";
  String startNewIndividualChatURL = "chats/generate";
  String startNewGroupChatURL = "chats/group/generate";
  String getAllChatsURL = "chats/all?page=[@]&limit=10";
  String getUserCognitoIdURL = "users/loggedIn";
  String getGroupParticipantListURL = "chats/[@]/participants";
  String changeGroupChatNameURL = "chats/edit/[@]";
  String addLastMessageURL = "chats/edit/[@]/lastMessage";
  String removeParticipantURL = "chats/[@]/participants/remove";
  String leaveChatURL = "chats/[@]/leave";
  String deleteGroupChatURL = "/chats/[@]/group/delete";
  String deleteIndividualChatURL = "chats/[@]/delete";
  String addGroupChatParticipantURL = "chats/[@]/participants/add";
  String getFreeIndeedUserIdURL = "users/getFreeIndeedAccountId";
  String getUserGoalURL = "iRelapsed/goal/getCurrentGoalDays";
  String editUserNameURL = "users/edit/username";
  String getSettingsURL = "users/settings";
  String insertUserNotificationTokenURL = "push/tokens/insert";
}

class ContactStatus extends Enum<String> with EquatableMixin {
  const ContactStatus(String val) : super(val);
  static const ContactStatus ONLINE = ContactStatus('ONLINE');
  static const ContactStatus OFFLINE = ContactStatus('OFFLINE');

  @override
  List<Object?> get props => [value];
}

class MessageType extends Enum<String> with EquatableMixin {
  const MessageType(String val) : super(val);
  static const MessageType TEXT = MessageType('TEXT');
  static const MessageType LAST_MESSAGE = MessageType('LAST_MESSAGE');

  @override
  List<Object?> get props => [value];
}

class SettingsType extends Enum<String> with EquatableMixin {
  const SettingsType(String val) : super(val);
  static const MessageType CONTACT_US = MessageType('contact_us');
  static const MessageType PRIVACY_POLICY = MessageType('privacy_policy');
  static const MessageType TERMS_AND_CONDITIONS =
      MessageType('terms_and_conditions');

  @override
  List<Object?> get props => [value];
}

class FirestoreConstants extends Enum<String> with EquatableMixin {
  const FirestoreConstants(String val) : super(val);
  static const FirestoreConstants pathMessageCollection =
      FirestoreConstants('pathMessageCollection');
  static const FirestoreConstants lastMessageCollection =
      FirestoreConstants('lastMessageDocument');
  static const FirestoreConstants timestamp = FirestoreConstants('timestamp');
  static const FirestoreConstants idFrom = FirestoreConstants('idFrom');
  static const FirestoreConstants idTo = FirestoreConstants('idTo');
  static const FirestoreConstants content = FirestoreConstants('content');
  static const FirestoreConstants type = FirestoreConstants('type');

  @override
  List<Object?> get props => [value];
}
