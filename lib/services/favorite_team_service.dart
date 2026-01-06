import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:matchifiy/models/team_model.dart';
import 'package:matchifiy/services/token_storage.dart';

class FavoriteTeamService {
  static final ip = TokenStorage.getIp();
  // جلب الفريق المفضل من الباكيند
  Future<Team?> getFavoriteTeam() async {
    final token = await TokenStorage.getToken();
    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('$ip/api/favorite-teams'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      log(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log(data.toString());

        // 👇 هنا التصحيح المهم
        final List teams = data['favorite_teams'];

        if (teams.isEmpty) return null;

        return Team.fromJson(teams.first);
      }

      return null;
    } catch (e) {
      log("Error fetching favorite team: $e");
      return null;
    }
  }

  // Future<Team?> getFavoriteTeam() async {
  //   final token = await TokenStorage.getToken();
  //   if (token == null) return null;

  //   try {
  //     final response = await http.get(
  //       Uri.parse('$ip/api/favorite-teams'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Accept': 'application/json',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final List data = jsonDecode(response.body);
  //       if (data.isEmpty) return null;

  //       return Team.fromJson(data.first);
  //     }
  //     return null;
  //   } catch (e) {
  //     log("Error fetching favorite team: $e");
  //     return null;
  //   }
  // }

  // Future<String?> getFavoriteTeam() async {
  //   final token = await TokenStorage.getToken();

  //   // إذا لم يوجد توكين، لا داعي لإرسال الطلب
  //   if (token == null) return null;

  //   try {
  //     final response = await http.get(
  //       Uri.parse('$ip/api/favorite-teams'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Accept': 'application/json',
  //         'Content-Type': 'application/json',
  //       },
  //     );

  //     // log("Get Favorite Team Response: ${response.body}");

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       // ملاحظة: تأكد من أن الباكيند يرسل الحقل بهذا الاسم (مثلاً team أو favorite_team)
  //       return data['favorite_teams']?.toString();
  //       // return data['team']?.toString();
  //     }
  //     return null;
  //   } catch (e) {
  //     log("Error fetching favorite team: $e");
  //     return null;
  //   }
  // }

  // Future<String?> getTeams() async {
  //   final token = await TokenStorage.getToken();

  //   // إذا م يوجد توكين، لا داعي لإرسال الطلب
  //   if (token == null) return null;

  //   try {
  //     final response = await http.get(
  //       Uri.parse('$ip/api/favorite-teams/available'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Accept': 'application/json',
  //         'Content-Type': 'application/json',
  //       },
  //     );

  //     log("Get Favorite Team Response: ${response.body}");

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       // ملاحظة: تأكد من أن الباكيند يرسل الحقل بهذا الاسم (مثلاً team أو favorite_team)
  //       log("Available teams: ${data['teams']}");
  //       return data['team']?.toString();
  //     }
  //     return null;
  //   } catch (e) {
  //     log("Error fetching favorite team: $e");
  //     return null;
  //   }
  // }
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

  // حفظ أو تعديل الفريق المفضل
  // Future<bool> saveFavoriteTeam(int team_id) async {
  //   // Future<bool> saveFavoriteTeam(String teamName) async {
  //   final token = await TokenStorage.getToken();

  //   if (token == null) {
  //     log("Error: No token found in storage");
  //     return false;
  //   }

  //   try {
  //     // إرسال الطلب للباكيند
  //     final response = await http.post(
  //       Uri.parse('$ip/api/favorite-teams'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Accept': 'application/json',
  //         'Content-Type': 'application/json',
  //       },
  //       // ملاحظة مهمة: تأكد من اسم الحقل المتوقع في الـ Controller (مثلاً team_id أو team_name)
  //       body: jsonEncode({'team_id': team_id}),
  //       // body: jsonEncode({'team': teamName}),
  //     );

  //     // طباعة الرد لمساعدتك في معرفة ما إذا كان الباكيند يرفض الطلب (مثل 422 Validation Error)
  //     log("Save Favorite Team Status: ${response.statusCode}");
  //     log("Save Favorite Team Response: ${response.body}");

  //     // التحقق من النجاح (200 أو 201)
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     log("Exception while saving favorite team: $e");
  //     return false;
  //   }
  // }
  // Future<Team?> saveFavoriteTeam(int teamId) async {
  //   final token = await TokenStorage.getToken();
  //   if (token == null) return null;

  //   try {
  //     final response = await http.post(
  //       Uri.parse('$ip/api/favorite-teams'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Accept': 'application/json',
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({'team_id': teamId}),
  //     );

  //     log("Save Favorite Team Status: ${response.statusCode}");
  //     log("Save Favorite Team Response: ${response.body}");

  //     if (response.statusCode == 201) {
  //       final data = jsonDecode(response.body);
  //       return Team.fromJson(data['team']); // تحويل الفريق إلى كائن Team
  //     }
  //     return null;
  //   } catch (e) {
  //     log("Error saving favorite team: $e");
  //     return null;
  //   }
  // }
  // Future<bool> resetFavoriteTeams(List<int> selectedTeamIds) async {
  //   final token = await TokenStorage.getToken();
  //   if (token == null) return false;

  //   try {
  //     final response = await http.post(
  //       Uri.parse('$ip/api/favorite-teams/reset'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Accept': 'application/json',
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({'new_team_ids': selectedTeamIds}),
  //     );

  //     log('Reset Favorite Teams Response: ${response.body}');
  //     return response.statusCode == 200;
  //   } catch (e) {
  //     log('Error resetting favorite teams: $e');
  //     return false;
  //   }
  // }
  Future<void> resetFavoriteTeams(List<int> teamIds) async {
    final token = await TokenStorage.getToken();
    if (token == null) throw Exception("No token");

    final response = await http.put(
      // final response = await http.post(
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
        body: jsonEncode({
          'team_ids': teamIds, //  مصفوفة
        }),
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

  // Future<List<Team>> getFavoriteTeams() async {
  //   final token = await TokenStorage.getToken();
  //   if (token == null) return [];

  //   try {
  //     final response = await http.get(
  //       Uri.parse('$ip/api/favorite-teams'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Accept': 'application/json',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       final List teams = data['favorite_teams'];
  //       return teams.map((e) => Team.fromJson(e)).toList();
  //     }

  //     return [];
  //   } catch (e) {
  //     log("Error fetching favorite teams: $e");
  //     return [];
  //   }
  // }
}
