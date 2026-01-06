// class NewsArticle {
//   final String title;
//   final String publishedAt;
//   final String source;
//   final String url;
//   final String imageUrl;
//   final int teamId;
//   final String teamName;
//   final String teamLogo;

//   NewsArticle({
//     required this.title,
//     required this.publishedAt,
//     required this.source,
//     required this.url,
//     required this.imageUrl,
//     required this.teamId,
//     required this.teamName,
//     required this.teamLogo,
//   });

//   factory NewsArticle.fromJson(Map<String, dynamic> json) {
//     return NewsArticle(
//       title: json['title'] ?? '',
//       publishedAt: json['publishedAt'] ?? '',
//       source: json['source'] ?? '',
//       url: json['url'] ?? '',
//       imageUrl: json['image_url'] ?? '',
//       teamId: json['team_id'],
//       teamName: json['team_name'] ?? '',
//       teamLogo: json['team_logo'] ?? '',
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class News {
  final String title;
  final String publishedAt;
  final String source;
  final String url;
  final String imageUrl;
  final int teamId;
  final String teamName;
  final String teamLogo;

  News({
    required this.title,
    required this.publishedAt,
    required this.source,
    required this.url,
    required this.imageUrl,
    required this.teamId,
    required this.teamName,
    required this.teamLogo,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] ?? 'بدون عنوان',
      publishedAt: json['publishedAt'] ?? '',
      source: json['source'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['image_url'] ?? '',
      teamId: json['team_id'] ?? 0,
      teamName: json['team_name'] ?? 'غير معروف',
      teamLogo: json['team_logo'] ?? '',
    );
  }
}
