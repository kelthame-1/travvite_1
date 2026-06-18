import 'package:flutter/material.dart';
import '../../core/errors/exceptions.dart';
import '../../data/repositories/evaluation_repository.dart';

class Evaluation extends StatefulWidget {
  final String langue;
  final int reservationId;
  final int ouvrierId;
  final String ouvrierNom;

  const Evaluation({
    super.key,
    required this.langue,
    required this.reservationId,
    required this.ouvrierId,
    required this.ouvrierNom,
  });

  @override
  State<Evaluation> createState() => _EvaluationState();
}

class _EvaluationState extends State<Evaluation> {
  static const primary = Color(0xFF2B4C7E);
  final _evaluationRepository = EvaluationRepository();
  final _commentaireController = TextEditingController();

  int _note = 0;
  bool _isLoading = false;
  final List<String> _tagsSelectionnes = [];

  @override
  void dispose() {
    _commentaireController.dispose();
    super.dispose();
  }

  Future<void> _envoyerEvaluation() async {
    final isAr = widget.langue == "AR";

    if (_note == 0) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      await _evaluationRepository.creerEvaluation(
        reservationId: widget.reservationId,
        ouvrierId: widget.ouvrierId,
        note: _note,
        commentaire: _commentaireController.text.trim().isEmpty
            ? null
            : _commentaireController.text.trim(),
        tags: _tagsSelectionnes.isEmpty ? null : _tagsSelectionnes.join(','),
      );

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => Directionality(
            textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                isAr ? '✅ شكراً على تقييمك!' : '✅ Merci pour votre avis!',
                style: const TextStyle(color: Color(0xFF1E3A5F), fontWeight: FontWeight.bold),
              ),
              content: Text(
                isAr ? 'تقييمك يساعدنا على تحسين الخدمة' : 'Votre avis nous aide à améliorer le service',
                style: const TextStyle(color: Color(0xFF9AA5B4)),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(isAr ? 'حسنا' : 'OK',
                      style: const TextStyle(color: primary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String msg = isAr ? 'حدث خطأ، حاول مجدداً' : 'Une erreur est survenue';
        if (e is NetworkException) msg = isAr ? 'لا يوجد اتصال' : 'Pas de connexion';
        if (e is SessionException) msg = isAr ? 'جلسة منتهية' : 'Session expirée';
        if (e is ValidationException) msg = e.message;
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

    final tags = isAr
        ? ['محترف', 'دقيق في المواعيد', 'سريع', 'نظيف', 'سعر مناسب', 'أنصح به']
        : ['Professionnel', 'Ponctuel', 'Rapide', 'Soigné', 'Bon prix', 'Recommandé'];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                // ── زر رجوع ──
                Align(
                  alignment: isAr ? Alignment.topRight : Alignment.topLeft,
                  child: GestureDetector(
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
                ),

                const SizedBox(height: 24),

                // ── أيقونة ──
                Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 40),
                ),

                const SizedBox(height: 16),

                Text(
                  isAr ? 'تمت الخدمة بنجاح! 🎉' : 'Service terminé avec succès! 🎉',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
                ),

                const SizedBox(height: 6),

                Text(
                  isAr ? 'شاركنا رأيك بالخدمة' : 'Partagez votre avis sur le service',
                  style: const TextStyle(fontSize: 14, color: Color(0xFF9AA5B4)),
                ),

                const SizedBox(height: 28),

                // ── العامل ──
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F4F8),
                    shape: BoxShape.circle,
                    border: Border.all(color: primary, width: 3),
                  ),
                  child: const Icon(Icons.person_rounded, size: 44, color: primary),
                ),

                const SizedBox(height: 12),

                Text(
                  widget.ouvrierNom,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
                ),

                const SizedBox(height: 28),

                // ── النجوم ──
                Text(
                  isAr ? 'كيف كانت الخدمة؟' : 'Comment était le service?',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
                ),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () => setState(() => _note = index + 1),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          index < _note ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: index < _note ? Colors.amber : Colors.grey.shade300,
                          size: 44,
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 8),

                Text(
                  _note == 0 ? (isAr ? 'اضغط لتقييم' : 'Appuyez pour noter')
                      : _note == 1 ? (isAr ? 'سيء 😞' : 'Mauvais 😞')
                      : _note == 2 ? (isAr ? 'مقبول 😐' : 'Passable 😐')
                      : _note == 3 ? (isAr ? 'جيد 🙂' : 'Bien 🙂')
                      : _note == 4 ? (isAr ? 'جيد جداً 😊' : 'Très bien 😊')
                      : (isAr ? 'ممتاز! 🤩' : 'Excellent! 🤩'),
                  style: TextStyle(
                    fontSize: 14,
                    color: _note == 0 ? const Color(0xFF9AA5B4) : const Color(0xFF1E3A5F),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 28),

                // ── Tags ──
                Align(
                  alignment: isAr ? Alignment.centerRight : Alignment.centerLeft,
                  child: Text(
                    isAr ? 'ما الذي أعجبك؟' : 'Qu\'est-ce qui vous a plu?',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
                  ),
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: tags.map((tag) {
                    final selected = _tagsSelectionnes.contains(tag);
                    return GestureDetector(
                      onTap: () => setState(() {
                        if (selected) _tagsSelectionnes.remove(tag);
                        else _tagsSelectionnes.add(tag);
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: selected ? primary : const Color(0xFFF1F4F8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: selected ? primary : const Color(0xFFE0E7F0)),
                        ),
                        child: Text(tag,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: selected ? Colors.white : const Color(0xFF1E3A5F),
                            )),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // ── التعليق ──
                Align(
                  alignment: isAr ? Alignment.centerRight : Alignment.centerLeft,
                  child: Text(
                    isAr ? 'تعليق (اختياري)' : 'Commentaire (optionnel)',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE0E7F0)),
                  ),
                  child: TextField(
                    controller: _commentaireController,
                    maxLines: 4,
                    textAlign: isAr ? TextAlign.right : TextAlign.left,
                    decoration: InputDecoration(
                      hintText: isAr ? 'اكتب تعليقك هنا...' : 'Écrivez votre commentaire...',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── زر إرسال ──
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: (_note == 0 || _isLoading) ? null : _envoyerEvaluation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(width: 24, height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                        : Text(
                      isAr ? 'إرسال التقييم' : 'Envoyer l\'avis',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}