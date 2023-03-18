import 'dart:developer';
import 'package:explore/providers/chats_provider.dart';
import 'package:explore/providers/models_provider.dart';
import 'package:explore/services/assets_manger.dart';
import 'package:explore/widgets/chat_widget.dart';
import 'package:explore/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _istyping = false;
  late TextEditingController textEditingController;
  late ScrollController _listSrollController;
  late FocusNode focusNode;
  @override
  void initState() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    _listSrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    _listSrollController.dispose();
    super.dispose();
  }
// List<ChatModel> chatList = [];

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 20, 34, 36),
        title: const Text("Explore with ChatGPT"),
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogo,),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color:Color.fromARGB(112, 94, 111, 114)),
        child: SafeArea(
            child: Column(
          children: [
            ChatWidget(msg: "welcome ", chatIndex: 1),
            Flexible(
              child: ListView.builder(
              
                controller: _listSrollController,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatProvider.getChatList[index].msg, //[index].msg,
                    chatIndex: chatProvider.getChatList[index].chatIndex,
                  );
                },
                itemCount: chatProvider.getChatList.length,
              ),
            ),
            if (_istyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            const SizedBox(
              height: 15,
            ),
            Material(
              color: Color.fromARGB(255, 20, 34, 36),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
      
                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          await sendMessageFCT(
                              modelsProvider: modelsProvider,
                              chatProvider: chatProvider);
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: "How can i help you",
                            hintStyle: TextStyle(color: Colors.white)),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await sendMessageFCT(
                            modelsProvider: modelsProvider,
                            chatProvider: chatProvider);
                      },
                      icon: const Icon(Icons.send),
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            )
          ],
        )),
      ),
    );
  }

  void _scrollListToEND() {
    _listSrollController.animateTo(
        _listSrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut);
  }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
    if (_istyping) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(
          label: "You can't mutlipleat a time",
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(
          label: "Please type a message",
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _istyping = true;
        //  chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswer(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);
      // chatList.addAll(
      //   await ApiService.sendMessage(
      //       message: textEditingController.text,
      //       modelId: modelsProvider.getCurrentModel),
      // );
      setState(() {});
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _istyping = false;
        _scrollListToEND();
      });
    }
  }
}
