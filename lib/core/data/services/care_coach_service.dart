class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? plantId;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    DateTime? timestamp,
    this.plantId,
  }) : timestamp = timestamp ?? DateTime.now();
}

class CareCoachService {
  static final List<ChatMessage> _chatHistory = [];
  
  static List<ChatMessage> getChatHistory() => List.from(_chatHistory);
  
  static Future<String> askCoach(String question, {String? plantId}) async {
    // Add user message
    _chatHistory.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: question,
      isUser: true,
      plantId: plantId,
    ));
    
    // Simulate AI processing
    await Future.delayed(Duration(seconds: 1));
    
    // Generate response based on keywords
    String response = _generateResponse(question.toLowerCase());
    
    // Add AI response
    _chatHistory.add(ChatMessage(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      content: response,
      isUser: false,
      plantId: plantId,
    ));
    
    return response;
  }
  
  static String _generateResponse(String question) {
    if (question.contains('water')) {
      return "💧 For watering, check the soil moisture first. Most plants prefer the top inch to dry out between waterings. Water thoroughly until it drains from the bottom.";
    } else if (question.contains('light')) {
      return "☀️ Most houseplants thrive in bright, indirect light. Place them near a window but avoid direct sunlight which can scorch leaves.";
    } else if (question.contains('yellow') || question.contains('dying')) {
      return "🍃 Yellow leaves often indicate overwatering or nutrient deficiency. Check soil drainage and reduce watering frequency. Consider fertilizing if it's growing season.";
    } else if (question.contains('fertilizer') || question.contains('feed')) {
      return "🌱 Feed plants monthly during spring and summer with diluted liquid fertilizer. Avoid fertilizing in winter when growth slows.";
    } else if (question.contains('repot')) {
      return "🪴 Repot when roots circle the pot or growth slows. Choose a pot 1-2 inches larger and use fresh potting mix. Spring is the best time.";
    } else {
      return "🌿 I'd be happy to help with your plant care question! For the best advice, could you tell me more about your specific plant and the issue you're experiencing?";
    }
  }
  
  static void clearHistory() {
    _chatHistory.clear();
  }
}