import 'package:flutter/material.dart';
import 'liste_ouvriers.dart';

class Accueil extends StatefulWidget {
  final String langue;
  const Accueil({super.key, required this.langue});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {'nom_ar': 'نجار', 'nom_fr': 'Menuisier', 'icon': Icons.carpenter},
    {'nom_ar': 'كهربائي', 'nom_fr': 'Électricien', 'icon': Icons.electrical_services},
    {'nom_ar': 'سباك', 'nom_fr': 'Plombier', 'icon': Icons.plumbing},
    {'nom_ar': 'دهان', 'nom_fr': 'Peintre', 'icon': Icons.format_paint},
    {'nom_ar': 'بناء', 'nom_fr': 'Maçon', 'icon': Icons.construction},
    {'nom_ar': 'تنظيف', 'nom_fr': 'Nettoyage', 'icon': Icons.cleaning_services},
    {'nom_ar': 'حداد', 'nom_fr': 'Forgeron', 'icon': Icons.hardware},
    {'nom_ar': 'سائق', 'nom_fr': 'Chauffeur', 'icon': Icons.drive_eta},
  ];

  final List<Map<String, dynamic>> _ouvriers = [
    {
      'nom': 'أحمد محمد',
      'metier_ar': 'نجار',
      'metier_fr': 'Menuisier',
      'note': 4.9,
      'avis': 234,
      'ville_ar': 'دمشق',
      'ville_fr': 'Damas',
      'badge': true,
      'prix': '20',
    },
    {
      'nom': 'خالد علي',
      'metier_ar': 'كهربائي',
      'metier_fr': 'Électricien',
      'note': 4.7,
      'avis': 189,
      'ville_ar': 'حلب',
      'ville_fr': 'Alep',
      'badge': true,
      'prix': '15',
    },
    {
      'nom': 'سامر حسن',
      'metier_ar': 'سباك',
      'metier_fr': 'Plombier',
      'note': 4.8,
      'avis': 312,
      'ville_ar': 'دمشق',
      'ville_fr': 'Damas',
      'badge': false,
      'prix': '18',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isAr = widget.langue == "AR";
    const primary = Color(0xFF2B4C7E);

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
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
                              const Icon(Icons.location_on_rounded,
                                  color: primary, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                isAr ? 'دمشق، سوريا' : 'Damas, Syrie',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down_rounded,
                                  color: primary, size: 18),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isAr ? 'أهلاً، أحمد 👋' : 'Bonjour, Ahmed 👋',
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
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F4F8),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.notifications_outlined,
                              color: Color(0xFF1E3A5F),
                              size: 24,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F4F8),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded,
                            color: Color(0xFF9AA5B4), size: 22),
                        const SizedBox(width: 10),
                        Text(
                          isAr
                              ? 'ابحث عن خدمة أو عامل...'
                              : 'Rechercher un service...',
                          style: const TextStyle(
                            color: Color(0xFF9AA5B4),
                            fontSize: 15,
                          ),
                        ),
                      ],
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
                      Text(
                        isAr ? 'التصنيفات' : 'Catégories',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A5F),
                        ),
                      ),
                      Text(
                        isAr ? 'عرض الكل' : 'Voir tout',
                        style: const TextStyle(
                          fontSize: 13,
                          color: primary,
                          fontWeight: FontWeight.w600,
                        ),
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ListeOuvriers(
                                langue: widget.langue,
                                categorie: isAr
                                    ? cat['nom_ar']
                                    : cat['nom_fr'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 72,
                          margin: const EdgeInsets.only(left: 12),
                          child: Column(
                            children: [
                              Container(
                                width: 58,
                                height: 58,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F4F8),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  cat['icon'],
                                  color: primary,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isAr ? cat['nom_ar'] : cat['nom_fr'],
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1E3A5F),
                                ),
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

                // ── Divider ──
                Container(
                  height: 8,
                  color: const Color(0xFFF1F4F8),
                ),

                const SizedBox(height: 24),

                // ── عمال مميزون ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isAr ? 'الأكثر تقييماً' : 'Les mieux notés',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A5F),
                        ),
                      ),
                      Text(
                        isAr ? 'عرض الكل' : 'Voir tout',
                        style: const TextStyle(
                          fontSize: 13,
                          color: primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _ouvriers.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final o = _ouvriers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          // صورة
                          Stack(
                            children: [
                              Container(
                                width: 62,
                                height: 62,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F4F8),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: primary,
                                  size: 32,
                                ),
                              ),
                              if (o['badge'])
                                Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.verified_rounded,
                                      color: primary,
                                      size: 14,
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
                                Text(
                                  o['nom'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E3A5F),
                                  ),
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
                                      '${o['note']}  (${o['avis']})',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF1E3A5F),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(Icons.location_on_rounded,
                                        color: Color(0xFF9AA5B4), size: 13),
                                    const SizedBox(width: 2),
                                    Text(
                                      isAr ? o['ville_ar'] : o['ville_fr'],
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

                          // السعر + زر
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${o['prix']}/h',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  isAr ? 'احجز' : 'Réserver',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
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

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // ── Bottom Navigation ──
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          selectedItemColor: primary,
          unselectedItemColor: const Color(0xFF9AA5B4),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          backgroundColor: Colors.white,
          selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 11),
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
        ),
      ),
    );
  }
}
