import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthmobi/api/api_provider.dart';
import 'package:healthmobi/reusable/constant.dart';
import '../widget/ChatScreen Widgets/bubble_special_one.dart';
import '../widget/ChatScreen Widgets/message_bar.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final List<Map<String, dynamic>> messages = [
    {"text": "Hi! I'm HealthMobi Bot. How can I help you today?", "isBot": true},
    {"text": "I can help you with your health queries.", "isBot": true},
    {"text": "Ask me anything!", "isBot": true},
  ];

  final ScrollController _scrollController = ScrollController(); // Scroll Controller

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "HealthMobi Bot",
          style: GoogleFonts.manrope(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Attach scroll controller
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return BubbleSpecialOne(
                  text: message["text"],
                  isSender: !message["isBot"],
                  color: secondaryColor,
                );
              },
            ),
          ),
          MessageBar(
            onSend: (String message) async {
              setState(() {
                messages.add({"text": message, "isBot": false});
                messages.add({"text": "Loading...", "isBot": true});
              });
              _scrollToBottom(); // Scroll after user message

              String? response =
                  await ref.read(apiProvider).aiBot(message: message);

              setState(() {
                messages.removeWhere((msg) => msg["text"] == "Loading...");
                messages.add({
                  "text": response ?? "Sorry, I couldn't understand that. Please try again.",
                  "isBot": true
                });
                _scrollToBottom(); // Scroll after bot response
              });
            },
            sendButtonColor: primaryColor,
          ),
        ],
      ),
    );
  }
}
