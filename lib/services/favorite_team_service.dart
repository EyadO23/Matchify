import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:matchifiy/models/team_model.dart';
import 'package:matchifiy/services/token_storage.dart';

class FavoriteTeamService {
  static final ip = TokenStorage.getIp();

  Future<List<Team>> getTeams() async {
    final token = await TokenStorage.getToken();
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse('$ip/api/favorite-teams/available'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List teamsJson = data['teams'];
        log("Teams JSON: $teamsJson");
        return teamsJson.map((e) => Team.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      log("Error fetching teams: $e");
      return [];
    }
  }

  Future<void> resetFavoriteTeams(List<int> teamIds) async {
    final token = await TokenStorage.getToken();
    if (token == null) throw Exception("No token");

    final response = await http.put(
      Uri.parse('$ip/api/favorite-teams/reset'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"new_team_ids": teamIds}),
    );

    log("Reset favorite teams response: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to reset favorite teams");
    }
  }

  Future<List<Team>> saveFavoriteTeams(List<int> teamIds) async {
    final token = await TokenStorage.getToken();
    if (token == null) return [];

    try {
      final response = await http.post(
        Uri.parse('$ip/api/favorite-teams/favorite-teams/multiple'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'team_ids': teamIds}),
      );

      log("Save Favorite Teams Status: ${response.statusCode}");
      log("Save Favorite Teams Response: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List teamsJson = data['teams'];
        return teamsJson.map((e) => Team.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      log("Error saving favorite teams: $e");
      return [];
    }
  }

  Future<List<int>> getFavoriteTeamIds() async {
    final token = await TokenStorage.getToken();
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse('$ip/api/favorite-teams'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List favorites = data['favorite_teams'];

        return favorites.map<int>((e) => e['team_id'] as int).toList();
      }

      return [];
    } catch (e) {
      log("Error fetching favorite team ids: $e");
      return [];
    }
  }
}
