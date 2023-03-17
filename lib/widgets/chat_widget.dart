import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:explore/constants/constants.dart';
import 'package:explore/services/assets_manger.dart';
import 'package:explore/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key, required this.msg, required this.chatIndex});

  final String msg;
  final int chatIndex;
   
  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {

  bool Click = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: widget.chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  widget.chatIndex == 0
                      ? AssetsManager.userImage
                      : AssetsManager.botImage,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: widget.chatIndex == 0
                      ? TextWidget(label: widget.msg)
                      : DefaultTextStyle(
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                          child: AnimatedTextKit(
                            isRepeatingAnimation: false,
                            repeatForever: false,
                            displayFullTextOnTap: true,
                            totalRepeatCount: 1,
                            animatedTexts: [
                              TyperAnimatedText(
                                widget.msg.trim(),
                              ),
                            ],
                          ),
                        ),
                ),
                widget.chatIndex == 0
                    ?  SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children:  [
                          ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(112, 94, 111, 114))), onPressed: (){
                            setState(() {
                              Click =!Click;
                            });
                          }, child: Icon((Click==false)? Icons.thumb_up:Icons.thumb_up_alt_outlined ))
                          // Icon(Icons.thumb_up_alt_outlined,
                          //     color: Colors.white),
                          // SizedBox(
                          //   width: 5,
                          // ),
                          // Icon(
                          //   Icons.thumb_down_alt_outlined,
                          //   color: Colors.white,
                          // )
                        ],
                      ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
