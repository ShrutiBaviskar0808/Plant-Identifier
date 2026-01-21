class VoiceQuery {
  final String id;
  final String transcript;
  final String response;
  final List<String> actions;
  final DateTime timestamp;

  VoiceQuery({
    required this.id,
    required this.transcript,
    required this.response,
    required this.actions,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class VoicePlantService {
  static Future<VoiceQuery> processVoiceQuery(String transcript) async {
    // Simulate voice processing
    await Future.delayed(Duration(seconds: 1));
    
    final query = transcript.toLowerCase();
    String response;
    List<String> actions = [];
    
    if (query.contains('yellow') && query.contains('leaves')) {
      response = "Yellow leaves usually indicate overwatering or nutrient deficiency. Check if the soil is soggy and reduce watering frequency. Consider fertilizing if it's growing season.";
      actions = ['reduce_watering', 'check_fertilizer'];
    } else if (query.contains('water') && (query.contains('how') || query.contains('when'))) {
      response = "Water when the top inch of soil feels dry. Most plants prefer deep, infrequent watering rather than frequent light watering.";
      actions = ['set_watering_reminder'];
    } else if (query.contains('light') || query.contains('sun')) {
      response = "Most houseplants prefer bright, indirect light. Place them near a window but avoid direct sunlight which can scorch leaves.";
      actions = ['check_plant_placement'];
    } else if (query.contains('dying') || query.contains('sick')) {
      response = "Let me help diagnose the issue. Common causes include overwatering, underwatering, pests, or disease. Can you describe the symptoms you're seeing?";
      actions = ['schedule_health_check', 'take_diagnostic_photo'];
    } else if (query.contains('fertilizer') || query.contains('feed')) {
      response = "Feed your plants monthly during spring and summer with diluted liquid fertilizer. Avoid fertilizing in winter when growth slows down.";
      actions = ['set_fertilizer_reminder'];
    } else {
      response = "I'd be happy to help with your plant question! Could you be more specific about what you're observing or what help you need?";
      actions = ['ask_clarification'];
    }
    
    return VoiceQuery(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      transcript: transcript,
      response: response,
      actions: actions,
    );
  }
  
  static List<String> getSuggestedQuestions() {
    return [
      "Why are my plant's leaves turning yellow?",
      "How often should I water my monstera?",
      "What's wrong with my plant?",
      "When should I fertilize my plants?",
      "How much light does my plant need?",
      "Is my plant dying?",
    ];
  }
}