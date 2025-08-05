import 'package:equatable/equatable.dart';

class Store extends Equatable {
  final String id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final String email;
  final String whatsapp;
  final String website;
  final double latitude;
  final double longitude;
  final List<String> images;
  final StoreHours hours;
  final bool isActive;
  final List<String> categories;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Store({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
    required this.whatsapp,
    required this.website,
    required this.latitude,
    required this.longitude,
    required this.images,
    required this.hours,
    this.isActive = true,
    this.categories = const [],
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        address,
        phone,
        email,
        whatsapp,
        website,
        latitude,
        longitude,
        images,
        hours,
        isActive,
        categories,
        createdAt,
        updatedAt,
      ];

  Store copyWith({
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
    return Store(
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
}

class StoreHours extends Equatable {
  final Map<DayOfWeek, DaySchedule> schedules;
  final String specialHours;
  final bool isOpenNow;

  const StoreHours({
    required this.schedules,
    this.specialHours = '',
    this.isOpenNow = false,
  });

  @override
  List<Object?> get props => [schedules, specialHours, isOpenNow];

  StoreHours copyWith({
    Map<DayOfWeek, DaySchedule>? schedules,
    String? specialHours,
    bool? isOpenNow,
  }) {
    return StoreHours(
      schedules: schedules ?? this.schedules,
      specialHours: specialHours ?? this.specialHours,
      isOpenNow: isOpenNow ?? this.isOpenNow,
    );
  }
}

class DaySchedule extends Equatable {
  final bool isOpen;
  final String openTime;
  final String closeTime;
  final String? breakStart;
  final String? breakEnd;

  const DaySchedule({
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
    this.breakStart,
    this.breakEnd,
  });

  @override
  List<Object?> get props => [isOpen, openTime, closeTime, breakStart, breakEnd];

  DaySchedule copyWith({
    bool? isOpen,
    String? openTime,
    String? closeTime,
    String? breakStart,
    String? breakEnd,
  }) {
    return DaySchedule(
      isOpen: isOpen ?? this.isOpen,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      breakStart: breakStart ?? this.breakStart,
      breakEnd: breakEnd ?? this.breakEnd,
    );
  }
}

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday
} 