import 'package:flutter/material.dart';
import 'package:travvite_1/features/client/mes_commandes.dart';
import '../../core/errors/exceptions.dart';
import '../../data/modeles/ouvrier_model.dart';
import '../../data/repositories/reservation_repository.dart';

class Reservation extends StatefulWidget {
  final String langue;
  final OuvrierModel ouvrier;
  const Reservation({super.key, required this.langue, required this.ouvrier});

  @override
  State<Reservation> createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  static const primary = Color(0xFF2B4C7E);
  final _reservationRepository = ReservationRepository();
  final _descController = TextEditingController();
  final _adresseController = TextEditingController();

  int _heures = 2;
  DateTime _dateSelectionnee = DateTime.now().add(const Duration(days: 1));
  String _heureSelectionnee = '10:00';
  bool _isLoading = false;

  final List<String> _heuresDisponibles = [
    '08:00', '09:00', '10:00', '11:00',
    '12:00', '14:00', '15:00', '16:00', '17:00',
  ];

  @override
  void dispose() {
    _descController.dispose();
    _adresseController.dispose();
    super.dispose();
  }

  Future<void> _confirmerReservation() async {
    final isAr = widget.langue == "AR";

    if (_descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isAr ? 'الرجاء وصف المشكلة' : 'Veuillez décrire votre besoin'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (_adresseController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isAr ? 'الرجاء إدخال العنوان' : 'Veuillez entrer l\'adresse'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _reservationRepository.creerReservation(
        ouvrierId: widget.ouvrier.id,
        description: _descController.text.trim(),
        dateService: _dateSelectionnee,
        heureService: _heureSelectionnee,
        nbHeures: _heures,
        adresse: _adresseController.text.trim(),
      );

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              isAr ? '✅ تم الحجز!' : '✅ Réservation confirmée!',
              style: const TextStyle(color: Color(0xFF1E3A5F), fontWeight: FontWeight.bold),
            ),
            content: Text(
              isAr ? 'سيتم التواصل معك قريباً' : 'Vous serez contacté bientôt',
              style: const TextStyle(color: Color(0xFF9AA5B4)),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => MesCommandes(langue: widget.langue)),
                        (route) => route.isFirst,
                  );
                },
                child: Text(isAr ? 'عرض طلباتي' : 'Voir mes demandes',
                    style: const TextStyle(color: primary)),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String msg = widget.langue == "AR" ? 'حدث خطأ، حاول مجدداً' : 'Une erreur est survenue';
        if (e is NetworkException) msg = widget.langue == "AR" ? 'لا يوجد اتصال' : 'Pas de connexion';
        if (e is SessionException) msg = widget.langue == "AR" ? 'جلسة منتهية' : 'Session expirée';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red,
        ));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = widget.langue == "AR";
    final o = widget.ouvrier;
    final total = (o.prixJournalier * _heures).toInt();

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Header ──
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
                    color: const Color(0xFFF8FAFC),
                    child: Row(
                      children: [
                        Container(
                          width: 52, height: 52,
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.person_rounded, color: primary, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(o.nomComplet,
                                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F))),
                              const SizedBox(height: 3),
                              Text(o.categorie,
                                  style: const TextStyle(fontSize: 13, color: Color(0xFF9AA5B4))),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${o.prixJournalier.toInt()} MRU',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary)),
                            Text(isAr ? '/يوم' : '/jour',
                                style: const TextStyle(fontSize: 12, color: Color(0xFF9AA5B4))),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(height: 8, color: const Color(0xFFF1F4F8)),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // ── وصف المشكلة ──
                        _buildSectionTitle(isAr ? 'وصف المشكلة' : 'Décrivez votre besoin'),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE0E7F0)),
                          ),
                          child: TextField(
                            controller: _descController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: isAr
                                  ? 'مثال: أريد تركيب باب خشبي في غرفة النوم...'
                                  : 'Ex: Je veux installer une porte en bois...',
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── التاريخ ──
                        _buildSectionTitle(isAr ? 'اختر التاريخ' : 'Choisir la date'),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _dateSelectionnee,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 30)),
                              builder: (context, child) => Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(primary: primary),
                                ),
                                child: child!,
                              ),
                            );
                            if (picked != null) setState(() => _dateSelectionnee = picked);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE0E7F0)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_rounded, color: primary, size: 20),
                                const SizedBox(width: 12),
                                Text(
                                  '${_dateSelectionnee.day}/${_dateSelectionnee.month}/${_dateSelectionnee.year}',
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1E3A5F)),
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF9AA5B4)),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── الوقت ──
                        _buildSectionTitle(isAr ? 'اختر الوقت' : 'Choisir l\'heure'),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 42,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _heuresDisponibles.length,
                            itemBuilder: (context, index) {
                              final heure = _heuresDisponibles[index];
                              final selected = _heureSelectionnee == heure;
                              return GestureDetector(
                                onTap: () => setState(() => _heureSelectionnee = heure),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: selected ? primary : const Color(0xFFF1F4F8),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(heure,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: selected ? Colors.white : const Color(0xFF9AA5B4),
                                        )),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── عدد الساعات ──
                        _buildSectionTitle(isAr ? 'عدد الأيام' : 'Nombre de jours'),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE0E7F0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () { if (_heures > 1) setState(() => _heures--); },
                                child: Container(
                                  width: 36, height: 36,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0E7F0),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.remove_rounded, color: primary, size: 20),
                                ),
                              ),
                              Text(
                                isAr ? '$_heures أيام' : '$_heures jours',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => _heures++),
                                child: Container(
                                  width: 36, height: 36,
                                  decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── العنوان ──
                        _buildSectionTitle(isAr ? 'العنوان' : 'Adresse'),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE0E7F0)),
                          ),
                          child: TextField(
                            controller: _adresseController,
                            decoration: InputDecoration(
                              hintText: isAr
                                  ? 'مثال: نواكشوط، شارع الاستقلال'
                                  : 'Ex: Nouakchott, Rue de l\'Indépendance',
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                              prefixIcon: const Icon(Icons.location_on_outlined, color: primary, size: 22),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── ملخص السعر ──
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F4F8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              _buildPrixRow(
                                isAr ? 'السعر / يوم' : 'Prix / jour',
                                '${o.prixJournalier.toInt()} MRU',
                              ),
                              const SizedBox(height: 8),
                              _buildPrixRow(
                                isAr ? 'عدد الأيام' : 'Nombre de jours',
                                '$_heures',
                              ),
                              const Divider(height: 20),
                              _buildPrixRow(
                                isAr ? 'المجموع' : 'Total',
                                '$total MRU',
                                isBold: true,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── زر رجوع ──
            Positioned(
              top: 16,
              right: isAr ? 20 : null,
              left: isAr ? null : 20,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10)],
                    ),
                    child: Icon(
                      isAr ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_rounded,
                      size: 18, color: primary,
                    ),
                  ),
                ),
              ),
            ),

            // ── زر تأكيد الحجز ──
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, -4))],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _confirmerReservation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(width: 24, height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                        : Text(
                      isAr ? 'تأكيد الحجز — $total MRU' : 'Confirmer — $total MRU',
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

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)));
  }

  Widget _buildPrixRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: isBold ? 15 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? const Color(0xFF1E3A5F) : const Color(0xFF9AA5B4),
            )),
        Text(value,
            style: TextStyle(
              fontSize: isBold ? 18 : 14,
              fontWeight: FontWeight.bold,
              color: isBold ? primary : const Color(0xFF1E3A5F),
            )),
      ],
    );
  }
}