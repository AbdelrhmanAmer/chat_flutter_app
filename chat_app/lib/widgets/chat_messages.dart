import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createAt', descending: true)
            .snapshots(),
        builder: ((ctx, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else if(!snapshot.hasData || snapshot.data == null){
            return const Center(
              child: Text('No Message Found..!'),
            );
          }else if(snapshot.hasError){
            return const Center(
              child: Text('Something went wrong..!'),
            );
          }

          final List<QueryDocumentSnapshot<Map<String, dynamic>>> loadedMessages = snapshot.data!.docs;

          return ListView.builder(
              padding: const EdgeInsets.only(
                  bottom: 40,
                  left: 13,
                  right: 13
              ),
              reverse: true,
              itemCount: loadedMessages.length,
              itemBuilder: (ctx, index){
                final User authUser = FirebaseAuth.instance.currentUser!;

                final chatMessage = loadedMessages[index].data();
                final  nextMessage = index+1 < loadedMessages.length
                    ? loadedMessages[index+1].data()
                    : null;
                final currentMessageUserId = chatMessage['userId'];
                final nextMessageUserId = nextMessage != null
                    ? nextMessage['userId']
                    : null;
                final nextUserIsSame = nextMessageUserId == currentMessageUserId;

                return nextUserIsSame
                    ? MessageBubble.next(
                    message: chatMessage['text'],
                    isMe: authUser.uid == currentMessageUserId)

                    : MessageBubble.first(
                    userImage: chatMessage['userImage'],
                    username: chatMessage['username'],
                    message: chatMessage['text'],
                    isMe: authUser.uid == currentMessageUserId);
              });
        })
    );
  }
}
