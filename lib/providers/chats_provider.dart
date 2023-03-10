import 'package:explore/models/chat_model.dart';
import 'package:explore/services/api_servies.dart';
import 'package:flutter/cupertino.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswer(
      {required String msg, required String chosenModelId}) async {
    chatList.addAll(
        await ApiService.sendMessage(message: msg, modelId: chosenModelId));
    notifyListeners();
  }
}
