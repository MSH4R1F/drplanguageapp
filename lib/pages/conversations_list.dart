import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drplanguageapp/classes/chat_list_entry.dart';
import 'package:drplanguageapp/classes/new_chat_form.dart';
import 'package:drplanguageapp/pages/conversation.dart';
import 'package:flutter/material.dart';

class ConversationsList extends StatefulWidget {
  final String userID;
  const ConversationsList({super.key, required this.userID});

  @override
  State<ConversationsList> createState() => _ConversationsListState();
}

class _ConversationsListState extends State<ConversationsList> {
  List<ChatEntry> chats = [];
  @override
  void initState() {
    super.initState();
    loadChats();
  }

  DocumentReference<Map<String, dynamic>> addToDatabase(
      String userID, ChatEntry chatEntry) {
    var chatRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('chats')
        .doc();
    chatRef
        .set({
          'language': chatEntry.selection.language,
          'topic': chatEntry.selection.topic,
        })
        .then((value) => print("Chat added to database"))
        .catchError((error) => print("Failed to add chat: $error"));
    return chatRef;
  }

  void addToChats(Selection s) {
    var toAdd = ChatEntry(
        Image.network(
            "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Flag_of_the_Arabic_language.svg/1024px-Flag_of_the_Arabic_language.svg.png"),
        "Talking about ${s.topic} in ${s.language}",
        "${s.topic} in ${s.language}",
        s);

    var chatRef = addToDatabase('Bmoy5vB0vYQQekDx7V87IqIZz043', toAdd);
    toAdd.setReference(chatRef);
    setState(() {
      chats.insert(0, toAdd);
    });
  }

  void openConversation(ChatEntry chatEntry, String chatLabel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Conversation(
                userID: widget.userID,
                language: chatEntry.selection.language,
                topic: chatEntry.selection.topic,
                chatLabel: chatLabel,
                chatRef: chatEntry.getReference())));
  }

  void loadChats() {
    FirebaseFirestore.instance
        .collection('users')
        .doc('Bmoy5vB0vYQQekDx7V87IqIZz043')
        .collection('chats')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        chats = snapshot.docs
            .map((doc) => ChatEntry.withReference(
                Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Flag_of_the_Arabic_language.svg/1024px-Flag_of_the_Arabic_language.svg.png"),
                "Talking about ${doc.get('topic')} in ${doc.get('language')}",
                "${doc.get('topic')} in ${doc.get('language')}",
                Selection(
                    topic: doc.get('topic'), language: doc.get('language')),
                doc.reference))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversations"),
      ),
      body: Align(
          alignment: Alignment.topCenter,
          // child: Placeholder(),
          child: ListView.builder(
              reverse: false,
              itemCount: chats.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LanguageTopicForm()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result.toString())),
                      );
                      addToChats(result);
                    },
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 140),
                      color: Colors.amberAccent,
                      child: const Icon(Icons.add),
                    ),
                  );
                }
                return GestureDetector(
                    onTap: () => openConversation(
                        chats[index], chats[index].lastmessage),
                    onLongPress: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Removed ${chats[index].title}")),
                      );
                      setState(() {
                        chats.removeAt(index);
                      });
                    },
                    child: ChatListEntry(chatEntry: chats[index]));
              })),
    );
  }
}
