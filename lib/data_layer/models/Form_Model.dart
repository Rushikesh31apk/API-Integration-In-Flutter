import 'package:flutter/foundation.dart';

class Model {
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final List<Results> results;

  Model({
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
    required this.results,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      totalPages: json['total_pages'] ?? 0,
      currentPage: json['current_page'] ?? 0,
      pageSize: json['page_size'] ?? 0,
      results: (json['results'] as List<dynamic>?)
          ?.map((item) => Results.fromJson(item))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_pages': totalPages,
      'current_page': currentPage,
      'page_size': pageSize,
      'results': results.map((result) => result.toJson()).toList(),
    };
  }
}

class Results {
  final int id;
  final String name;
  final String nameLocale;
  final String modifierGroupDescription;
  final String modifierGroupDescriptionLocale;
  final String plu;
  final int min;
  final int max;
  final bool active;
  final int vendorId;

  Results({
    required this.id,
    required this.name,
    required this.nameLocale,
    required this.modifierGroupDescription,
    required this.modifierGroupDescriptionLocale,
    required this.plu,
    required this.min,
    required this.max,
    required this.active,
    required this.vendorId,
  });

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nameLocale: json['name_locale'] ?? '',
      modifierGroupDescription: json['modifier_group_description'] ?? '',
      modifierGroupDescriptionLocale: json['modifier_group_description_locale'] ?? '',
      plu: json['PLU'] ?? '',
      min: json['min'] ?? 0,
      max: json['max'] ?? 0,
      active: json['active'] ?? false,
      vendorId: json['vendorId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_locale': nameLocale,
      'modifier_group_description': modifierGroupDescription,
      'modifier_group_description_locale': modifierGroupDescriptionLocale,
      'PLU': plu,
      'min': min,
      'max': max,
      'active': active,
      'vendorId': vendorId,
    };
  }
}
