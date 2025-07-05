import 'package:flutter/material.dart';

class OnboardingModel {
  final String title;
  final String description;
  final String imagePath;
  final String buttonText;
  final Color backgroundColor;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.buttonText,
    required this.backgroundColor,
  });

  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
      title: json['title'],
      description: json['description'],
      imagePath: json['imagePath'],
      buttonText: json['buttonText'],
      backgroundColor: _parseColor(json['backgroundColor']),
    );
  }

  static Color _parseColor(String colorString) {
    String valueString = colorString.replaceAll('#', '');
    return Color(int.parse('FF$valueString', radix: 16));
  }
}