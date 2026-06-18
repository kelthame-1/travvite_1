import 'package:flutter/material.dart';
import 'package:travvite_1/features/client/profil_ouvrier.dart';
import 'package:travvite_1/features/client/filtrage.dart';
import '../../data/modeles/ouvrier_model.dart';
import '../../data/repositories/ouvrier_repository.dart';
import '../../Core/constantes/app_constantes.dart';

class ListeOuvriers extends StatefulWidget {
  final String langue;
  final String? categorie;
  const ListeOuvriers({super.key, required this.langue, this.categorie});

  @override
  State<ListeOuvriers> createState() => _ListeOuvriersState();
}

class _ListeOuvriersState extends State<ListeOuvriers> {
  static const primary = Color(0xFF2B4C7E);
  final _ouvrierRepository = OuvrierRepository();

  List<OuvrierModel> _ouvriers = [];
  List<OuvrierModel> _ouvriersAffiches = [];
  bool _isLoading = true;
  String? _error;
  int _filtreSelectionne = 0;

  @override
  void initState() {
    super.initState();
    _loadOuvriers();
  }

  Future<void> _loadOuvriers({
    String? categorie,
    String? nom,
    double? prixMin,
    double? prixMax,
    String? genre,
    String? langue,
    String? disponibilite,
    bool? accepteEnfants,
    String? nationalite,
    String? niveauEtude,
  }) async {
    setState(() { _isLoading = true; _error = null; });
    try {
      List<OuvrierModel> result;
      if (categorie != null || nom != null || prixMin != null ||
          prixMax != null || genre != null || langue != null ||
          disponibilite != null || accepteEnfants != null ||
          nationalite != null || niveauEtude != null) {
        result = await _ouvrierRepository.filtrer(
          categorie: categorie ?? widget.categorie,
          nom: nom,
          prixMin: prixMin,
          prixMax: prixMax,
          genre: genre,
          langue: langue,
          disponibilite: disponibilite,
          accepteEnfants: accepteEnfants,
          nationalite: nationalite,
          niveauEtude: niveauEtude,
        );
      } else {
        result = await _ouvrierRepository.filtrer(
          categorie: widget.categorie,
        );
      }

      if (mounted) {
        setState(() {
          _ouvriers = result;
          _appliquerFiltre();
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

  void _appliquerFiltre() {
    List<OuvrierModel> liste = List.from(_ouvriers);
    if (_filtreSelectionne == 1) {
      liste.sort((a, b) => b.noteMoyenne.compareTo(a.noteMoyenne));
    } else if (_filtreSelectionne == 2) {
      liste.sort((a, b) => a.prixJournalier.compareTo(b.prixJournalier));
    } else if (_filtreSelectionne == 3) {
      liste = liste.where((o) => o.estDisponible).toList();
    }
    _ouvriersAffiches = liste;
  }

  @override
  Widget build(BuildContext context) {
    final isAr = widget.langue == "AR";

    final filtres = isAr
        ? ['الكل', 'الأعلى تقييماً', 'الأقل سعراً', 'متاح الآن']
        : ['Tous', 'Mieux notés', 'Prix bas', 'Disponible'];

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
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.categorie ?? (isAr ? 'كل العمال' : 'Tous les ouvriers'),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
                          ),
                          Text(
                            isAr
                                ? '${_ouvriersAffiches.length} عامل متاح'
                                : '${_ouvriersAffiches.length} pros disponibles',
                            style: const TextStyle(fontSize: 13, color: Color(0xFF9AA5B4)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Search + Filtre ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F4F8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search_rounded, color: Color(0xFF9AA5B4), size: 20),
                            const SizedBox(width: 10),
                            Text(
                              isAr ? 'ابحث في النتائج...' : 'Rechercher...',
                              style: const TextStyle(color: Color(0xFF9AA5B4), fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Filtrage(langue: widget.langue)),
                        );
                        if (result != null && result is Map) {
                          _loadOuvriers(
                            categorie: result['categorie'],
                            genre: result['genre'],
                            langue: result['langue'],
                            disponibilite: result['disponibilite'],
                            accepteEnfants: result['accepteEnfants'],
                            nationalite: result['nationalite'],
                            niveauEtude: result['niveauEtude'],
                            prixMin: result['prixMin'],
                            prixMax: result['prixMax'],
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ── فلتر ──
              SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filtres.length,
                  itemBuilder: (context, index) {
                    final selected = _filtreSelectionne == index;
                    return GestureDetector(
                      onTap: () => setState(() {
                        _filtreSelectionne = index;
                        _appliquerFiltre();
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected ? primary : const Color(0xFFF1F4F8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          filtres[index],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selected ? Colors.white : const Color(0xFF9AA5B4),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // ── قائمة العمال ──
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
                        onPressed: _loadOuvriers,
                        style: ElevatedButton.styleFrom(backgroundColor: primary),
                        child: Text(isAr ? 'إعادة المحاولة' : 'Réessayer',
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                )
                    : _ouvriersAffiches.isEmpty
                    ? Center(
                  child: Text(
                    isAr ? 'لا يوجد عمال متاحون' : 'Aucun ouvrier disponible',
                    style: const TextStyle(color: Color(0xFF9AA5B4)),
                  ),
                )
                    : RefreshIndicator(
                  onRefresh: _loadOuvriers,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _ouvriersAffiches.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F4F8)),
                    itemBuilder: (context, index) {
                      final o = _ouvriersAffiches[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ProfilOuvrier(
                              langue: widget.langue,
                              ouvrier: o,
                            ))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 64, height: 64,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F4F8),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: const Icon(Icons.person_rounded, color: primary, size: 34),
                                  ),
                                  Positioned(
                                    bottom: 4, right: 4,
                                    child: Container(
                                      width: 12, height: 12,
                                      decoration: BoxDecoration(
                                        color: o.estDisponible ? Colors.green : Colors.grey,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(o.nomComplet,
                                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F))),
                                        const SizedBox(width: 6),
                                        if (o.noteMoyenne >= 4.5)
                                          const Icon(Icons.verified_rounded, color: primary, size: 16),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                            Text(AppConstants.traduireCategorie(o.categorie, isAr: isAr)),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                                        const SizedBox(width: 3),
                                        Text('${o.noteMoyenne}',
                                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F))),
                                        Text(' (${o.nombreAvis})',
                                            style: const TextStyle(fontSize: 12, color: Color(0xFF9AA5B4))),
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
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primary)),
                                  Text(isAr ? '/يوم' : '/jour',
                                      style: const TextStyle(fontSize: 11, color: Color(0xFF9AA5B4))),
                                  const SizedBox(height: 6),
                                  Text(
                                    o.estDisponible
                                        ? (isAr ? '● متاح' : '● Dispo')
                                        : (isAr ? '● مشغول' : '● Occupé'),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: o.estDisponible ? Colors.green : Colors.grey,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
