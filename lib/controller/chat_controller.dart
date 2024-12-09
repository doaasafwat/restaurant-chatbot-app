import 'package:cashier_bot_for_restaurant/services/chat_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../model/message.dart';

class ChatController extends GetxController {
  final textC = TextEditingController();
  final scrollC = ScrollController();
  final list = <Message>[
    Message(
        msg:
            "Hello! Welcome to our restaurant. l'm here to assist you with your order,answer menu inquiries, and help you make reservations. Is there anything l can help you with today?",
        msgType: MessageType.bot)
  ].obs;

  Future<void> askQuestion() async {
    if (textC.text.trim().isNotEmpty) {
      list.add(Message(msg: textC.text, msgType: MessageType.user));
      list.add(Message(msg: '', msgType: MessageType.bot));
      final userMessage = textC.text;
      textC.clear();
      _scrollDown();

      final botResponse = await ChatService.askQuestion(userMessage);
      list.removeLast();
      list.add(Message(msg: botResponse, msgType: MessageType.bot));
      _scrollDown();
    }
  }

  void _scrollDown() {
    scrollC.animateTo(scrollC.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }
}
