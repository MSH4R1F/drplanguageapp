
import 'package:drplanguageapp/classes/chat_list_entry.dart';
import 'package:drplanguageapp/classes/new_chat_form.dart';
import 'package:drplanguageapp/pages/conversation.dart';
import 'package:flutter/material.dart';

class ConversationsList extends StatefulWidget {
  final String userID;
  ConversationsList({super.key, required this.userID});

  @override
  State<ConversationsList> createState() => _ConversationsListState();
}

class _ConversationsListState extends State<ConversationsList> {
  
  final List<ChatEntry> chats = [];

  void addToChats(Selection s) {
    var toAdd = 
    ChatEntry(
        Image.network("https://m.media-amazon.com/images/I/41pPE67EwOL._AC_UF894,1000_QL80_.jpg"),
        "Talking about ${s.topic} in ${s.language}",
        "TEMP SUBTITLE IN CONVERSATIONS LIST",
        s
      );

      setState(() {
        chats.insert(0,toAdd);
      });
  }
  
  void openConversation(ChatEntry chatEntry, String chatLabel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Conversation(userID: widget.userID, language: chatEntry.selection.language, topic: chatEntry.selection.topic, chatLabel: chatLabel)
      )
    );
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
            return GestureDetector(
              onTap: () => openConversation(
                chats[index],
                chats[index].lastmessage
              ),
              onLongPress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Removed ${chats[index].title}")),
                );   
                setState(() {
                  chats.removeAt(index);
                });
              },
              child: ChatListEntry(chatEntry: chats[index])
            );
          }
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LanguageTopicForm()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.toString())),
          );
          addToChats(result);

        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}