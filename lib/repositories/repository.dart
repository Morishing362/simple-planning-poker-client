import 'dart:convert';
import 'dart:io';

import 'package:flutter_rust_app/entities/entity.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/html.dart';

import '../entities/entity.dart';

const String url = 'http://localhost:8000';

const Map<String, String> headers = {
  HttpHeaders.contentTypeHeader: 'application/json',
};

class BackendRepository {
  BackendRepository({
    required this.httpClient,
    this.wsChannel,
  });

  final http.Client httpClient;
  late HtmlWebSocketChannel? wsChannel;
  late String userId;
  late String registerId;

  Future<String> register(UserData userData) async {
    userId = userData.userId;
    final body = jsonEncode(userData.toJson());
    try {
      final response = await httpClient
          .post(
            Uri.parse('$url/register'),
            headers: headers,
            body: body,
          )
          .timeout(const Duration(seconds: 5));
      final json = jsonDecode(response.body);
      final wsUrl = json['url'] as String;
      final parsedUrl = wsUrl.split('/');
      registerId = parsedUrl.last;
      return wsUrl;
    } catch (err) {
      throw Exception('registration error');
    }
  }

  Future<void> connect(String url) async {
    try {
      wsChannel = HtmlWebSocketChannel.connect(url);
    } catch (err) {
      throw Exception('websocket handshake error');
    }
  }

  Future<void> unregister() async {
    try {
      final _ = await httpClient
          .delete(
            Uri.parse('$url/register/$registerId'),
            headers: headers,
            body: '{}',
          )
          .timeout(const Duration(seconds: 5));
    } catch (err) {
      throw Exception('registration error');
    }
  }

  void disconnect() => wsChannel!.sink.close();

  void publishMessage(MessageContent messageContent) {
    final input = Input(procId: 'publish', data: messageContent).toString();
    wsChannel!.sink.add(input);
  }

  void cardPost(Card card) {
    final input = Input(procId: 'card_post', data: card).toString();
    wsChannel!.sink.add(input);
  }

  void cardDelete(Card card) {
    final input = Input(procId: 'card_delete', data: card).toString();
    wsChannel!.sink.add(input);
  }

  void result() {
    final input =
        Input(procId: 'result', data: UserId(userId: userId)).toString();
    wsChannel!.sink.add(input);
  }

  void clean() {
    final input =
        Input(procId: 'clean', data: UserId(userId: userId)).toString();
    wsChannel!.sink.add(input);
  }

  void refresh() {
    final input =
        Input(procId: 'refresh', data: UserId(userId: userId)).toString();
    wsChannel!.sink.add(input);
  }
}
