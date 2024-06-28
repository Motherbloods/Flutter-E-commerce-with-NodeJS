class Message {
  final String? messageId;
  final String? message;
  final String? receiverId;
  final String? id;
  final bool? read;
  final String? createdAt;
  final String? conversationId;
  final String? isReplyMessageId;
  final bool? isReply;
  final bool? isForward;
  final String? senderId;
  final Map<String, dynamic>? productInfo;
  final Message? lastMessage;

  Message({
    this.messageId,
    this.message,
    this.receiverId,
    this.id,
    this.read,
    this.createdAt,
    this.conversationId,
    this.isReply,
    this.isForward,
    this.senderId,
    this.isReplyMessageId,
    this.productInfo,
    this.lastMessage,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['messageId'] ?? '',
      message: json['message']?.toString(),
      receiverId: json['receiverId'] ?? '',
      isReplyMessageId: json['isReplyMessageId'] as String?,
      id: json['_id']?.toString() ?? json['id']?.toString(),
      read: json['read'] ?? '',
      createdAt: json['createdAt'] ?? '',
      conversationId: json['conversationId']?.toString(),
      isReply: json['isReply'] ?? '',
      isForward: json['isForward'] ?? '',
      senderId: json['senderId']?.toString(),
      productInfo: json['productInfo'],
      lastMessage:
          json['messages'] != null && (json['messages'] as List).isNotEmpty
              ? Message.fromJson(json['messages'].last)
              : null,
    );
  }
}
