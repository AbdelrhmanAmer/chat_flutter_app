import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  void _sendMessage()async{
    final userMessage = _messageController.text;
    if(userMessage.trim().isEmpty){
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();

    final User currentUser = FirebaseAuth.instance.currentUser!;
    final  userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
     await FirebaseFirestore.instance
        .collection('chat')
        .add({
      'text': userMessage,
      'createAt': Timestamp.now(),
      'userId': currentUser.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });

  }
  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
           Expanded(
              child: TextField(
                controller: _messageController,
                autocorrect: true,
                textCapitalization: TextCapitalization.sentences,
                enableSuggestions: true,
                decoration: const InputDecoration(
                  hintText: 'Message',
                ),
              )
          ),
          IconButton(
              onPressed: _sendMessage,
              icon: Icon(
                Icons.send,
                color: Theme.of(context).colorScheme.primary,
              )
          )
        ],
      ),
    );
  }
}
