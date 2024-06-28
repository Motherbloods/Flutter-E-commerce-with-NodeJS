import 'package:ecommerce/models/messages.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/utils/singleton/socket_singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  final String? senderId;
  final String? receiverId;
  final String? conversationId;
  final String? storeName;
  final Product? product;

  ChatScreen(
      {this.senderId,
      this.receiverId,
      this.conversationId,
      this.storeName,
      this.product});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final SocketManager _socketManager = SocketManager();
  late AutoScrollController _scrollController;
  List<Message> _messages = [];
  late IO.Socket socket;
  String? _conversationId = '';
  String userId = '';
  bool _showProductCard = true;
  bool _isMounted = false;
  Set<String> processedMessageIds = {};

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _scrollController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical,
    );
    loadUser();
    createConversations();
    // loadMessages();
  }

  @override
  void dispose() {
    _isMounted = false;
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('userId');
    setState(() {
      userId = id!;
    });
    _socketManager.connect(userId);
    _socketManager.onGetMessage((data) {
      print(data);
      if (mounted) {
        setState(() {
          _showProductCard = false;
          _messages.add(Message.fromJson(data));
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    });
  }

  Future<void> createConversations() async {
    final url = dotenv.env['URL'] ?? '';
    final Map<String, String> payload = {
      'senderId': widget.senderId!,
      'receiverId': widget.receiverId!
    };

    final response = await http.post(
      Uri.parse('$url/api/conversation'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(payload),
    );
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      String conversationId = jsonData['conversationId'];
      // Navigate to ChatScreen with the conversationId
      setState(() {
        _conversationId = conversationId;
      });

      await loadMessages();
    } else {
      // Failed to create conversation
      throw Exception('Failed to create conversation');
    }
  }

  Future<void> loadMessages() async {
    var url = dotenv.env['URL'] ?? '';
    final response =
        await http.get(Uri.parse('$url/api/messages/$_conversationId'));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        _messages = (jsonData['data'] as List)
            .map((messageJson) => Message.fromJson(messageJson))
            .toList();
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } else {
      print('Failed to load messages');
    }
  }

  Future<void> sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final Map<String, dynamic> message = {
        'conversationId': _conversationId,
        'senderId': userId,
        'message': _messageController.text,
        'createdAt': DateTime.now().toIso8601String(),
      };

      if (_showProductCard && widget.product != null) {
        message['productInfo'] = {
          'name': widget.product!.name,
          'price': widget.product!.price.toString(),
          'imageUrl': widget.product!.imageUrl,
        };
      }
      var url = dotenv.env['URL'] ?? '';
      final response = await http.post(
        Uri.parse('$url/api/messages'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(message),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        _socketManager.sendMessage({
          'senderId': userId,
          'message': _messageController.text,
          'conversationId': _conversationId,
        });
        _socketManager.sendConversation({
          'senderId': userId,
          'conversationId': _conversationId,
          'message': _messageController.text,
        });

        _messageController.clear();
        // _scrollToBottom();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message')),
        );
      }
    }
  }

  void _scrollToBottom() {
    if (!_isMounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (_scrollController.hasClients && _isMounted) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.storeName ?? 'Chat'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top,
            child: Column(
              children: [
                Expanded(
                  child: _messages.isEmpty
                      ? Center(
                          child: Text(
                            'Mulai percakapan dengan Penjual',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            return AutoScrollTag(
                              key: ValueKey(index),
                              controller: _scrollController,
                              index: index,
                              child: ChatBubble(
                                message: _messages[index].message!,
                                isSender: _messages[index].senderId == userId,
                                productInfo: _messages[index].productInfo,
                              ),
                            );
                          },
                        ),
                ),
                if (widget.product != null && _showProductCard)
                  ProductCard(
                    product: widget.product!,
                    onClose: () {
                      setState(() {
                        _showProductCard = false;
                      });
                    },
                  ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Ketik pesan...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding: EdgeInsets.all(12.0),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        FloatingActionButton(
                          onPressed: sendMessage,
                          child: Icon(Icons.send),
                          mini: true,
                          backgroundColor: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class ChatBubble extends StatelessWidget {
//   final String message;
//   final bool isSender;

//   ChatBubble({required this.message, required this.isSender});

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final maxWidth = screenWidth * 0.5; // 50% dari lebar layar
//     return Align(
//       alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         constraints: BoxConstraints(maxWidth: maxWidth),
//         padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//         decoration: BoxDecoration(
//           color: isSender ? Colors.blue[400] : Colors.grey[300],
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           message,
//           style: TextStyle(
//             color: isSender ? Colors.white : Colors.black87,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }
// }

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;
  final Map<String, dynamic>? productInfo;

  ChatBubble({required this.message, required this.isSender, this.productInfo});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth =
        screenWidth * 0.7; // Increase max width to 70% of screen width
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue[400] : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (productInfo != null) ...[
              Image.network(
                productInfo!['imageUrl'],
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 8),
              Text(
                'Product: ${productInfo!['name']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Price: \$${productInfo!['price']}'),
              Text('Stock: ${productInfo!['stock']}'),
              SizedBox(height: 8),
            ],
            Text(
              message,
              style: TextStyle(
                color: isSender ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onClose;

  ProductCard({required this.product, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Image.network(
              product.imageUrl!,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                product.name!,
                style: TextStyle(fontSize: 16),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: onClose,
            ),
          ],
        ),
      ),
    );
  }
}
