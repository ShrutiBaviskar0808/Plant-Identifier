class ComprehensivePlant {
  final String id;
  final String scientificName;
  final String commonName;
  final List<String> alternativeNames;
  final String family;
  final String genus;
  final String species;
  
  // Basic Information
  final String description;
  final PlantType type;
  final List<String> imageUrls;
  final String thumbnailUrl;
  
  // Care Information
  final CareRequirements careRequirements;
  final GrowthInfo growthInfo;
  final PropagationInfo propagationInfo;
  
  // Health & Safety
  final ToxicityInfo toxicityInfo;
  final List<CommonDisease> commonDiseases;
  final List<CommonPest> commonPests;
  
  // Environmental
  final List<String> nativeRegions;
  final ClimatePreferences climatePreferences;
  final SeasonalBehavior seasonalBehavior;
  
  // Additional Features
  final PlantBenefits benefits;
  final CulturalSignificance culturalInfo;
  final List<PlantFact> interestingFacts;
  final double popularityScore;
  final DateTime lastUpdated;

  ComprehensivePlant({
    required this.id,
    required this.scientificName,
    required this.commonName,
    required this.alternativeNames,
    required this.family,
    required this.genus,
    required this.species,
    required this.description,
    required this.type,
    required this.imageUrls,
    required this.thumbnailUrl,
    required this.careRequirements,
    required this.growthInfo,
    required this.propagationInfo,
    required this.toxicityInfo,
    required this.commonDiseases,
    required this.commonPests,
    required this.nativeRegions,
    required this.climatePreferences,
    required this.seasonalBehavior,
    required this.benefits,
    required this.culturalInfo,
    required this.interestingFacts,
    required this.popularityScore,
    required this.lastUpdated,
  });

  factory ComprehensivePlant.fromJson(Map<String, dynamic> json) {
    return ComprehensivePlant(
      id: json['id'],
      scientificName: json['scientific_name'],
      commonName: json['common_name'],
      alternativeNames: List<String>.from(json['alternative_names'] ?? []),
      family: json['family'],
      genus: json['genus'],
      species: json['species'],
      description: json['description'],
      type: PlantType.values.firstWhere((e) => e.name == json['type']),
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      thumbnailUrl: json['thumbnail_url'],
      careRequirements: CareRequirements.fromJson(json['care_requirements']),
      growthInfo: GrowthInfo.fromJson(json['growth_info']),
      propagationInfo: PropagationInfo.fromJson(json['propagation_info']),
      toxicityInfo: ToxicityInfo.fromJson(json['toxicity_info']),
      commonDiseases: (json['common_diseases'] as List?)
          ?.map((e) => CommonDisease.fromJson(e))
          .toList() ?? [],
      commonPests: (json['common_pests'] as List?)
          ?.map((e) => CommonPest.fromJson(e))
          .toList() ?? [],
      nativeRegions: List<String>.from(json['native_regions'] ?? []),
      climatePreferences: ClimatePreferences.fromJson(json['climate_preferences']),
      seasonalBehavior: SeasonalBehavior.fromJson(json['seasonal_behavior']),
      benefits: PlantBenefits.fromJson(json['benefits']),
      culturalInfo: CulturalSignificance.fromJson(json['cultural_info']),
      interestingFacts: (json['interesting_facts'] as List?)
          ?.map((e) => PlantFact.fromJson(e))
          .toList() ?? [],
      popularityScore: json['popularity_score']?.toDouble() ?? 0.0,
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }
}

enum PlantType {
  tree, shrub, herb, grass, fern, moss, succulent, cactus, vine, aquatic, annual, perennial
}

class CareRequirements {
  final WaterRequirement water;
  final LightRequirement light;
  final TemperatureRange temperature;
  final HumidityRange humidity;
  final SoilRequirement soil;
  final FertilizerRequirement fertilizer;
  final PruningRequirement pruning;
  final RepottingRequirement repotting;

  CareRequirements({
    required this.water,
    required this.light,
    required this.temperature,
    required this.humidity,
    required this.soil,
    required this.fertilizer,
    required this.pruning,
    required this.repotting,
  });

  factory CareRequirements.fromJson(Map<String, dynamic> json) {
    return CareRequirements(
      water: WaterRequirement.fromJson(json['water']),
      light: LightRequirement.fromJson(json['light']),
      temperature: TemperatureRange.fromJson(json['temperature']),
      humidity: HumidityRange.fromJson(json['humidity']),
      soil: SoilRequirement.fromJson(json['soil']),
      fertilizer: FertilizerRequirement.fromJson(json['fertilizer']),
      pruning: PruningRequirement.fromJson(json['pruning']),
      repotting: RepottingRequirement.fromJson(json['repotting']),
    );
  }
}

class WaterRequirement {
  final WaterFrequency frequency;
  final String amount;
  final List<String> seasonalAdjustments;
  final List<String> signs;

  WaterRequirement({
    required this.frequency,
    required this.amount,
    required this.seasonalAdjustments,
    required this.signs,
  });

  factory WaterRequirement.fromJson(Map<String, dynamic> json) {
    return WaterRequirement(
      frequency: WaterFrequency.values.firstWhere((e) => e.name == json['frequency']),
      amount: json['amount'],
      seasonalAdjustments: List<String>.from(json['seasonal_adjustments'] ?? []),
      signs: List<String>.from(json['signs'] ?? []),
    );
  }
}

enum WaterFrequency { daily, twiceWeekly, weekly, biweekly, monthly, asNeeded }

class LightRequirement {
  final LightLevel level;
  final int hoursPerDay;
  final List<String> lightTypes;
  final String placement;

  LightRequirement({
    required this.level,
    required this.hoursPerDay,
    required this.lightTypes,
    required this.placement,
  });

  factory LightRequirement.fromJson(Map<String, dynamic> json) {
    return LightRequirement(
      level: LightLevel.values.firstWhere((e) => e.name == json['level']),
      hoursPerDay: json['hours_per_day'],
      lightTypes: List<String>.from(json['light_types'] ?? []),
      placement: json['placement'],
    );
  }
}

enum LightLevel { low, medium, bright, direct }

class ToxicityInfo {
  final bool isToxic;
  final List<String> toxicTo;
  final ToxicityLevel level;
  final List<String> symptoms;
  final String treatment;

  ToxicityInfo({
    required this.isToxic,
    required this.toxicTo,
    required this.level,
    required this.symptoms,
    required this.treatment,
  });

  factory ToxicityInfo.fromJson(Map<String, dynamic> json) {
    return ToxicityInfo(
      isToxic: json['is_toxic'] ?? false,
      toxicTo: List<String>.from(json['toxic_to'] ?? []),
      level: ToxicityLevel.values.firstWhere(
        (e) => e.name == json['level'],
        orElse: () => ToxicityLevel.none,
      ),
      symptoms: List<String>.from(json['symptoms'] ?? []),
      treatment: json['treatment'] ?? '',
    );
  }
}

enum ToxicityLevel { none, mild, moderate, severe, deadly }

class CommonDisease {
  final String name;
  final String description;
  final List<String> symptoms;
  final List<String> causes;
  final List<String> treatments;
  final String prevention;
  final List<String> imageUrls;

  CommonDisease({
    required this.name,
    required this.description,
    required this.symptoms,
    required this.causes,
    required this.treatments,
    required this.prevention,
    required this.imageUrls,
  });

  factory CommonDisease.fromJson(Map<String, dynamic> json) {
    return CommonDisease(
      name: json['name'],
      description: json['description'],
      symptoms: List<String>.from(json['symptoms'] ?? []),
      causes: List<String>.from(json['causes'] ?? []),
      treatments: List<String>.from(json['treatments'] ?? []),
      prevention: json['prevention'] ?? '',
      imageUrls: List<String>.from(json['image_urls'] ?? []),
    );
  }
}

class CommonPest {
  final String name;
  final String description;
  final List<String> signs;
  final List<String> treatments;
  final String prevention;
  final List<String> imageUrls;

  CommonPest({
    required this.name,
    required this.description,
    required this.signs,
    required this.treatments,
    required this.prevention,
    required this.imageUrls,
  });

  factory CommonPest.fromJson(Map<String, dynamic> json) {
    return CommonPest(
      name: json['name'],
      description: json['description'],
      signs: List<String>.from(json['signs'] ?? []),
      treatments: List<String>.from(json['treatments'] ?? []),
      prevention: json['prevention'] ?? '',
      imageUrls: List<String>.from(json['image_urls'] ?? []),
    );
  }
}

// Additional supporting classes
class GrowthInfo {
  final String matureSize;
  final String growthRate;
  final String lifespan;
  final List<String> bloomingSeason;

  GrowthInfo({
    required this.matureSize,
    required this.growthRate,
    required this.lifespan,
    required this.bloomingSeason,
  });

  factory GrowthInfo.fromJson(Map<String, dynamic> json) {
    return GrowthInfo(
      matureSize: json['mature_size'] ?? '',
      growthRate: json['growth_rate'] ?? '',
      lifespan: json['lifespan'] ?? '',
      bloomingSeason: List<String>.from(json['blooming_season'] ?? []),
    );
  }
}

class PropagationInfo {
  final List<String> methods;
  final String bestTime;
  final String difficulty;
  final List<String> steps;

  PropagationInfo({
    required this.methods,
    required this.bestTime,
    required this.difficulty,
    required this.steps,
  });

  factory PropagationInfo.fromJson(Map<String, dynamic> json) {
    return PropagationInfo(
      methods: List<String>.from(json['methods'] ?? []),
      bestTime: json['best_time'] ?? '',
      difficulty: json['difficulty'] ?? '',
      steps: List<String>.from(json['steps'] ?? []),
    );
  }
}

class TemperatureRange {
  final double min;
  final double max;
  final String unit;

  TemperatureRange({required this.min, required this.max, required this.unit});

  factory TemperatureRange.fromJson(Map<String, dynamic> json) {
    return TemperatureRange(
      min: json['min']?.toDouble() ?? 0.0,
      max: json['max']?.toDouble() ?? 0.0,
      unit: json['unit'] ?? 'C',
    );
  }
}

class HumidityRange {
  final double min;
  final double max;

  HumidityRange({required this.min, required this.max});

  factory HumidityRange.fromJson(Map<String, dynamic> json) {
    return HumidityRange(
      min: json['min']?.toDouble() ?? 0.0,
      max: json['max']?.toDouble() ?? 0.0,
    );
  }
}

class SoilRequirement {
  final String type;
  final String drainage;
  final String ph;
  final List<String> nutrients;

  SoilRequirement({
    required this.type,
    required this.drainage,
    required this.ph,
    required this.nutrients,
  });

  factory SoilRequirement.fromJson(Map<String, dynamic> json) {
    return SoilRequirement(
      type: json['type'] ?? '',
      drainage: json['drainage'] ?? '',
      ph: json['ph'] ?? '',
      nutrients: List<String>.from(json['nutrients'] ?? []),
    );
  }
}

class FertilizerRequirement {
  final String type;
  final String frequency;
  final String season;
  final String npkRatio;

  FertilizerRequirement({
    required this.type,
    required this.frequency,
    required this.season,
    required this.npkRatio,
  });

  factory FertilizerRequirement.fromJson(Map<String, dynamic> json) {
    return FertilizerRequirement(
      type: json['type'] ?? '',
      frequency: json['frequency'] ?? '',
      season: json['season'] ?? '',
      npkRatio: json['npk_ratio'] ?? '',
    );
  }
}

class PruningRequirement {
  final String frequency;
  final String bestTime;
  final List<String> techniques;

  PruningRequirement({
    required this.frequency,
    required this.bestTime,
    required this.techniques,
  });

  factory PruningRequirement.fromJson(Map<String, dynamic> json) {
    return PruningRequirement(
      frequency: json['frequency'] ?? '',
      bestTime: json['best_time'] ?? '',
      techniques: List<String>.from(json['techniques'] ?? []),
    );
  }
}

class RepottingRequirement {
  final String frequency;
  final String bestTime;
  final List<String> signs;

  RepottingRequirement({
    required this.frequency,
    required this.bestTime,
    required this.signs,
  });

  factory RepottingRequirement.fromJson(Map<String, dynamic> json) {
    return RepottingRequirement(
      frequency: json['frequency'] ?? '',
      bestTime: json['best_time'] ?? '',
      signs: List<String>.from(json['signs'] ?? []),
    );
  }
}

class ClimatePreferences {
  final List<String> zones;
  final String climate;
  final bool indoorSuitable;
  final bool outdoorSuitable;

  ClimatePreferences({
    required this.zones,
    required this.climate,
    required this.indoorSuitable,
    required this.outdoorSuitable,
  });

  factory ClimatePreferences.fromJson(Map<String, dynamic> json) {
    return ClimatePreferences(
      zones: List<String>.from(json['zones'] ?? []),
      climate: json['climate'] ?? '',
      indoorSuitable: json['indoor_suitable'] ?? false,
      outdoorSuitable: json['outdoor_suitable'] ?? false,
    );
  }
}

class SeasonalBehavior {
  final Map<String, String> seasonalChanges;
  final bool isEvergreen;
  final String dormancyPeriod;

  SeasonalBehavior({
    required this.seasonalChanges,
    required this.isEvergreen,
    required this.dormancyPeriod,
  });

  factory SeasonalBehavior.fromJson(Map<String, dynamic> json) {
    return SeasonalBehavior(
      seasonalChanges: Map<String, String>.from(json['seasonal_changes'] ?? {}),
      isEvergreen: json['is_evergreen'] ?? false,
      dormancyPeriod: json['dormancy_period'] ?? '',
    );
  }
}

class PlantBenefits {
  final bool airPurifying;
  final List<String> healthBenefits;
  final List<String> environmentalBenefits;
  final bool petFriendly;

  PlantBenefits({
    required this.airPurifying,
    required this.healthBenefits,
    required this.environmentalBenefits,
    required this.petFriendly,
  });

  factory PlantBenefits.fromJson(Map<String, dynamic> json) {
    return PlantBenefits(
      airPurifying: json['air_purifying'] ?? false,
      healthBenefits: List<String>.from(json['health_benefits'] ?? []),
      environmentalBenefits: List<String>.from(json['environmental_benefits'] ?? []),
      petFriendly: json['pet_friendly'] ?? false,
    );
  }
}

class CulturalSignificance {
  final String symbolism;
  final List<String> traditions;
  final String folklore;

  CulturalSignificance({
    required this.symbolism,
    required this.traditions,
    required this.folklore,
  });

  factory CulturalSignificance.fromJson(Map<String, dynamic> json) {
    return CulturalSignificance(
      symbolism: json['symbolism'] ?? '',
      traditions: List<String>.from(json['traditions'] ?? []),
      folklore: json['folklore'] ?? '',
    );
  }
}

class PlantFact {
  final String title;
  final String description;
  final String category;

  PlantFact({
    required this.title,
    required this.description,
    required this.category,
  });

  factory PlantFact.fromJson(Map<String, dynamic> json) {
    return PlantFact(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
    );
  }
}