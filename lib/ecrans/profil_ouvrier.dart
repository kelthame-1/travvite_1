import 'package:flutter/material.dart';
import 'reservation.dart';

class ProfilOuvrier extends StatelessWidget {
  final String langue;
  final Map<String, dynamic> ouvrier;

  const ProfilOuvrier({
    super.key,
    required this.langue,
    required this.ouvrier,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = langue == "AR";
    const primary = Color(0xFF2B4C7E);
    final size = MediaQuery.of(context).size;

    const skillsAr = [
      'نجارة خشب',
      'ديكور داخلي',
      'أثاث مخصص',
      'إصلاح أبواب',
      'تركيب أرضيات'
    ];

    const skillsFr = [
      'Menuiserie bois',
      'Décoration intérieure',
      'Meubles sur mesure',
      'Réparation portes',
      'Pose parquet'
    ];

    final avis = [
      {
        'nom': 'محمد س.',
        'note': 5,
        'commentaire_ar': 'عامل ممتاز وسريع جداً، أنصح به بشدة!',
        'commentaire_fr': 'Excellent travail, très rapide!',
        'date_ar': 'منذ أسبوع',
        'date_fr': 'Il y a 1 semaine',
      },
      {
        'nom': 'سارة م.',
        'note': 5,
        'commentaire_ar': 'احترافي جداً والشغل نظيف ومرتب',
        'commentaire_fr': 'Très professionnel, travail soigné',
        'date_ar': 'منذ أسبوعين',
        'date_fr': 'Il y a 2 semaines',
      },
      {
        'nom': 'علي ك.',
        'note': 4,
        'commentaire_ar': 'جيد جداً وفي الوقت المحدد',
        'commentaire_fr': 'Très bien et ponctuel',
        'date_ar': 'منذ شهر',
        'date_fr': 'Il y a 1 mois',
      },
    ];

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
                          tag: ouvrier['nom'],
                          child: Container(
                            width: size.width * 0.23,
                            height: size.width * 0.23,
                            decoration: BoxDecoration(
                              color: primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border:
                              Border.all(color: Colors.white, width: 4),
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              size: 50,
                              color: primary,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          children: [
                            Text(
                              ouvrier['nom'],
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3A5F),
                              ),
                            ),
                            if (ouvrier['badge'])
                              const Icon(
                                Icons.verified_rounded,
                                color: primary,
                                size: 20,
                              ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Text(
                          isAr
                              ? ouvrier['metier_ar']
                              : ouvrier['metier_fr'],
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF9AA5B4),
                          ),
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
                              isAr ? 'السعر / ساعة' : 'Prix / heure',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9AA5B4),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${ouvrier['prix']}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: primary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: ouvrier['disponible']
                                ? Colors.green.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: ouvrier['disponible']
                                      ? Colors.green
                                      : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                ouvrier['disponible']
                                    ? (isAr ? 'متاح الآن' : 'Disponible')
                                    : (isAr ? 'مشغول' : 'Occupé'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── About ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      isAr ? 'عن العامل' : 'À propos',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      isAr
                          ? 'نجار محترف بخبرة ${ouvrier['experience']} سنوات...'
                          : 'Menuisier professionnel avec ${ouvrier['experience']} ans...',
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Color(0xFF9AA5B4),
                      ),
                    ),
                  ),

                  // ── Skills ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (isAr ? skillsAr : skillsFr)
                          .map(
                            (s) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            s,
                            style: const TextStyle(color: primary),
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Reviews ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAr ? 'آراء العملاء' : 'Avis clients',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...avis.map(
                              (a) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(a['nom'].toString()),
                                const SizedBox(height: 4),
                                Text(
                                  isAr
                                      ? a['commentaire_ar'].toString()
                                      : a['commentaire_fr'].toString(),
                                  style: const TextStyle(
                                    color: Color(0xFF9AA5B4),
                                  ),
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEAEAEA)),
                    ),
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                ),
              ),
            ),

            // ── Reserve Button ──
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                const EdgeInsets.fromLTRB(20, 12, 20, 24),
                color: Colors.white,
                child: SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: ouvrier['disponible']
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Reservation(
                            langue: langue,
                            ouvrier: ouvrier,
                          ),
                        ),
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      isAr ? 'احجز الآن' : 'Réserver',
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
}