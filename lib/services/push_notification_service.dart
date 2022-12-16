// E6:9C:15:64:E1:DA:05:C5:FC:32:77:71:60:E2:26:A2:2C:D7:BE:06

import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static FlutterSecureStorage storage = const FlutterSecureStorage();
  static String? token;
  static const String _baseurl =
      'flutter-products-51550-default-rtdb.firebaseio.com';
  static const api_key =
      "key=AAAA9l92dDc:APA91bGk3KynN_1DYh81wU2KzmMYBF0mB-V89vRiL02XmzdeV25GwcBabpPySKOzJjNuKXCGAAlmOFeEsO_P2ELnzyfWNWdeC5XjKKVmkVbQ_-igdjIDjcs0mNG_issQNbWwOWY8d8GT";
  static final StreamController<String> _messageController =
      StreamController.broadcast();
  static Stream<String> get streamMessage => _messageController.stream;

  static Future init() async {
    // Push notification
    await Firebase.initializeApp();
    await storeTokenInDBAndDevice();
    // Handlers
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onOpenedAppHandler);
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    // Local notification
  }

  static Future<Map<String, dynamic>> getTokens() async {
    final url = Uri.https(_baseurl, '/tokens.json');
    final res = await http.get(url);
    return jsonDecode(res.body);
  }

  static Future sendPushNotification() async {
    final Map<String, dynamic> tokens = await getTokens();
    List<Future> httpTokenRequests = [];
    // final fcmToken = storage.read(key: 'fcmToken');
    tokens.forEach((key, value) async {
      print(value['token']);
      httpTokenRequests.add(Future(() async {
        if (value['token'] != token) {
          const url = "fcm.googleapis.com";
          final uri = Uri.https(
            url,
            '/fcm/send',
          );
          Map<String, dynamic> body = {
            "data": {"score": "5x1", "time": "15:10"},
            "notification": {
              "body": "Productos",
              "title": "Hay nuevos productos para ver"
            },
            "to": "${value['token']}"
          };
          final res = await http.post(uri, body: jsonEncode(body), headers: {
            'Content-Type': 'application/json',
            'Authorization': api_key
          });
          print(res.body);
        }
      }));
    });
    await Future.wait(httpTokenRequests);
  }

  static Future storeTokenInDBAndDevice() async {
    token = await messaging.getToken();
    print(token);
    await storeFcmToken();
  }

  static Future storeFcmToken() async {
    final tkn = await storage.read(key: 'fcmToken') ?? '';
    if (tkn != '') return;
    final stored = await storeTokeinInDB(token);
    if (!stored) return;

    await storage.write(key: 'fcmToken', value: token);
  }

  static Future<bool> storeTokeinInDB(token) async {
    final url = Uri.https(_baseurl, '/tokens.json');
    final res = await http.post(url, body: jsonEncode({'token': token}));
    if (res.statusCode == 200 || res.statusCode == 201) return true;
    return false;
  }

  static Future deleteToken() async {
    await storage.delete(key: 'fcmToken');
    await messaging.deleteToken();
  }

  static Future _backgroundHandler(RemoteMessage message) async {
    print('cayo la notificacion de background');
    final String token = await storage.read(key: 'token') ?? '';

    if (token != '') {
      _messageController.add(message.notification?.title ?? 'No title');
    }
  }

  static Future _onOpenedAppHandler(RemoteMessage message) async {
    print('cayo la notificacion de onOpened');
    final String token = await storage.read(key: 'token') ?? '';

    if (token != '') {
      _messageController.add(message.notification?.title ?? 'No title');
    }
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print('cayo la notificacion de onMessage');
    final String token = await storage.read(key: 'token') ?? '';
    if (token != '') {
      _messageController.add(message.notification?.title ?? 'No title');
    }
  }
}
