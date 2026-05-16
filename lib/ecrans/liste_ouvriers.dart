import 'package:flutter/material.dart';
import 'profil_ouvrier.dart';

class ListeOuvriers extends StatefulWidget {
  final String langue;
  final String categorie;
  const ListeOuvriers({super.key, required this.langue, required this.categorie});

  @override
  State<ListeOuvriers> createState() => _ListeOuvriersState();
}

class _ListeOuvriersState extends State<ListeOuvriers> {
  int _filtreSelectionne = 0;
  static const primary = Color(0xFF2B4C7E);

  final List<Map<String, dynamic>> _ouvriers = [
    {
      'nom': 'أحمد محمد',
      'metier_ar': 'نجار محترف',
      'metier_fr': 'Menuisier Pro',
      'note': 4.9,
      'avis': 234,
      'ville_ar': 'دمشق',
      'ville_fr': 'Damas',
      'badge': true,
      'prix': '20',
      'disponible': true,
      'experience': '8',
    },
    {
      'nom': 'خالد علي',
      'metier_ar': 'نجار',
      'metier_fr': 'Menuisier',
      'note': 4.7,
      'avis': 189,
      'ville_ar': 'دمشق',
      'ville_fr': 'Damas',
      'badge': true,
      'prix': '15',
      'disponible': true,
      'experience': '5',
    },
    {
      'nom': 'سامر حسن',
      'metier_ar': 'نجار',
      'metier_fr': 'Menuisier',
      'note': 4.8,
      'avis': 312,
      'ville_ar': 'حلب',
      'ville_fr': 'Alep',
      'badge': false,
      'prix': '18',
      'disponible': false,
      'experience': '10',
    },
    {
      'nom': 'عمر يوسف',
      'metier_ar': 'نجار ديكور',
      'metier_fr': 'Menuisier Déco',
      'note': 4.5,
      'avis': 98,
      'ville_ar': 'دمشق',
      'ville_fr': 'Damas',
      'badge': false,
      'prix': '12',
      'disponible': true,
      'experience': '3',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isAr = widget.langue == "AR";
    const primary = Color(0xFF2B4C7E);

    final filtres = isAr
        ? ['الكل', 'الأعلى تقييماً', 'الأقل سعراً', 'متاح الآن']
        : ['Tous', 'Mieux notés', 'Prix bas', 'Disponible'];

    List<Map<String, dynamic>> ouvriersAffiches = List.from(_ouvriers);
    if (_filtreSelectionne == 1) {
      ouvriersAffiches.sort((a, b) => b['note'].compareTo(a['note']));
    } else if (_filtreSelectionne == 2) {
      ouvriersAffiches.sort((a, b) =>
          int.parse(a['prix']).compareTo(int.parse(b['prix'])));
    } else if (_filtreSelectionne == 3) {
      ouvriersAffiches =
          ouvriersAffiches.where((o) => o['disponible'] == true).toList();
    }

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
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F4F8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isAr
                              ? Icons.arrow_forward_ios_rounded
                              : Icons.arrow_back_ios_rounded,
                          size: 18,
                          color: primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.categorie,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3A5F),
                            ),
                          ),
                          Text(
                            isAr
                                ? '${ouvriersAffiches.length} عامل متاح'
                                : '${ouvriersAffiches.length} pros disponibles',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9AA5B4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Search ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F4F8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded,
                          color: Color(0xFF9AA5B4), size: 20),
                      const SizedBox(width: 10),
                      Text(
                        isAr ? 'ابحث في النتائج...' : 'Rechercher...',
                        style: const TextStyle(
                          color: Color(0xFF9AA5B4),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
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
                      onTap: () =>
                          setState(() => _filtreSelectionne = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
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
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: ouvriersAffiches.length,
                  separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Color(0xFFF1F4F8)),
                  itemBuilder: (context, index) {
                    final o = ouvriersAffiches[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfilOuvrier(
                              langue: widget.langue,
                              ouvrier: o,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            // صورة + متاح
                            Stack(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F4F8),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: const Icon(
                                    Icons.person_rounded,
                                    color: primary,
                                    size: 34,
                                  ),
                                ),
                                // نقطة متاح
                                Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: o['disponible']
                                          ? Colors.green
                                          : Colors.grey,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(width: 14),

                            // معلومات
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        o['nom'],
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E3A5F),
                                        ),
                                      ),
                                      if (o['badge']) ...[
                                        const SizedBox(width: 6),
                                        const Icon(
                                          Icons.verified_rounded,
                                          color: primary,
                                          size: 16,
                                        ),
                                      ]
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    isAr ? o['metier_ar'] : o['metier_fr'],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF9AA5B4),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.star_rounded,
                                          color: Colors.amber, size: 14),
                                      const SizedBox(width: 3),
                                      Text(
                                        '${o['note']}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E3A5F),
                                        ),
                                      ),
                                      Text(
                                        ' (${o['avis']})',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF9AA5B4),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.work_outline_rounded,
                                          color: Color(0xFF9AA5B4), size: 13),
                                      const SizedBox(width: 3),
                                      Text(
                                        isAr
                                            ? '${o['experience']} سنوات'
                                            : '${o['experience']} ans',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF9AA5B4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // السعر
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${o['prix']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primary,
                                  ),
                                ),
                                Text(
                                  isAr ? '/ساعة' : '/heure',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF9AA5B4),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  o['disponible']
                                      ? (isAr ? '● متاح' : '● Dispo')
                                      : (isAr ? '● مشغول' : '● Occupé'),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: o['disponible']
                                        ? Colors.green
                                        : Colors.grey,
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
            ],
          ),
        ),
      ),
    );
  }
}
