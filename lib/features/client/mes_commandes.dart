import 'package:flutter/material.dart';
import 'package:travvite_1/features/client/evaluation.dart';
import '../../core/constantes/app_constantes.dart';
import '../../data/modeles/reservation_model.dart';
import '../../data/repositories/reservation_repository.dart';

class MesCommandes extends StatefulWidget {
  final String langue;
  const MesCommandes({super.key, required this.langue});

  @override
  State<MesCommandes> createState() => _MesCommandesState();
}

class _MesCommandesState extends State<MesCommandes>
    with SingleTickerProviderStateMixin {
  static const primary = Color(0xFF2B4C7E);
  late TabController _tabController;
  final _reservationRepository = ReservationRepository();

  List<ReservationModel> _enCours = [];
  List<ReservationModel> _terminees = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadReservations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadReservations() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final reservations = await _reservationRepository.getMesReservationsClient();
      if (mounted) {
        setState(() {
          _enCours = reservations.where((r) =>
          r.statut == StatutReservation.EN_ATTENTE ||
              r.statut == StatutReservation.ACCEPTE ||
              r.statut == StatutReservation.EN_COURS
          ).toList();
          _terminees = reservations.where((r) =>
          r.statut == StatutReservation.TERMINE ||
              r.statut == StatutReservation.REFUSE ||
              r.statut == StatutReservation.ANNULE
          ).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _annulerReservation(ReservationModel r) async {
    final isAr = widget.langue == "AR";
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isAr ? 'إلغاء الطلب' : 'Annuler la demande'),
        content: Text(isAr ? 'هل أنت متأكد؟' : 'Êtes-vous sûr?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
              child: Text(isAr ? 'لا' : 'Non')),
          TextButton(onPressed: () => Navigator.pop(context, true),
              child: Text(isAr ? 'نعم' : 'Oui', style: const TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _reservationRepository.annuler(r.id);
        _loadReservations();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(isAr ? 'حدث خطأ' : 'Une erreur est survenue'),
            backgroundColor: Colors.red,
          ));
        }
      }
    }
  }

  Color _getStatutColor(StatutReservation statut) {
    switch (statut) {
      case StatutReservation.EN_ATTENTE: return Colors.orange;
      case StatutReservation.ACCEPTE: return Colors.green;
      case StatutReservation.EN_COURS: return Colors.blue;
      case StatutReservation.TERMINE: return Colors.grey;
      case StatutReservation.REFUSE: return Colors.red;
      case StatutReservation.ANNULE: return Colors.grey;
    }
  }

  String _getStatutLabel(StatutReservation statut, bool isAr) {
    final map = AppConstants.statutsReservation;
    return map[statut.name] ?? statut.name;
  }

  @override
  Widget build(BuildContext context) {
    final isAr = widget.langue == "AR";

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 42, height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F4F8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isAr ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_rounded,
                          size: 18, color: primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      isAr ? 'طلباتي' : 'Mes demandes',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── TabBar ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F4F8),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
                    labelColor: Colors.white,
                    unselectedLabelColor: const Color(0xFF9AA5B4),
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(text: isAr ? 'جارية 🟢' : 'En cours 🟢'),
                      Tab(text: isAr ? 'منتهية ✅' : 'Terminées ✅'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Content ──
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: primary))
                    : _error != null
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off_rounded, size: 48, color: Color(0xFF9AA5B4)),
                      const SizedBox(height: 12),
                      Text(isAr ? 'حدث خطأ' : 'Une erreur est survenue',
                          style: const TextStyle(color: Color(0xFF9AA5B4))),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _loadReservations,
                        style: ElevatedButton.styleFrom(backgroundColor: primary),
                        child: Text(isAr ? 'إعادة المحاولة' : 'Réessayer',
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                )
                    : RefreshIndicator(
                  onRefresh: _loadReservations,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildListe(_enCours, isAr, false),
                      _buildListe(_terminees, isAr, true),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListe(List<ReservationModel> reservations, bool isAr, bool termine) {
    if (reservations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list_alt_rounded, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(isAr ? 'لا يوجد طلبات' : 'Aucune demande',
                style: const TextStyle(fontSize: 16, color: Color(0xFF9AA5B4))),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: reservations.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F4F8)),
      itemBuilder: (context, index) {
        final r = reservations[index];
        final statutColor = _getStatutColor(r.statut);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 54, height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F4F8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.person_rounded, color: primary, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.ouvrierNom,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F))),
                        const SizedBox(height: 3),
                        Text(r.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13, color: Color(0xFF9AA5B4))),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded, size: 13, color: Color(0xFF9AA5B4)),
                            const SizedBox(width: 4),
                            Text(
                              '${r.dateService.day}/${r.dateService.month}/${r.dateService.year}',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF9AA5B4)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${r.prixTotal.toInt()} MRU',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primary)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statutColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getStatutLabel(r.statut, isAr),
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statutColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // ── أزرار ──
              const SizedBox(height: 12),
              if (!termine && r.isPending)
                Align(
                  alignment: isAr ? Alignment.centerLeft : Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => _annulerReservation(r),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isAr ? 'إلغاء الطلب' : 'Annuler',
                        style: const TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

              if (termine && r.isFinished)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => Evaluation(
                            langue: widget.langue,
                            reservationId: r.id,
                            ouvrierId: r.ouvrierId,
                            ouvrierNom: r.ouvrierNom,
                          ))),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isAr ? '⭐ قيّم' : '⭐ Évaluer',
                          style: const TextStyle(fontSize: 12, color: primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}