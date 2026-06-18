import 'package:flutter/material.dart';
import 'package:travvite_1/features/auth/connexion.dart';
import '../../data/modeles/reservation_model.dart';
import '../../data/modeles/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/ouvrier_repository.dart';
import '../../data/repositories/reservation_repository.dart';
import '../../data/services/session_manager.dart';

class TableauOuvrier extends StatefulWidget {
  final String langue;
  const TableauOuvrier({super.key, required this.langue});

  @override
  State<TableauOuvrier> createState() => _TableauOuvrierState();
}

class _TableauOuvrierState extends State<TableauOuvrier> {
  int _currentIndex = 0;
  bool _disponible = true;
  static const primary = Color(0xFF2B4C7E);

  final _reservationRepository = ReservationRepository();
  final _ouvrierRepository = OuvrierRepository();
  final _authRepository = AuthRepository();

  UserModel? _user;
  List<ReservationModel> _nouvelles = [];
  List<ReservationModel> _enCours = [];
  List<ReservationModel> _terminees = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        SessionManager.getUser(),
        _reservationRepository.getMesReservationsOuvrier(),
      ]);

      final user = results[0] as UserModel?;
      final reservations = results[1] as List<ReservationModel>;

      if (mounted) {
        setState(() {
          _user = user;
          _disponible = true;
          _nouvelles = reservations.where((r) => r.statut == StatutReservation.EN_ATTENTE).toList();
          _enCours = reservations.where((r) =>
          r.statut == StatutReservation.ACCEPTE ||
              r.statut == StatutReservation.EN_COURS
          ).toList();
          _terminees = reservations.where((r) => r.statut == StatutReservation.TERMINE).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleDisponibilite() async {
    try {
      final id = _user?.id ?? 0;
      if (id == 0) return;
      await _ouvrierRepository.changerDisponibilite(id, !_disponible);
      setState(() => _disponible = !_disponible);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(widget.langue == "AR" ? 'حدث خطأ' : 'Une erreur est survenue'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  Future<void> _accepterReservation(ReservationModel r) async {
    try {
      await _reservationRepository.accepter(r.id);
      _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(widget.langue == "AR" ? 'حدث خطأ' : 'Une erreur est survenue'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  Future<void> _refuserReservation(ReservationModel r) async {
    try {
      await _reservationRepository.refuser(r.id);
      _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(widget.langue == "AR" ? 'حدث خطأ' : 'Une erreur est survenue'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  Future<void> _terminerReservation(ReservationModel r) async {
    try {
      await _reservationRepository.terminer(r.id);
      _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(widget.langue == "AR" ? 'حدث خطأ' : 'Une erreur est survenue'),
          backgroundColor: Colors.red,
        ));
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
          TextButton(onPressed: () => Navigator.pop(context, false),
              child: Text(isAr ? 'إلغاء' : 'Annuler')),
          TextButton(onPressed: () => Navigator.pop(context, true),
              child: Text(isAr ? 'خروج' : 'Déconnexion',
                  style: const TextStyle(color: Colors.red))),
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
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: primary))
            : RefreshIndicator(
          onRefresh: _loadData,
          child: IndexedStack(
            index: _currentIndex,
            children: [
              _buildHome(isAr),
              _buildCommandes(isAr),
              _buildProfil(isAr),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          selectedItemColor: primary,
          unselectedItemColor: Colors.grey.shade400,
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
              label: isAr ? 'طلباتي' : 'Mes tâches',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline_rounded),
              activeIcon: const Icon(Icons.person_rounded),
              label: isAr ? 'ملفي' : 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  // ── الرئيسية ──
  Widget _buildHome(bool isAr) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header ──
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: const BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr ? 'أهلاً 👷' : 'Bonjour 👷',
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          Text(
                            _user?.nomComplet ?? '',
                            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: _toggleDisponibilite,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: _disponible ? Colors.green : Colors.grey.shade600,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Container(width: 8, height: 8,
                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                              const SizedBox(width: 8),
                              Text(
                                _disponible ? (isAr ? 'متاح' : 'Disponible') : (isAr ? 'مشغول' : 'Occupé'),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildStatCard(
                        isAr ? 'طلبات جديدة' : 'Nouvelles',
                        '${_nouvelles.length}',
                        Icons.notifications_outlined,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        isAr ? 'جارية' : 'En cours',
                        '${_enCours.length}',
                        Icons.work_outline_rounded,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        isAr ? 'منجزة' : 'Terminées',
                        '${_terminees.length}',
                        Icons.check_circle_outline_rounded,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── طلبات جديدة ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isAr ? 'طلبات جديدة 🔔' : 'Nouvelles demandes 🔔',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
                  ),
                  if (_nouvelles.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                      child: Text('${_nouvelles.length}',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            if (_nouvelles.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    isAr ? 'لا توجد طلبات جديدة' : 'Aucune nouvelle demande',
                    style: const TextStyle(color: Color(0xFF9AA5B4)),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _nouvelles.length,
                itemBuilder: (context, index) {
                  final r = _nouvelles[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFF1F4F8)),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(r.clientNom,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F))),
                            Text('${r.prixTotal.toInt()} MRU',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(children: [
                          const Icon(Icons.work_outline_rounded, size: 14, color: Color(0xFF9AA5B4)),
                          const SizedBox(width: 6),
                          Expanded(child: Text(r.description,
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13, color: Color(0xFF9AA5B4)))),
                        ]),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF9AA5B4)),
                          const SizedBox(width: 6),
                          Text(r.adresse, style: const TextStyle(fontSize: 13, color: Color(0xFF9AA5B4))),
                        ]),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.calendar_today_rounded, size: 14, color: Color(0xFF9AA5B4)),
                          const SizedBox(width: 6),
                          Text('${r.dateService.day}/${r.dateService.month}/${r.dateService.year} ${r.heureService}',
                              style: const TextStyle(fontSize: 13, color: Color(0xFF9AA5B4))),
                        ]),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _refuserReservation(r),
                                child: Container(
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F4F8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(child: Text(isAr ? 'رفض' : 'Refuser',
                                      style: const TextStyle(color: Color(0xFF9AA5B4), fontWeight: FontWeight.bold))),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _accepterReservation(r),
                                child: Container(
                                  height: 42,
                                  decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
                                  child: Center(child: Text(isAr ? 'قبول' : 'Accepter',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

            const SizedBox(height: 24),

            // ── طلباتي الحالية ──
            if (_enCours.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  isAr ? 'طلباتي الحالية' : 'Tâches en cours',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
                ),
              ),
              const SizedBox(height: 14),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _enCours.length,
                itemBuilder: (context, index) {
                  final r = _enCours[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: primary.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 46, height: 46,
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.handyman_rounded, color: primary, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.description,
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F))),
                              const SizedBox(height: 4),
                              Text(r.clientNom,
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF9AA5B4))),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _terminerReservation(r),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isAr ? 'إنهاء' : 'Terminer',
                              style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ── طلباتي ──
  Widget _buildCommandes(bool isAr) {
    final toutes = [..._nouvelles, ..._enCours, ..._terminees];

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Text(
              isAr ? 'كل طلباتي' : 'Toutes mes tâches',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
            ),
          ),
          Expanded(
            child: toutes.isEmpty
                ? Center(child: Text(isAr ? 'لا توجد طلبات' : 'Aucune tâche',
                style: const TextStyle(color: Color(0xFF9AA5B4))))
                : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: toutes.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F4F8)),
              itemBuilder: (context, index) {
                final r = toutes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(color: const Color(0xFFF1F4F8), borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.handyman_rounded, color: primary, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.description,
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F))),
                            const SizedBox(height: 4),
                            Text(r.clientNom,
                                style: const TextStyle(fontSize: 13, color: Color(0xFF9AA5B4))),
                          ],
                        ),
                      ),
                      Text('${r.prixTotal.toInt()} MRU',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primary)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── ملفي ──
  Widget _buildProfil(bool isAr) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4F8),
                shape: BoxShape.circle,
                border: Border.all(color: primary, width: 3),
              ),
              child: const Icon(Icons.person_rounded, size: 50, color: primary),
            ),
            const SizedBox(height: 14),
            Text(
              _user?.nomComplet ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
            ),
            const SizedBox(height: 4),
            Text(
              _user?.telephone ?? '',
              style: const TextStyle(fontSize: 14, color: Color(0xFF9AA5B4)),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildProfilStat(isAr ? 'الطلبات' : 'Tâches', '${_toutes.length}'),
                  _buildProfilStat(isAr ? 'المنجزة' : 'Terminées', '${_terminees.length}'),
                  _buildProfilStat(isAr ? 'الجارية' : 'En cours', '${_enCours.length}'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(height: 8, color: const Color(0xFFF1F4F8)),
            _buildProfilOption(Icons.person_outline_rounded, isAr ? 'معلوماتي' : 'Mes informations', isAr),
            _buildProfilOption(Icons.star_outline_rounded, isAr ? 'تقييماتي' : 'Mes avis', isAr),
            _buildProfilOption(Icons.history_rounded, isAr ? 'سجل العمل' : 'Historique', isAr),
            _buildProfilOption(Icons.settings_outlined, isAr ? 'الإعدادات' : 'Paramètres', isAr),
            _buildProfilOption(Icons.logout_rounded, isAr ? 'تسجيل الخروج' : 'Déconnexion', isAr, isRed: true),
          ],
        ),
      ),
    );
  }

  List<ReservationModel> get _toutes => [..._nouvelles, ..._enCours, ..._terminees];

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilStat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF9AA5B4))),
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