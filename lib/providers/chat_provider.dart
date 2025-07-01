import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hive/hive.dart';
import '../models/message.dart';

class ChatProvider with ChangeNotifier {
  List<Message> _messages = [];
  bool _isTyping = false;
  String? _errorMessage;

  List<Message> get messages => _messages;
  bool get isTyping => _isTyping;
  String? get errorMessage => _errorMessage;

  ChatProvider() {
    _loadMessages();
  }

  void _loadMessages() async {
    final box = Hive.box<Message>('chat_history');
    _messages = box.values.toList();
    notifyListeners();
  }

  void addMessage(String sender, String text) async {
    final message = Message(
      sender: sender,
      text: text,
      timestamp: DateTime.now(),
    );
    _messages.add(message);
    final box = Hive.box<Message>('chat_history');
    await box.add(message);
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    addMessage('user', text);
    _isTyping = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final gemini = Gemini.instance;
      final response = await gemini.text(text);
      if (response != null && response.output != null) {
        addMessage('bot', response.output!);
      } else {
        _errorMessage = 'No response from Gemini.';
        addMessage('bot', _errorMessage!);
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      addMessage('bot', _errorMessage!);
    } finally {
      _isTyping = false;
      notifyListeners();
    }
  }

  void clearChat() async {
    _messages.clear();
    final box = Hive.box<Message>('chat_history');
    await box.clear();
    notifyListeners();
  }
}