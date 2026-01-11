import 'package:flutter/material.dart';
import 'package:matchifiy/models/team_model.dart';
import 'package:matchifiy/services/favorite_team_service.dart';
import 'package:matchifiy/services/token_storage.dart';
import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';

class FavoriteTeamScreen extends StatefulWidget {
  const FavoriteTeamScreen({super.key});

  @override
  State<FavoriteTeamScreen> createState() => _FavoriteTeamScreenState();
}

class _FavoriteTeamScreenState extends State<FavoriteTeamScreen> {
  final FavoriteTeamService _favoriteService = FavoriteTeamService();

  List<Team> _teams = [];
  List<int> _selectedTeamIds = [];

  bool _isLoading = true;
  bool _isSaving = false;

  String ip = TokenStorage.getIp();

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    try {
      final teams = await _favoriteService.getTeams();
      final favoriteIds = await _favoriteService.getFavoriteTeamIds();

      if (!mounted) return;

      setState(() {
        _teams = teams;
        _selectedTeamIds = favoriteIds;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveTeams() async {
    if (_selectedTeamIds.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      await _favoriteService.resetFavoriteTeams(_selectedTeamIds);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم حفظ الفرق المفضلة بنجاح")),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("حدث خطأ: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return CustomBackgroundScaffold(
      appBar: AppBar(
        title: Text(
          isArabic ? "فرقك المفضلة" : "Favorite Teams",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          // selectionColor: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 137, 182, 217),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic
                          ? "اختر فريقًا أو أكثر لمتابعة أخبارهم:"
                          : "Select one or more teams to follow:",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// قائمة الفرق
                    Expanded(
                      child: ListView.builder(
                        itemCount: _teams.length,
                        itemBuilder: (context, index) {
                          final team = _teams[index];
                          final isSelected = _selectedTeamIds.contains(team.id);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Color.fromARGB(255, 137, 182, 217)
                                      : const Color(0xFF28283D),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Color.fromARGB(255, 137, 182, 217)
                                        : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: ListTile(
                              leading: Image.network(
                                '$ip/${team.logoUrl}',
                                width: 40,
                                height: 40,
                                fit: BoxFit.contain,
                                errorBuilder:
                                    (_, __, ___) => const Icon(
                                      Icons.shield,
                                      color: Colors.white54,
                                    ),
                              ),
                              title: Text(
                                team.name,
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color:
                                    isSelected
                                        ? const Color.fromARGB(
                                          255,
                                          114,
                                          116,
                                          228,
                                        )
                                        : Colors.white24,
                              ),
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedTeamIds.remove(team.id);
                                  } else {
                                    _selectedTeamIds.add(team.id);
                                  }
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed:
                          _isSaving || _selectedTeamIds.isEmpty
                              ? null
                              : _saveTeams,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 137, 182, 217),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          _isSaving
                              ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                isArabic
                                    ? "حفظ الفرق المختارة"
                                    : "Save Selected Teams",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ],
                ),
              ),
    );
  }
}
