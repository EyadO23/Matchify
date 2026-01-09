import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:matchifiy/models/team_news_model.dart';
import 'package:matchifiy/services/news_service.dart';
import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsService _api = NewsService();

  TeamNews? _news;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _fetchNews();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchNews() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final TeamNews? newsData = await _api.getNews();

      if (!mounted) return;

      if (newsData != null) {
        log(
          "News fetched: Team=${newsData.team?.name}, Articles count=${newsData.articles.length}",
        );
      } else {
        log("No news received");
      }

      setState(() {
        _news = newsData;
        _isLoading = false;
      });
    } catch (e) {
      log("Error fetching news: $e");

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: CustomBackgroundScaffold(
        appBar: AppBar(
          title: Text(
            isArabic ? "أخبار الرياضة" : "Sports News",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Color.fromARGB(255, 137, 182, 217),
                // color: Color.fromARGB(255, 137, 182, 217),
              ),
              onPressed: _fetchNews,
            ),
          ],
        ),
        body:
            _isLoading
                ? const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 137, 182, 217),
                  ),
                )
                : _errorMessage != null
                ? _buildErrorUI(isArabic)
                : _buildNewsContentGroupedByTeam(isArabic),
      ),
    );
  }

  Widget _buildNewsContentGroupedByTeam(bool isArabic) {
    if (_news == null || _news!.articles.isEmpty) {
      return Center(
        child: Text(
          isArabic ? "لا توجد أخبار" : "No news",
          style: const TextStyle(color: Colors.white54),
        ),
      );
    }

    Map<int, List<dynamic>> teamArticlesMap = {};
    for (var article in _news!.articles) {
      final teamId = article.teamId ?? 0;
      teamArticlesMap.putIfAbsent(teamId, () => []);
      teamArticlesMap[teamId]!.add(article);
    }

    return RefreshIndicator(
      onRefresh: _fetchNews,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children:
            teamArticlesMap.entries.map((entry) {
              final articles = entry.value;
              final teamName = articles.first.teamName ?? '';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (teamName.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        teamName,
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ...articles.map(
                    (article) => _buildNewsCard(article, isArabic),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildNewsCard(dynamic article, bool isArabic) {
    final imageUrl = article.imageUrl ?? '';
    final title = article.title ?? '';
    final description = article.description ?? '';
    final publishedAt = article.publishedAt ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                      height: 150,
                      color: Colors.white12,
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.white30,
                      ),
                    ),
              ),
            ),
          const SizedBox(height: 12),
          Text(
            title,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          if (description.isNotEmpty)
            Text(
              description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: Colors.white.withOpacity(0.4),
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                publishedAt,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorUI(bool isArabic) => Center(
    child: Text(
      _errorMessage ?? "Error",
      style: const TextStyle(color: Colors.white),
    ),
  );
}
