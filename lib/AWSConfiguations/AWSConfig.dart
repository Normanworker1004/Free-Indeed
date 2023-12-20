import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:free_indeed/amplifyconfiguration.dart';

class AWSConfig{

  Future<void> configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);

      await Amplify.configure(amplifyconfig);

    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    }
  }

}