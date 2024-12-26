import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

const apiKey = 'AIzaSyCXT5LAOq9B84uAXChEv1rF86Wf96c53s4';

class AiTipsScreen extends StatefulWidget {
  const AiTipsScreen({super.key});

  @override
  State<AiTipsScreen> createState() => _AiTipsScreenState();
}

class _AiTipsScreenState extends State<AiTipsScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Gemini.init(apiKey: apiKey, enableDebugging: true);
    _sendWelcomeMessage();
  }

  void _sendWelcomeMessage() {
    _sendMessageToAI("Welcome to Exploreo AI Travel Assistant! How can I assist you with your travel-related questions today?");
  }

  void _sendMessage() async {
    String message = _controller.text.trim();

    if (message.isEmpty) return;

    if (!_isTravelRelated(message)) {
      _sendMessageToAI("Please ask only travel-related questions.");
      return;
    }

    setState(() {
      _isLoading = true;
      _messages.add({"sender": "user", "message": message});
      _controller.clear();
    });

    try {
      final response = await Gemini.instance.prompt(parts: [
        Part.text(message),
      ]);

      setState(() {
        _messages.add({"sender": "ai", "message": response?.output ?? "No response"});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isTravelRelated(String message) {
    final travelKeywords = ["travel", "trip", "destination", "tour", "vacation", "flight"];
    return travelKeywords.any((keyword) => message.toLowerCase().contains(keyword));
  }

  void _sendMessageToAI(String message) {
    setState(() {
      _messages.add({"sender": "ai", "message": message});
    });
  }

  Widget _buildMessageList() {
    return ListView.builder(
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        bool isUser = message['sender'] == 'user';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isUser)
                CircleAvatar(
                  backgroundImage: AssetImage("assets/exploreo_icon_bg.png"),
                ),
              SizedBox(width: 10),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: isUser ? Colors.blue : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                child: Text(
                  message['message'] ?? '',
                  style: TextStyle(
                    color: isUser ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(width: 10),
              if (isUser)
                CircleAvatar(
                  backgroundImage: AssetImage("assets/pro.png"),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Travel Assistant"),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask a travel-related question...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                  ),
                ),
                IconButton(
                  icon: _isLoading
                      ? CircularProgressIndicator()
                      : Icon(Icons.send),
                  onPressed: _isLoading ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
