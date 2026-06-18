import 'package:flutter/material.dart';
import 'package:travvite_1/features/client/reservation.dart';
import '../../data/modeles/ouvrier_model.dart';
import '../../data/modeles/evaluation_model.dart';
import '../../data/repositories/evaluation_repository.dart';
import '../../Core/constantes/app_constantes.dart';

class ProfilOuvrier extends StatefulWidget {
  final String langue;
  final OuvrierModel ouvrier;

  const ProfilOuvrier({
    super.key,
    required this.langue,
    required this.ouvrier,
  });

  @override
  State<ProfilOuvrier> createState() => _ProfilOuvrierState();
}

class _ProfilOuvrierState extends State<ProfilOuvrier> {
  static const primary = Color(0xFF2B4C7E);
  final _evaluationRepository = EvaluationRepository();

  List<EvaluationModel> _evaluations = [];
  bool _isLoadingEvals = true;

  @override
  void initState() {
    super.initState();
    _loadEvaluations();
  }

  Future<void> _loadEvaluations() async {
    try {
      final evals = await _evaluationRepository.getByOuvrier(widget.ouvrier.id);
      if (mounted) setState(() { _evaluations = evals; _isLoadingEvals = false; });
    } catch (_) {
      if (mounted) setState(() => _isLoadingEvals = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = widget.langue == "AR";
    final o = widget.ouvrier;
    final size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Header ──
                  Container(
                    width: double.infinity,
                    color: const Color(0xFFF1F4F8),
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 28),
                    child: Column(
                      children: [
                        Hero(
                          tag: 'ouvrier_${o.id}',
                          child: Container(
                            width: size.width * 0.23,
                            height: size.width * 0.23,
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: const Icon(Icons.person_rounded, size: 50, color: primary),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              o.nomComplet,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
                            ),
                            if (o.noteMoyenne >= 4.5) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.verified_rounded, color: primary, size: 20),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(o.categorie,
                            style: const TextStyle(fontSize: 15, color: Color(0xFF9AA5B4))),
                        const SizedBox(height: 10),
                        // Stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStat(Icons.star_rounded, Colors.amber, '${o.noteMoyenne}', isAr ? 'تقييم' : 'Note'),
                            const SizedBox(width: 24),
                            _buildStat(Icons.reviews_rounded, primary, '${o.nombreAvis}', isAr ? 'رأي' : 'Avis'),
                            const SizedBox(width: 24),
                            _buildStat(Icons.check_circle_rounded, Colors.green, '${o.tachesTerminees}', isAr ? 'مهمة' : 'Tâches'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ── السعر + الحالة ──
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F4F8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAr ? 'السعر / يوم' : 'Prix / jour',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF9AA5B4)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${o.prixJournalier.toInt()} MRU',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primary),
                            ),
                            if (o.prixMensuel > 0)
                              Text(
                                '${o.prixMensuel.toInt()} MRU / ${isAr ? 'شهر' : 'mois'}',
                                style: const TextStyle(fontSize: 12, color: Color(0xFF9AA5B4)),
                              ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: o.estDisponible
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8, height: 8,
                                decoration: BoxDecoration(
                                  color: o.estDisponible ? Colors.green : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                o.estDisponible
                                    ? (isAr ? 'متاح الآن' : 'Disponible')
                                    : (isAr ? 'مشغول' : 'Occupé'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── معلومات العامل ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      isAr ? 'عن العامل' : 'À propos',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 10, runSpacing: 10,
                      children: [
                        _buildInfo(Icons.location_on_rounded, o.ville),
                        _buildInfo(Icons.schedule_rounded, AppConstants.traduireDisponibilite(o.disponibilite, isAr: isAr)),
                        _buildInfo(Icons.language_rounded, AppConstants.traduireLangue(o.langue, isAr: isAr)),
                        _buildInfo(Icons.school_rounded, AppConstants.traduireNiveauEtude(o.niveauEtude, isAr: isAr)),
                        _buildInfo(Icons.flag_rounded, AppConstants.traduireNationalite(o.nationalite, isAr: isAr)),
                        if (o.accepteEnfants)
                          _buildInfo(Icons.child_care_rounded, isAr ? 'يقبل أطفال' : 'Accepte enfants'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── آراء العملاء ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      isAr ? 'آراء العملاء' : 'Avis clients',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (_isLoadingEvals)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(color: primary),
                    ))
                  else if (_evaluations.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        isAr ? 'لا يوجد تقييمات بعد' : 'Aucun avis pour le moment',
                        style: const TextStyle(color: Color(0xFF9AA5B4)),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _evaluations.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final eval = _evaluations[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(eval.clientNom,
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F))),
                                  Row(
                                    children: List.generate(5, (i) => Icon(
                                      Icons.star_rounded,
                                      size: 14,
                                      color: i < eval.note ? Colors.amber : Colors.grey.shade300,
                                    )),
                                  ),
                                ],
                              ),
                              if (eval.commentaire != null) ...[
                                const SizedBox(height: 6),
                                Text(eval.commentaire!,
                                    style: const TextStyle(fontSize: 13, color: Color(0xFF9AA5B4))),
                              ],
                              if (eval.tagsList.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  children: eval.tagsList.map((tag) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: primary.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(tag, style: const TextStyle(fontSize: 11, color: primary)),
                                  )).toList(),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 120),
                ],
              ),
            ),

            // ── Back Button ──
            Positioned(
              top: 16,
              left: isAr ? null : 20,
              right: isAr ? 20 : null,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEAEAEA)),
                    ),
                    child: Icon(
                      isAr ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                      size: 18, color: primary,
                    ),
                  ),
                ),
              ),
            ),

            // ── Reserve Button ──
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                color: Colors.white,
                child: SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: o.estDisponible
                        ? () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => Reservation(
                          langue: widget.langue,
                          ouvrier: o,
                        )))
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      o.estDisponible
                          ? (isAr ? 'احجز الآن' : 'Réserver maintenant')
                          : (isAr ? 'غير متاح' : 'Non disponible'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, Color color, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F))),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF9AA5B4))),
      ],
    );
  }

  Widget _buildInfo(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: primary),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF1E3A5F))),
        ],
      ),
    );
  }
}