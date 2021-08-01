import 'dart:convert';

abstract class Data {
  Map<String, dynamic> toJson();
}

class Input {
  const Input({
    required this.procId,
    required this.data,
  });
  final String procId;
  final Data data;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['proc_id'] = procId;
    json['data'] = data.toJson();
    return json;
  }

  @override
  String toString() => jsonEncode(toJson());
}

class UserId extends Data {
  UserId({
    required this.userId,
  });

  final String userId;

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        userId: json['user_id'] as String,
      );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_id'] = userId;
    return data;
  }
}

class UserData extends Data {
  UserData({
    required this.userId,
    required this.url,
  });

  final String userId;
  final String url;

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_id'] = userId;
    data['url'] = url;
    return data;
  }
}

class MessageContent extends Data {
  MessageContent({
    required this.userId,
    required this.message,
  });

  final String userId;
  final String message;

  factory MessageContent.fromJson(Map<String, dynamic> json) => MessageContent(
        userId: json['user_id'] as String,
        message: json['message'] as String,
      );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_id'] = userId;
    data['message'] = message;
    return data;
  }
}

class Card extends Data {
  Card({
    required this.userId,
    required this.number,
  });

  final String userId;
  final String number;

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        userId: json['user_id'] as String,
        number: json['number'].toString(),
      );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_id'] = userId;
    data['number'] = number;
    return data;
  }
}

class TableState extends Data {
  TableState({
    required this.result,
    required this.isOpen,
  });

  final double result;
  final bool isOpen;

  factory TableState.fromJson(Map<String, dynamic> json) => TableState(
        result: json['result'] as double,
        isOpen: json['is_open'] as bool,
      );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    return data;
  }
}
