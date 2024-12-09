import 'package:cashier_bot_for_restaurant/controller/chat_controller.dart';
import 'package:cashier_bot_for_restaurant/widgets/message_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../helper/global.dart';

class ChatBotFeature extends StatefulWidget {
  const ChatBotFeature({super.key});

  @override
  State<ChatBotFeature> createState() => _ChatBotFeatureState();
}

class _ChatBotFeatureState extends State<ChatBotFeature> {
  final textMessage = ChatController();
  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: Icon(Icons.restaurant_menu, color: Colors.orange),
            ),
            SizedBox(width: 10),
            Text(
              ' Restaurant ChatBot',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            if (isButtonPressed)
              Expanded(
                child: TextFormField(
                  controller: textMessage.textC,
                  textAlign: TextAlign.start,
                  onTapOutside: (e) => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    filled: true,
                    isDense: true,
                    hintText: 'Send a message...',
                    hintStyle: const TextStyle(fontSize: 14),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                  ),
                ),
              ),
            const SizedBox(width: 8),
            if (isButtonPressed)
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.orange,
                child: IconButton(
                  onPressed: () {
                    textMessage.askQuestion();
                  },
                  icon: const Icon(
                    Icons.rocket_launch_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
          ],
        ),
      ),
      body: Obx(
        () => ListView(
          physics: const BouncingScrollPhysics(),
          controller: textMessage.scrollC,
          padding: EdgeInsets.only(
            top: size.height * .02,
            bottom: size.height * .1,
          ),
          children:
              textMessage.list.map((e) => MessageCard(message: e)).toList(),
        ),
      ),
      bottomSheet: !isButtonPressed
          ? Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isButtonPressed = true;
                  });
                },
                child: Text(
                  "Let's Start",
                  style:  TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
