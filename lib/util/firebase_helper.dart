import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import'package:firebase_messaging/firebase_messaging.dart';

class FireBaseHelper {
  static final FireBaseHelper _instance = FireBaseHelper._internal();

  factory FireBaseHelper() => _instance;

  Function() _onNavigator;

  void setOnCallback(Function() onNavigator) {
    _onNavigator = onNavigator;
  }

  FireBaseHelper._internal();

  FirebaseAnalytics _analytics = FirebaseAnalytics();
  FirebaseMessaging _firebaseMessaging =  FirebaseMessaging();

  String _token;
  String get token => _token ?? "";

  Future<void> init() async {
    _analytics?.logAppOpen();
  }

  Future<void> sendAnalyticsEvent() async {
    await _analytics?.logEvent(
      name: 'complete_list_product',
    );
  }

  Future<void> sendSignUpAnalyticsEvent() async {
    await _analytics?.logSignUp(
      signUpMethod: 'sign_up',
    );
  }

  void firebaseCloudMessagingListeners() async {
    try {
      if (Platform.isIOS) iOSPermission();

      _firebaseMessaging.getToken().then((token) {
        print('firebase token:' + token);
        _token = token;
      });

      // _firebaseMessaging.onTokenRefresh.listen((event) {
      //   print("firebase refresh event : $event");
      // });

      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('firebase on message $message');
        },
        onResume: (Map<String, dynamic> message) async {
          print('firebase on resume $message');
          // _onNavigator();
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('firebase on launch $message');
        },
        // onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      );
    } catch (e) {
      print("exception : $e");
    }
  }

  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}