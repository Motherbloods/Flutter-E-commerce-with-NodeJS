import 'package:ecommerce/models/conversations.dart';
import 'package:ecommerce/ui/chat/chat_screen.dart';
import 'package:ecommerce/ui/conversation_provider.dart';
import 'package:ecommerce/utils/singleton/socket_singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ListConversationsPage extends StatefulWidget {
  @override
  _ListConversationsPageState createState() => _ListConversationsPageState();
}

class _ListConversationsPageState extends State<ListConversationsPage> {
  final SocketManager _socketManager = SocketManager();

  List<Conversation> conversations = [];
  bool isLoading = true;
  String? userId;
  IO.Socket? socket;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    if (userId != null) {
      _socketManager.connect(userId!);
      _socketManager.onGetConversation((data) {
        print(data);
        if (mounted) {
          updateOrAddConversation(Conversation.fromJson(data));
        }
      });
      _fetchConversations();
    }
  }

  void updateOrAddConversation(Conversation newConversation) {
    setState(() {
      int index = conversations.indexWhere(
          (conv) => conv.conversationId == newConversation.conversationId);
      if (index != -1) {
        // Update existing conversation
        conversations[index] = newConversation;
      } else {
        // Add new conversation
        conversations.add(newConversation);
      }
      // Sort conversations
      conversations.sort((a, b) {
        var aLastMessage =
            a.messages?.isNotEmpty == true ? a.messages!.last : null;
        var bLastMessage =
            b.messages?.isNotEmpty == true ? b.messages!.last : null;
        if (aLastMessage == null && bLastMessage == null) return 0;
        if (aLastMessage == null) return 1;
        if (bLastMessage == null) return -1;
        return bLastMessage.createdAt!.compareTo(aLastMessage.createdAt!);
      });
    });
  }

  Future<void> _fetchConversations() async {
    var url = dotenv.env['URL'] ?? '';
    try {
      var response = await http.get(Uri.parse('$url/api/conversation/$userId'));
      if (response.statusCode == 200) {
        final List<dynamic> conversationsJson = json.decode(response.body);
        setState(() {
          conversations.clear(); // Clear existing conversations
          for (var json in conversationsJson) {
            // updateOrAddConversation(Conversation.fromJson(json));
            if (json['messages'] != null && json['messages'].isNotEmpty) {
              updateOrAddConversation(Conversation.fromJson(json));
            }
          }
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        // Handle error
        print('Failed to load conversations');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Exception occurred: $e');
    }
  }

  String formatDateTime(String? dateTimeString) {
    if (dateTimeString == null) return 'Hari ini';

    final dateTime =
        DateTime.parse(dateTimeString).toLocal(); // Konversi ke GMT+7
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      // Hari ini
      return DateFormat('HH:mm').format(dateTime);
    } else if (difference.inDays == 1) {
      // Kemarin
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      // Dalam minggu ini
      return DateFormat('EEEE').format(dateTime); // Nama hari
    } else {
      // Lebih dari seminggu yang lalu
      return DateFormat('dd/MM/yy').format(dateTime);
    }
  }

  @override
  void dispose() {
    if (socket != null) {
      socket!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConversationProvider>(
        builder: (context, conversationProvider, child) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Chat'),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conversation = conversations[index];
                  if (conversation.user == null ||
                      conversation.conversationId == null) {
                    return ListTile(title: Text('Invalid conversation data'));
                  }
                  final lastMessage = conversation.messages != null &&
                          conversation.messages!.isNotEmpty
                      ? conversation.messages!.last
                      : null;
                  return ListTile(
                    title: Text(conversation.user?.fullName ??
                        conversation.user?.namaToko ??
                        'Unknown'),
                    subtitle: Text(
                      lastMessage != null
                          ? (lastMessage.message ?? 'No message content')
                          : 'No messages',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: lastMessage != null
                        ? Text(
                            formatDateTime(lastMessage.createdAt),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          )
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            senderId: userId,
                            receiverId: conversation.user?.id,
                            conversationId: conversation.conversationId,
                            storeName: conversation.user?.fullName ??
                                conversation.user?.namaToko ??
                                'Unknown',
                          ),
                        ),
                      ).then((_) =>
                          _fetchConversations()); // Refresh after returning from ChatScreen
                    },
                  );
                },
              ),
      );
    });
  }
}
