class Message
{
  late DateTime dateTime;
  late String message;
  late String senderId;

  Message({
    required this.dateTime,
    required this.senderId,
    required this.message,
});

  Message.fromJson(Map<String, dynamic> message)
  {
    this.message = message['message'];
    this.dateTime = message['DateTime'].toDate();
    this.senderId = message['senderId'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'DateTime' : this.dateTime,
      'senderId' : this.senderId,
      'message' : this.message,
    };
  }
}