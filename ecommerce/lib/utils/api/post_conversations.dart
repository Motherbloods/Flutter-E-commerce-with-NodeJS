// import 'package:ecommerce/ui/chat/index.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter/material.dart';

// Future<void> createConversations(
//     BuildContext context, String sellerId, String userId) async {
//   if (userId.isEmpty) {
//     print('Error: userId is null or empty');
//     return;
//   }

//   final url = dotenv.env['URL'] ?? '';
//   final Map<String, String> payload = {
//     'senderId': sellerId,
//     'receiverId': userId
//   };

//   final response = await http.post(
//     Uri.parse('$url/api/conversation'),
//     headers: {
//       'Content-Type': 'application/json',
//     },
//     body: json.encode(payload),
//   );

//   if (response.statusCode == 200) {
//     var jsonData = json.decode(response.body);
//     String conversationId = jsonData['conversationId'];
//     // Navigate to ChatScreen with the conversationId
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ChatScreen(conversationId: conversationId),
//       ),
//     );
//   } else {
//     // Failed to create conversation
//     throw Exception('Failed to create conversation');
//   }
// }
