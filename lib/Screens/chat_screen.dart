import 'package:exploreo/Components/color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String receiverEmail;
  final String receiverName;

  const ChatScreen(
      {super.key, required this.receiverEmail, required this.receiverName});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    _loadMessagesFromLocal();
    _loadMessagesFromFirestore();
  }

  // Fetch the current user's email from SharedPreferences
  Future<void> _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('email');
    });
  }

  // Load messages from local storage (SharedPreferences)
  Future<void> _loadMessagesFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? messages = prefs.getStringList('messages');
    if (messages != null) {
      setState(() {
        _messages.clear();
        _messages.addAll(messages.map((message) {
          return {
            'sender': _userEmail,
            'message': message,
          };
        }).toList());
      });
    }
  }

  // Fetch messages from Firestore
  Future<void> _loadMessagesFromFirestore() async {
    if (_userEmail == null) return;

    final chatDoc = FirebaseFirestore.instance
        .collection('chats')
        .doc(_userEmail)
        .collection(widget.receiverEmail);

    chatDoc.snapshots().listen((snapshot) {
      final messages = snapshot.docs.map((doc) {
        return {
          'sender': doc['sender'],
          'message': doc['message'],
        };
      }).toList();

      setState(() {
        _messages.clear();
        _messages.addAll(messages);
      });
    });
  }

  // Send a message to Firestore and save it to local storage
  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty && _userEmail != null) {
      final message = _controller.text;
      final receiverEmail = widget.receiverEmail;
      final receiverName = widget.receiverName;

      // Save the message to Firestore
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(_userEmail)
          .collection(receiverEmail)
          .add({
        'sender': _userEmail,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(receiverEmail)
          .collection(_userEmail!)
          .add({
        'sender': _userEmail,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Save the message to local storage (SharedPreferences)
      final prefs = await SharedPreferences.getInstance();
      List<String>? storedMessages = prefs.getStringList('messages');
      storedMessages ??= [];
      storedMessages.add(message);
      await prefs.setStringList('messages', storedMessages);

      // Clear the text field after sending the message
      setState(() {
        _controller.clear();
      });
    }
  }

  // Method to clear all chat data (Firestore and SharedPreferences)
  Future<void> _clearAllChat() async {
    final prefs = await SharedPreferences.getInstance();
    // Clear local messages
    await prefs.remove('messages');

    if (_userEmail != null) {
      // Clear messages from Firestore
      final chatCollection = FirebaseFirestore.instance
          .collection('chats')
          .doc(_userEmail)
          .collection(widget.receiverEmail);

      final receiverChatCollection = FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.receiverEmail)
          .collection(_userEmail!);

      // Delete all documents in both sender and receiver collections
      final batch = FirebaseFirestore.instance.batch();

      final senderSnapshot = await chatCollection.get();
      for (var doc in senderSnapshot.docs) {
        batch.delete(doc.reference);
      }

      final receiverSnapshot = await receiverChatCollection.get();
      for (var doc in receiverSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    }

    // Update the UI after clearing chat
    setState(() {
      _messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ), // Custom appBar color
        title: Text(
          widget.receiverName,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'PoppinsMedium',
            color: Colors.white,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'clearChat') {
                _clearAllChat();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'clearChat',
                  child: Text('Clear Chat'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isSender = message['sender'] == _userEmail;

                return ListTile(
                  title: Align(
                    alignment:
                        isSender ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: isSender ? secondaryColor : Colors.grey[300],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        message['message'],
                        style: TextStyle(
                          color: isSender ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontFamily: 'PoppinsRegular',
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
