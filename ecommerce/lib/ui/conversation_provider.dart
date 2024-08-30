import 'package:flutter/foundation.dart';
import 'package:ecommerce/models/conversations.dart';
import 'package:ecommerce/models/messages.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ConversationProvider with ChangeNotifier {
  List<Conversation> _conversations = [];
  IO.Socket? _socket;

  List<Conversation> get conversations => _conversations;

  void initSocket(String userId) {
    _socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket!.connect();

    _socket!.onConnect((_) {
      print('Connected to server from ConversationProvider');
    });

    _socket!.on('new_message', (data) {
      updateConversation(data);
    });

    _socket!.onDisconnect((_) {
      print('Disconnected from server');
    });
  }

  void updateConversation(dynamic messageData) {
    int index = _conversations.indexWhere(
        (conv) => conv.conversationId == messageData['conversationId']);
    if (index != -1) {
      _conversations[index].messages ??= [];
      _conversations[index].messages!.add(Message.fromJson(messageData));
      _conversations.insert(0, _conversations.removeAt(index));
      notifyListeners();
    }
  }

  void setConversations(List<Conversation> conversations) {
    _conversations = conversations;
    notifyListeners();
  }

  void dispose() {
    _socket?.disconnect();
  }
}
