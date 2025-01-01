import 'package:exploreo/Components/color.dart';
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
    _sendMessageToAI(
        "Welcome to Exploreo AI Travel Assistant! How can I assist you with your travel-related questions today?");
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
        _messages.add(
            {"sender": "ai", "message": response?.output ?? "No response"});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isTravelRelated(String message) {
    final travelKeywords = [
      "travel",
      "trip",
      "destination",
      "tour",
      "vacation",
      "flight"
    ];
    return travelKeywords
        .any((keyword) => message.toLowerCase().contains(keyword));
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
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isUser)
                const CircleAvatar(
                  backgroundImage: AssetImage("assets/exploreo_icon_bg.png"),
                ),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: isUser ? secondaryColor : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                child: Text(
                  message['message'] ?? '',
                  style: TextStyle(
                    color: isUser ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              if (isUser)
                const CircleAvatar(
                  backgroundImage: AssetImage("assets/user_pro.png"),
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
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text(
          "AI Travel Assistant",
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'PoppinsSemiBold',
            color: Colors.black,
          ),
        ),
        backgroundColor: primaryColor,
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
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'PoppinsRegular',
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: secondaryColor,
                          width: 2.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'PoppinsRegular',
                      color: Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  icon: _isLoading
                      ? const SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(
                            color: secondaryColor,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.send, color: secondaryColor,),
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
