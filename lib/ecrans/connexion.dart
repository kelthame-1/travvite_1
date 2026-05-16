import 'package:flutter/material.dart';
import 'inscription.dart';

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  int _selectedType = -1;
  String _currentLang = "AR";
  final Color primaryColor = const Color(0xFF2B4C7E);

  @override
  Widget build(BuildContext context) {
    // الحصول على أبعاد الشاشة لجعل التصميم مرن
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: _currentLang == "AR" ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Stack(
          children: [
            // الأشكال الخلفية مع أحجام نسبية
            Positioned(
              top: -screenHeight * 0.1,
              right: -screenWidth * 0.2,
              child: Container(
                width: screenWidth * 0.6,
                height: screenWidth * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(0.06),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),

                    // زر تبديل اللغة
                    Align(
                      alignment: _currentLang == "AR" ? Alignment.topLeft : Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => setState(() => _currentLang = _currentLang == "AR" ? "FR" : "AR"),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.language, size: 18, color: Color(0xFF2B4C7E)),
                              const SizedBox(width: 8),
                              Text(
                                _currentLang == "AR" ? "Français" : "العربية",
                                style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2B4C7E)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // الكارت الخاص باللوجو
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 8)),
                        ],
                      ),
                      child: Image.asset('assets/logo.png', width: 60),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    const Text(
                      "Travvite",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                        color: Color(0xFF1E3A5F),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    Text(
                      _currentLang == "AR"
                          ? "مساحة عملك بانتظارك\nاختر صفتك للبدء"
                          : "Votre espace vous attend\nChoisissez votre rôle",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.05),

                    // بطاقة صاحب العمل
                    _buildOptionCard(
                      index: 0,
                      title: _currentLang == "AR" ? "صاحب عمل / عميل" : "Employeur / Client",
                      subtitle: _currentLang == "AR" ? "أبحث عن محترفين لإنجاز مشاريعي" : "Je cherche des professionnels",
                      icon: Icons.business_center_rounded,
                      screenWidth: screenWidth,
                    ),

                    const SizedBox(height: 16),

                    // بطاقة العامل
                    _buildOptionCard(
                      index: 1,
                      title: _currentLang == "AR" ? "عامل / حرفي" : "Ouvrier / Artisan",
                      subtitle: _currentLang == "AR" ? "أبحث عن فرص عمل وأقدم خدماتي" : "Je cherche des opportunités",
                      icon: Icons.engineering_rounded,
                      screenWidth: screenWidth,
                    ),

                    SizedBox(height: screenHeight * 0.06),

                    // زر المتابعة
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: _selectedType == -1 ? null : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Inscription(
                                typeUtilisateur: _selectedType,
                                langue: _currentLang,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentLang == "AR" ? "متابعة" : "Continuer",
                              style: const TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    required double screenWidth,
  }) {
    bool isSelected = _selectedType == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedType = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: isSelected ? primaryColor : Colors.grey.shade200, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: isSelected ? primaryColor.withOpacity(0.15) : Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.15) : primaryColor.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: isSelected ? Colors.white : primaryColor),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}