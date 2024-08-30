// conversation.dart
import 'package:ecommerce/models/messages.dart';
import 'package:ecommerce/models/seller.dart';
import 'package:ecommerce/models/user.dart';

class Conversation {
  final dynamic? user;
  final String? conversationId;
  List<Message>? messages;

  Conversation({
    this.user,
    required this.conversationId,
    this.messages,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>;
    final isSeller = userJson['isSeller'] as bool? ?? false;

    return Conversation(
      // user: User.fromJson(json['user']['']),
      user: isSeller ? Seller.fromJson(userJson) : User.fromJson(userJson),
      conversationId: json['conversationId'] as String?,
      messages: (json['messages'] as List<dynamic>?)
          ?.map((messageJson) =>
              Message.fromJson(messageJson as Map<String, dynamic>))
          .toList(),
    );
  }
}
