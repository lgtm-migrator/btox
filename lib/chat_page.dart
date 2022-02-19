import 'package:flutter/material.dart';

import 'db/database.dart';
import 'strings.dart';

class _Message {
  final String content;
  final DateTime timestamp;

  _Message({
    required this.content,
    required this.timestamp,
  });
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.contact}) : super(key: key);

  final Stream<Contact> contact;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messages = <_Message>[];
  final _messageInputFocus = FocusNode();
  final _messageInputController = TextEditingController();

  void _onSendMessage() {
    setState(() {
      _messages.add(_Message(
        content: _messageInputController.text,
        timestamp: DateTime.now().toUtc(),
      ));
    });
    _messageInputController.clear();
    _messageInputFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Contact>(
      builder: (context, snapshot) => Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data?.name ?? Strings.defaultContactName),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final reversedIndex = _messages.length - index - 1;
                  final message = _messages[reversedIndex];
                  return ListTile(
                    title: Text(message.content),
                    subtitle: Text(message.timestamp.toLocal().toString()),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: Strings.message.toLowerCase(),
                  suffixIcon: IconButton(
                    onPressed: () => _onSendMessage(),
                    icon: const Icon(Icons.send),
                  ),
                ),
                onEditingComplete: () => _onSendMessage(),
                controller: _messageInputController,
                focusNode: _messageInputFocus,
                textInputAction: TextInputAction.send,
                autofocus: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
