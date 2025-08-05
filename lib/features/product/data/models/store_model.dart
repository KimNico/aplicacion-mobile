import 'dart:convert';
import '../../domain/entities/store.dart';

class StoreModel extends Store {
  const StoreModel({
    required super.id,
    required super.name,
    required super.description,
    required super.address,
    required super.phone,
    required super.email,
    required super.whatsapp,
    required super.website,
    required super.latitude,
    required super.longitude,
    required super.images,
    required super.hours,
    super.isActive = true,
    super.categories = const [],
    super.createdAt,
    super.updatedAt,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      whatsapp: json['whatsapp'] as String,
      website: json['website'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      images: List<String>.from(json['images'] as List),
      hours: StoreHoursModel.fromJson(json['hours'] as Map<String, dynamic>),
      isActive: json['is_active'] as bool? ?? true,
      categories: json['categories'] != null 
          ? List<String>.from(json['categories'] as List)
          : const [],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  factory StoreModel.fromEntity(Store store) {
    return StoreModel(
      id: store.id,
      name: store.name,
      description: store.description,
      address: store.address,
      phone: store.phone,
      email: store.email,
      whatsapp: store.whatsapp,
      website: store.website,
      latitude: store.latitude,
      longitude: store.longitude,
      images: store.images,
      hours: store.hours,
      isActive: store.isActive,
      categories: store.categories,
      createdAt: store.createdAt,
      updatedAt: store.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'phone': phone,
      'email': email,
      'whatsapp': whatsapp,
      'website': website,
      'latitude': latitude,
      'longitude': longitude,
      'images': images,
      'hours': (hours as StoreHoursModel).toJson(),
      'is_active': isActive,
      'categories': categories,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  StoreModel copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    String? phone,
    String? email,
    String? whatsapp,
    String? website,
    double? latitude,
    double? longitude,
    List<String>? images,
    StoreHours? hours,
    bool? isActive,
    List<String>? categories,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StoreModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      whatsapp: whatsapp ?? this.whatsapp,
      website: website ?? this.website,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      images: images ?? this.images,
      hours: hours ?? this.hours,
      isActive: isActive ?? this.isActive,
      categories: categories ?? this.categories,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static List<StoreModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => StoreModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<StoreModel> stores) {
    return stores.map((store) => store.toJson()).toList();
  }
}

class StoreHoursModel extends StoreHours {
  const StoreHoursModel({
    required super.schedules,
    super.specialHours = '',
    super.isOpenNow = false,
  });

  factory StoreHoursModel.fromJson(Map<String, dynamic> json) {
    final schedulesMap = <DayOfWeek, DaySchedule>{};
    final schedulesJson = json['schedules'] as Map<String, dynamic>;
    
    schedulesJson.forEach((key, value) {
      final dayOfWeek = _parseDayOfWeek(key);
      schedulesMap[dayOfWeek] = DayScheduleModel.fromJson(value as Map<String, dynamic>);
    });

    return StoreHoursModel(
      schedules: schedulesMap,
      specialHours: json['special_hours'] as String? ?? '',
      isOpenNow: json['is_open_now'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final schedulesJson = <String, dynamic>{};
    schedules.forEach((key, value) {
      schedulesJson[key.name] = (value as DayScheduleModel).toJson();
    });

    return {
      'schedules': schedulesJson,
      'special_hours': specialHours,
      'is_open_now': isOpenNow,
    };
  }

  static DayOfWeek _parseDayOfWeek(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return DayOfWeek.monday;
      case 'tuesday':
        return DayOfWeek.tuesday;
      case 'wednesday':
        return DayOfWeek.wednesday;
      case 'thursday':
        return DayOfWeek.thursday;
      case 'friday':
        return DayOfWeek.friday;
      case 'saturday':
        return DayOfWeek.saturday;
      case 'sunday':
        return DayOfWeek.sunday;
      default:
        return DayOfWeek.monday;
    }
  }
}

class DayScheduleModel extends DaySchedule {
  const DayScheduleModel({
    required super.isOpen,
    required super.openTime,
    required super.closeTime,
    super.breakStart,
    super.breakEnd,
  });

  factory DayScheduleModel.fromJson(Map<String, dynamic> json) {
    return DayScheduleModel(
      isOpen: json['is_open'] as bool,
      openTime: json['open_time'] as String,
      closeTime: json['close_time'] as String,
      breakStart: json['break_start'] as String?,
      breakEnd: json['break_end'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_open': isOpen,
      'open_time': openTime,
      'close_time': closeTime,
      'break_start': breakStart,
      'break_end': breakEnd,
    };
  }
} 