import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SocketManager {
  static final SocketManager _instance = SocketManager._internal();
  late IO.Socket socket;

  factory SocketManager() {
    return _instance;
  }

  SocketManager._internal();

  void connect(String userId) {
    var url = dotenv.env['URL_IO'] ?? '';
    socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.emit('addUser', userId);
    socket.onConnect((_) {
      print('Socket connected at ${DateTime.now()}');
    });
  }

  void joinConversation(String conversationId) {
    socket.emit('join_conversation', conversationId);
  }

  void onGetMessage(Function(dynamic) handler) {
    socket.on('getMessage', handler);
  }

  void onGetConversation(Function(dynamic) handler) {
    socket.on('getConversation', handler);
  }

  void sendMessage(Map<String, dynamic> messageData) {
    socket.emit('sendMessage', messageData);
  }

  void sendConversation(Map<String, dynamic> messageData) {
    socket.emit('sendConversation', messageData);
  }

  void dispose() {
    socket.dispose();
  }
}
