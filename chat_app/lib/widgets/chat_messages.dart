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
            .orderBy('createAt', descending: false)
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
              itemCount: loadedMessages.length,
              itemBuilder: (ctx, index){
                return Text(
                    loadedMessages[index].data()['text']
                );
              });
        })
    );
  }
}
