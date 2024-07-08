class Message {
  final String title;
  final String body;

  Message({required this.title, required this.body});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      title: json['title'],
      body: json['body'],
    );
  }
}
