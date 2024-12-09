import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cashier_bot_for_restaurant/helper/global.dart';
import 'package:cashier_bot_for_restaurant/model/message.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  final Message message;

  const MessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    const r = Radius.circular(15);

    return message.msgType == MessageType.bot

        // Bot message
        ? Row(children: [
            const SizedBox(width: 6),
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Image.asset(
                'assets/logo.png',
                height: 50,
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: size.width * .6),
              margin: EdgeInsets.only(
                  bottom: size.height * .04, left: size.width * .02),
              padding: EdgeInsets.symmetric(
                  vertical: size.height * .015, horizontal: size.width * .02),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 225, 224, 224),
                  borderRadius: BorderRadius.only(
                      topLeft: r, topRight: r, bottomRight: r)),
              child: message.msg.isEmpty
                  ? AnimatedTextKit(animatedTexts: [
                      TypewriterAnimatedText(
                        ' Please wait...',
                        speed: const Duration(milliseconds: 100),
                      ),
                    ], repeatForever: true)
                  : Text(
                      message.msg,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
            ),
          ])
        // User message
        : Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(
                constraints: BoxConstraints(maxWidth: size.width * .6),
                margin: EdgeInsets.only(
                    bottom: size.height * .02, right: size.width * .02),
                padding: EdgeInsets.symmetric(
                    vertical: size.height * .01, horizontal: size.width * .02),
                decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                        topLeft: r, topRight: r, bottomLeft: r)),
                child: Text(
                  message.msg,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                )),
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Image.asset(
                'assets/user.jpg',
                height: 20,
              ),
            ),
            const SizedBox(width: 6),
          ]);
  }
}
