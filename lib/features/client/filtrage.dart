import 'package:flutter/material.dart';
import '../../core/constantes/app_constantes.dart';

class Filtrage extends StatefulWidget {
  final String langue;
  const Filtrage({super.key, required this.langue});

  @override
  State<Filtrage> createState() => _FiltrageState();
}

class _FiltrageState extends State<Filtrage> {
  static const primary = Color(0xFF2B4C7E);

  String _genre = '';
  String _langue = '';
  String _disponibilite = '';
  bool? _avecEnfants;
  String _niveauEtude = '';
  String _nationalite = '';
  String _categorie = '';
  RangeValues _prixRange = const RangeValues(0, 5000);

  void _reset() {
    setState(() {
      _genre = '';
      _langue = '';
      _disponibilite = '';
      _avecEnfants = null;
      _niveauEtude = '';
      _nationalite = '';
      _categorie = '';
      _prixRange = const RangeValues(0, 5000);
    });
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
            children: [

              // ── Header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Text(
                      isAr ? 'فلترة البحث' : 'Filtres',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F)),
                    ),
                    GestureDetector(
                      onTap: _reset,
                      child: Text(
                        isAr ? 'إعادة تعيين' : 'Réinitialiser',
                        style: const TextStyle(fontSize: 13, color: Colors.red, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const Divider(height: 1),

              // ── الفلاتر ──
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ── المهنة ──
                      _buildSection(
                        isAr ? 'المهنة' : 'Métier',
                        Wrap(
                          spacing: 10, runSpacing: 10,
                          children: AppConstants.categories.entries.map((e) =>
                              _buildChip(
                                e.value.split('/').first.trim(),
                                _categorie == e.key,
                                    () => setState(() => _categorie = _categorie == e.key ? '' : e.key),
                              ),
                          ).toList(),
                        ),
                      ),

                      // ── الجنس ──
                      _buildSection(
                        isAr ? 'الجنس' : 'Genre',
                        Row(
                          children: AppConstants.genres.entries.map((e) =>
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: _buildChip(
                                  isAr ? e.value.split('/').first.trim() : e.value.split('/').last.trim(),
                                  _genre == e.key,
                                      () => setState(() => _genre = _genre == e.key ? '' : e.key),
                                ),
                              ),
                          ).toList(),
                        ),
                      ),

                      // ── اللغة ──
                      _buildSection(
                        isAr ? 'اللغة' : 'Langue',
                        Wrap(
                          spacing: 10, runSpacing: 10,
                          children: AppConstants.langues.entries.map((e) =>
                              _buildChip(
                                e.value,
                                _langue == e.key,
                                    () => setState(() => _langue = _langue == e.key ? '' : e.key),
                              ),
                          ).toList(),
                        ),
                      ),

                      // ── نوع الدوام ──
                      _buildSection(
                        isAr ? 'نوع الدوام' : 'Disponibilité',
                        Wrap(
                          spacing: 10, runSpacing: 10,
                          children: AppConstants.disponibilites.entries.map((e) =>
                              _buildChip(
                                isAr ? e.value.split('/').first.trim() : e.value.split('/').last.trim(),
                                _disponibilite == e.key,
                                    () => setState(() => _disponibilite = _disponibilite == e.key ? '' : e.key),
                              ),
                          ).toList(),
                        ),
                      ),

                      // ── مع أطفال ──
                      _buildSection(
                        isAr ? 'مع أطفال' : 'Avec enfants',
                        Row(
                          children: [
                            _buildChip(
                              isAr ? 'نعم' : 'Oui',
                              _avecEnfants == true,
                                  () => setState(() => _avecEnfants = _avecEnfants == true ? null : true),
                            ),
                            const SizedBox(width: 10),
                            _buildChip(
                              isAr ? 'لا' : 'Non',
                              _avecEnfants == false,
                                  () => setState(() => _avecEnfants = _avecEnfants == false ? null : false),
                            ),
                          ],
                        ),
                      ),

                      // ── المستوى الدراسي ──
                      _buildSection(
                        isAr ? 'المستوى الدراسي' : 'Niveau scolaire',
                        Wrap(
                          spacing: 10, runSpacing: 10,
                          children: AppConstants.niveauxEtude.entries.map((e) =>
                              _buildChip(
                                isAr ? e.value.split('/').first.trim() : e.value.split('/').last.trim(),
                                _niveauEtude == e.key,
                                    () => setState(() => _niveauEtude = _niveauEtude == e.key ? '' : e.key),
                              ),
                          ).toList(),
                        ),
                      ),

                      // ── الجنسية ──
                      _buildSection(
                        isAr ? 'الجنسية' : 'Nationalité',
                        Wrap(
                          spacing: 10, runSpacing: 10,
                          children: AppConstants.nationalites.entries.map((e) =>
                              _buildChip(
                                e.value,
                                _nationalite == e.key,
                                    () => setState(() => _nationalite = _nationalite == e.key ? '' : e.key),
                              ),
                          ).toList(),
                        ),
                      ),

                      // ── السعر ──
                      _buildSection(
                        isAr ? 'السعر بـ MRU (يومي)' : 'Prix en MRU (par jour)',
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${_prixRange.start.round()} MRU',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: primary)),
                                Text('${_prixRange.end.round()} MRU',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: primary)),
                              ],
                            ),
                            RangeSlider(
                              values: _prixRange,
                              min: 0,
                              max: 5000,
                              divisions: 20,
                              activeColor: primary,
                              inactiveColor: const Color(0xFFF1F4F8),
                              onChanged: (values) => setState(() => _prixRange = values),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // ── زر تطبيق ──
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  )],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'categorie': _categorie.isEmpty ? null : _categorie,
                        'genre': _genre.isEmpty ? null : _genre,
                        'langue': _langue.isEmpty ? null : _langue,
                        'disponibilite': _disponibilite.isEmpty ? null : _disponibilite,
                        'accepteEnfants': _avecEnfants,
                        'niveauEtude': _niveauEtude.isEmpty ? null : _niveauEtude,
                        'nationalite': _nationalite.isEmpty ? null : _nationalite,
                        'prixMin': _prixRange.start > 0 ? _prixRange.start : null,
                        'prixMax': _prixRange.end < 5000 ? _prixRange.end : null,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text(
                      isAr ? 'تطبيق الفلتر' : 'Appliquer les filtres',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A5F))),
        const SizedBox(height: 12),
        content,
        const SizedBox(height: 20),
        const Divider(height: 1, color: Color(0xFFF1F4F8)),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? primary : const Color(0xFFF1F4F8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? primary : const Color(0xFFE0E7F0)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF1E3A5F),
          ),
        ),
      ),
    );
  }
}