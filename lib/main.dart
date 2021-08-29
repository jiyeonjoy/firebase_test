import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_test/sub_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, Item> _items = <String, Item>{};
Item _itemForMessage(Map<String, dynamic> message) {
  final dynamic data = message['data'] ?? message;
  final String itemId = data['id'];
  final Item item = _items.putIfAbsent(itemId, () => Item(itemId: itemId))
    ..status = data['status'];
  return item;
}

class Item {
  Item({this.itemId});
  final String itemId;

  final StreamController<Item> _controller = StreamController<Item>.broadcast();
  Stream<Item> get onChanged => _controller.stream;

  String _status;
  String get status => _status;
  set status(String value) {
    _status = value;
    _controller.add(this);
  }

  static final Map<String, Route<void>> routes = <String, Route<void>>{};
  Route<void> get route {
    final String routeName = '/detail/$itemId';
    return routes.putIfAbsent(
      routeName,
          () => MaterialPageRoute<void>(
        settings: RouteSettings(name: routeName),
        builder: (BuildContext context) => DetailPage(itemId),
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  DetailPage(this.itemId);
  final String itemId;
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Item _item;
  StreamSubscription<Item> _subscription;

  @override
  void initState() {
    super.initState();
    _item = _items[widget.itemId];
    _subscription = _item.onChanged.listen((Item item) {
      if (!mounted) {
        _subscription.cancel();
      } else {
        setState(() {
          _item = item;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item ${_item.itemId}'),
      ),
      body: Material(
        child: Center(child: Text('Item status: ${_item.status}')),
      ),
    );
  }
}


class FcmClass {
  static Color textColor = Colors.black;
  static String messageText ='...';
  static int count = 0;

  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();

    print('-------------------onBackgroundMessage: $message');
    await shared.setString('messageText', 'onBackgroundMessage: $message');

    return null;
  }
}

class PushMessagingExample extends StatefulWidget {
  @override
  _PushMessagingExampleState createState() => _PushMessagingExampleState();
}

class _PushMessagingExampleState extends State<PushMessagingExample> {
  String _homeScreenText = 'Waiting for token...';
  bool _topicButtonsDisabled = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final TextEditingController _topicController =
  TextEditingController(text: 'topic');

  Widget _buildDialog(BuildContext context, Item item) {
    return AlertDialog(
      content: Text('Item ${item.itemId} has been updated'),
      actions: <Widget>[
        FlatButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: const Text('SHOW'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  void _showItemDialog(Map<String, dynamic> message) {
    showDialog<bool>(
      context: context,
      builder: (_) => _buildDialog(context, _itemForMessage(message)),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToItemDetail(message);
      }
    });
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    final Item item = _itemForMessage(message);
    // Clear away dialogs
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    if (!item.route.isCurrent) {
      Navigator.push(context, item.route);
    }
  }

  String messageText = '';
  SharedPreferences shared;

  void initShared() async {
    shared = await SharedPreferences.getInstance();
    messageText = shared.getString('messageText');
    print('-------------------messageText-----------------: $messageText');
  }

  @override
  void initState() {
    super.initState();
    initShared();
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('-------------------onMessage: $message');
          await shared.setString('messageText', 'onMessage: $message');
          setState(() {

            FcmClass.messageText = 'onMessage: $message';
            FcmClass.textColor = Colors.yellow;
            FcmClass.count+=1;
          });
          _showItemDialog(message);
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('-------------------onLaunch: $message');
          await shared.setString('messageText', 'onLaunch: $message');

          setState(() {
            FcmClass.messageText = 'onLaunch: $message';
            FcmClass.textColor = Colors.blue;
            FcmClass.count+=100;
          });
          _navigateToItemDetail(message);
        },
        onResume: (Map<String, dynamic> message) async {
          await shared.setString('messageText', 'onResume: $message');
          print('-------------------onResume: $message');
          setState(() {
            FcmClass.messageText  = 'onResume: $message';
            FcmClass.textColor = Colors.deepOrangeAccent;
            FcmClass.count+=10000;
          });
          _navigateToItemDetail(message);
        },
        onBackgroundMessage: FcmClass.myBackgroundMessageHandler
    );


    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print('Settings registered: $settings');
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = 'Push Messaging token: $token';
      });
      print(_homeScreenText);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Push Messaging Demo'),
        ),
        // For testing -- simulate a message being received
        floatingActionButton: FloatingActionButton(
          // onPressed: () => _showItemDialog(<String, dynamic>{
          //   'data': <String, String>{
          //     'id': '2',
          //     'status': 'out of stock',
          //   },
          // }),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SubPage()),
            );
          },
          tooltip: 'Simulate Message',
          child: const Icon(Icons.message),
        ),
        body: Material(
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  _homeScreenText,
                  style: TextStyle(
                      color: FcmClass.textColor
                  ),
                ),
              ),
              Row(children: <Widget>[
                Expanded(
                  child: TextField(
                      controller: _topicController,
                      onChanged: (String v) {
                        setState(() {
                          _topicButtonsDisabled = v.isEmpty;
                        });
                      }),
                ),
                FlatButton(
                  child: const Text('subscribe'),
                  onPressed: _topicButtonsDisabled
                      ? null
                      : () {
                    _firebaseMessaging
                        .subscribeToTopic(_topicController.text);
                    _clearTopicText();
                  },
                ),
                FlatButton(
                  child: const Text('unsubscribe'),
                  onPressed: _topicButtonsDisabled
                      ? null
                      : () {
                    _firebaseMessaging
                        .unsubscribeFromTopic(_topicController.text);
                    _clearTopicText();
                  },
                ),
              ]),
              Center(
                child: Text(
                  '$messageText',
                  style: TextStyle(
                      color: FcmClass.textColor
                  ),
                ),
              ),

              Center(
                child: Text(
                  '${FcmClass.count}',
                  style: TextStyle(
                      color: FcmClass.textColor
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void _clearTopicText() {
    setState(() {
      _topicController.text = '';
      _topicButtonsDisabled = true;
    });
  }
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();
//
//   print('Handling a background message: ${message.messageId}');
// }

void main() {
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    MaterialApp(
      home: PushMessagingExample(),
    ),
  );
}