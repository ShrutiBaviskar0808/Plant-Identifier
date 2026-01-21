enum IdentificationType {
  leaf,
  flower,
  fruit,
  bark,
  habit,
  disease,
  pest,
  auto;

  String get value {
    switch (this) {
      case IdentificationType.leaf:
        return 'leaf';
      case IdentificationType.flower:
        return 'flower';
      case IdentificationType.fruit:
        return 'fruit';
      case IdentificationType.bark:
        return 'bark';
      case IdentificationType.habit:
        return 'habit';
      case IdentificationType.disease:
        return 'disease';
      case IdentificationType.pest:
        return 'pest';
      case IdentificationType.auto:
        return 'auto';
    }
  }

  static IdentificationType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'leaf':
        return IdentificationType.leaf;
      case 'flower':
        return IdentificationType.flower;
      case 'fruit':
        return IdentificationType.fruit;
      case 'bark':
        return IdentificationType.bark;
      case 'habit':
        return IdentificationType.habit;
      case 'disease':
        return IdentificationType.disease;
      case 'pest':
        return IdentificationType.pest;
      case 'auto':
      default:
        return IdentificationType.auto;
    }
  }
}