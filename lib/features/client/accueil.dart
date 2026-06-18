import 'package:flutter/material.dart';
import 'package:travvite_1/features/auth/connexion.dart';
import 'package:travvite_1/features/client/liste_ouvriers.dart';
import 'package:travvite_1/features/client/mes_commandes.dart';
import 'package:travvite_1/features/client/profil_ouvrier.dart';
import '../../data/modeles/ouvrier_model.dart';
import '../../data/modeles/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/ouvrier_repository.dart';
import '../../data/services/session_manager.dart';
import '../../Core/constantes/app_constantes.dart';

class Accueil extends StatefulWidget {
  final String langue;
  const Accueil({super.key, required this.langue});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  int _currentIndex = 0;
  static const primary = Color(0xFF2B4C7E);

  final _ouvrierRepository = OuvrierRepository();
  final _authRepository = AuthRepository();

  List<OuvrierModel> _plusNotes = [];
  UserModel? _user;
  bool _isLoading = true;
  String? _error;

  final List<Map<String, dynamic>> _categories = [
    {'nom_ar': 'خادمة', 'nom_fr': 'Femme de ménage', 'icon': Icons.home_outlined, 'key': 'KHADIMA'},
    {'nom_ar': 'مربية', 'nom_fr': 'Garde d\'enfants', 'icon': Icons.child_care_rounded, 'key': 'MARBIYA'},
    {'nom_ar': 'طباخة', 'nom_fr': 'Cuisinière', 'icon': Icons.restaurant_rounded, 'key': 'TABBAKHA'},
    {'nom_ar': 'نجار', 'nom_fr': 'Menuisier', 'icon': Icons.carpenter, 'key': 'NAJJAR'},
    {'nom_ar': 'كهربائي', 'nom_fr': 'Électricien', 'icon': Icons.electrical_services, 'key': 'KAHRABAI'},
    {'nom_ar': 'سباك', 'nom_fr': 'Plombier', 'icon': Icons.plumbing, 'key': 'SABBAK'},
    {'nom_ar': 'دهان', 'nom_fr': 'Peintre', 'icon': Icons.format_paint, 'key': 'DAHAN'},
    {'nom_ar': 'تنظيف', 'nom_fr': 'Nettoyage', 'icon': Icons.cleaning_services, 'key': 'TANDHIF'},
    {'nom_ar': 'حداد', 'nom_fr': 'Forgeron', 'icon': Icons.construction, 'key': 'HADDAD'},
    {'nom_ar': 'سائق', 'nom_fr': 'Chauffeur', 'icon': Icons.drive_eta, 'key': 'SAIQ'},
    {'nom_ar': 'حارس', 'nom_fr': 'Gardien', 'icon': Icons.security_rounded, 'key': 'HARIS'},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final results = await Future.wait([
        SessionManager.getUser(),
        _ouvrierRepository.getPlusNotes(limit: 5),
      ]);
      if (mounted) {
        setState(() {
          _user = results[0] as UserModel?;
          _plusNotes = results[1] as List<OuvrierModel>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    final isAr = widget.langue == "AR";
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isAr ? 'تسجيل الخروج' : 'Déconnexion'),
        content: Text(isAr ? 'هل أنت متأكد؟' : 'Êtes-vous sûr?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(isAr ? 'إلغاء' : 'Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(isAr ? 'خروج' : 'Déconnexion',
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await _authRepository.logout();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const Connexion()),
              (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = widget.langue == "AR";

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _currentIndex == 2
            ? _buildProfil(isAr)
            : SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded, color: primary, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  isAr ? 'نواكشوط، موريتانيا' : 'Nouakchott, Mauritanie',
                                  style: const TextStyle(fontSize: 13, color: primary, fontWeight: FontWeight.w600),
                                ),
                                const Icon(Icons.keyboard_arrow_down_rounded, color: primary, size: 18),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isAr
                                  ? 'أهلاً، ${_user?.nom ?? ''} 👋'
                                  : 'Bonjour, ${_user?.nom ?? ''} 👋',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3A5F),
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            Container(
                              width: 46, height: 46,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F4F8),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.notifications_outlined,
                                  color: Color(0xFF1E3A5F), size: 24),
                            ),
                            Positioned(
                              top: 10, right: 10,
                              child: Container(
                                width: 8, height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Search Bar ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ListeOuvriers(langue: widget.langue))),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F4F8),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search_rounded, color: Color(0xFF9AA5B4), size: 22),
                            const SizedBox(width: 10),
                            Text(
                              isAr ? 'ابحث عن خدمة أو عامل...' : 'Rechercher un service...',
                              style: const TextStyle(color: Color(0xFF9AA5B4), fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Categories ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(isAr ? 'التصنيفات' : 'Catégories',
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F))),
                        GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => ListeOuvriers(langue: widget.langue))),
                          child: Text(isAr ? 'عرض الكل' : 'Voir tout',
                              style: const TextStyle(fontSize: 13, color: primary, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    height: 95,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => ListeOuvriers(
                                langue: widget.langue,
                                categorie: cat['key'],
                              ))),
                          child: Container(
                            width: 72,
                            margin: EdgeInsets.only(
                              left: isAr ? 0 : 12,
                              right: isAr ? 12 : 0,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 58, height: 58,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F4F8),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(cat['icon'], color: primary, size: 26),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  isAr ? cat['nom_ar'] : cat['nom_fr'],
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF1E3A5F)),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 28),
                  Container(height: 8, color: const Color(0xFFF1F4F8)),
                  const SizedBox(height: 24),

                  // ── الأكثر تقييماً ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(isAr ? 'الأكثر تقييماً' : 'Les mieux notés',
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F))),
                        GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => ListeOuvriers(langue: widget.langue))),
                          child: Text(isAr ? 'عرض الكل' : 'Voir tout',
                              style: const TextStyle(fontSize: 13, color: primary, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Loading / Error / Data ──
                  if (_isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(color: primary),
                      ),
                    )
                  else if (_error != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            const Icon(Icons.wifi_off_rounded, size: 48, color: Color(0xFF9AA5B4)),
                            const SizedBox(height: 12),
                            Text(isAr ? 'حدث خطأ' : 'Une erreur est survenue',
                                style: const TextStyle(color: Color(0xFF9AA5B4))),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _loadData,
                              style: ElevatedButton.styleFrom(backgroundColor: primary),
                              child: Text(isAr ? 'إعادة المحاولة' : 'Réessayer',
                                  style: const TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (_plusNotes.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Text(isAr ? 'لا يوجد عمال متاحون' : 'Aucun ouvrier disponible',
                              style: const TextStyle(color: Color(0xFF9AA5B4))),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _plusNotes.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final o = _plusNotes[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (_) => ProfilOuvrier(
                                  langue: widget.langue,
                                  ouvrier: o,
                                ))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Row(
                                children: [
                                  Container(
                                    width: 62, height: 62,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F4F8),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(Icons.person_rounded, color: primary, size: 32),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(o.nomComplet,
                                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F))),
                                        const SizedBox(height: 3),
                                      Text(AppConstants.traduireCategorie(o.categorie, isAr: isAr)),
                                           const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                                            const SizedBox(width: 3),
                                            Text('${o.noteMoyenne}  (${o.nombreAvis})',
                                                style: const TextStyle(fontSize: 12, color: Color(0xFF1E3A5F), fontWeight: FontWeight.w600)),
                                            const SizedBox(width: 10),
                                            const Icon(Icons.location_on_rounded, color: Color(0xFF9AA5B4), size: 13),
                                            const SizedBox(width: 2),
                                            Text(o.ville,
                                                style: const TextStyle(fontSize: 12, color: Color(0xFF9AA5B4))),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('${o.prixJournalier.toInt()} MRU',
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primary)),
                                      Text(isAr ? '/يوم' : '/jour',
                                          style: const TextStyle(fontSize: 11, color: Color(0xFF9AA5B4))),
                                      const SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () => Navigator.push(context,
                                            MaterialPageRoute(builder: (_) => ProfilOuvrier(
                                              langue: widget.langue,
                                              ouvrier: o,
                                            ))),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: o.estDisponible ? primary : Colors.grey,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            isAr ? 'احجز' : 'Réserver',
                                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),

        // ── Bottom Navigation ──
        bottomNavigationBar: Builder(
          builder: (context) {
            final isAr = widget.langue == "AR";
            return BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (i) {
                if (i == 1) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => MesCommandes(langue: widget.langue)));
                } else {
                  setState(() => _currentIndex = i);
                }
              },
              selectedItemColor: primary,
              unselectedItemColor: const Color(0xFF9AA5B4),
              type: BottomNavigationBarType.fixed,
              elevation: 8,
              backgroundColor: Colors.white,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined),
                  activeIcon: const Icon(Icons.home_rounded),
                  label: isAr ? 'الرئيسية' : 'Accueil',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.list_alt_outlined),
                  activeIcon: const Icon(Icons.list_alt_rounded),
                  label: isAr ? 'طلباتي' : 'Demandes',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person_outline_rounded),
                  activeIcon: const Icon(Icons.person_rounded),
                  label: isAr ? 'حسابي' : 'Profil',
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── Profil ──
  Widget _buildProfil(bool isAr) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              width: 84, height: 84,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4F8),
                shape: BoxShape.circle,
                border: Border.all(color: primary, width: 3),
              ),
              child: const Icon(Icons.person_rounded, size: 46, color: primary),
            ),
            const SizedBox(height: 12),
            Text(
              _user?.nomComplet ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
            ),
            const SizedBox(height: 4),
            Text(
              _user?.telephone ?? '',
              style: const TextStyle(fontSize: 14, color: Color(0xFF9AA5B4)),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildProfilStat(isAr ? 'طلباتي' : 'Demandes', '—'),
                  _buildProfilStat(isAr ? 'المدينة' : 'Ville', _user?.ville ?? '—'),
                  _buildProfilStat(isAr ? 'تقييماتي' : 'Avis', '—'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(height: 8, color: const Color(0xFFF1F4F8)),
            _buildProfilOption(Icons.person_outline_rounded, isAr ? 'معلوماتي' : 'Mes informations', isAr),
            _buildProfilOption(Icons.notifications_outlined, isAr ? 'الإشعارات' : 'Notifications', isAr),
            _buildProfilOption(Icons.help_outline_rounded, isAr ? 'المساعدة' : 'Aide', isAr),
            _buildProfilOption(Icons.logout_rounded, isAr ? 'تسجيل الخروج' : 'Déconnexion', isAr, isRed: true),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilStat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primary)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF9AA5B4)), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildProfilOption(IconData icon, String label, bool isAr, {bool isRed = false}) {
    return ListTile(
      leading: Icon(icon, color: isRed ? Colors.red : const Color(0xFF1E3A5F)),
      title: Text(label,
          style: TextStyle(fontSize: 15, color: isRed ? Colors.red : const Color(0xFF1E3A5F), fontWeight: FontWeight.w500)),
      trailing: Icon(
        isAr ? Icons.arrow_back_ios_new_rounded : Icons.arrow_forward_ios_rounded,
        size: 14, color: Colors.grey.shade400,
      ),
      onTap: isRed ? _logout : null,
    );
  }
}