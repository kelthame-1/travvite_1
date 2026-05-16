import 'package:flutter/material.dart';
import 'accueil.dart';
import 'tableau_ouvrier.dart';

class Inscription extends StatefulWidget {
  final int typeUtilisateur;
  final String langue;
  const Inscription({super.key, required this.typeUtilisateur, required this.langue});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final _nomController = TextEditingController();
  final _telController = TextEditingController();
  final _villeController = TextEditingController();
  final _metierController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isOuvrier = widget.typeUtilisateur == 1;
    final isAr = widget.langue == "AR";

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        // زر الرجوع في الأعلى
                        Align(
                          alignment: isAr ? Alignment.topRight : Alignment.topLeft,
                          child: _buildBackButton(isAr),
                        ),

                        const Spacer(),

                        // العنوان يتغير حسب النوع
                        Text(
                          isAr
                              ? (isOuvrier ? 'إنشاء حساب عامل' : 'إنشاء حساب جديد')
                              : (isOuvrier ? 'Compte Ouvrier' : 'Créer un compte'),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A5F),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // حقل الاسم الكامل
                        _buildField(
                          controller: _nomController,
                          label: isAr ? 'الاسم الكامل' : 'Nom complet',
                          icon: Icons.person_outline_rounded,
                          hint: isAr ? 'مثال: أحمد محمد' : 'Ex: Ahmed Mohamed',
                        ),

                        const SizedBox(height: 16),

                        // حقل رقم الهاتف
                        _buildField(
                          controller: _telController,
                          label: isAr ? 'رقم الهاتف' : 'Téléphone',
                          icon: Icons.phone_android_rounded,
                          hint: '+213 XXXXXXXX',
                          type: TextInputType.phone,
                        ),

                        const SizedBox(height: 16),

                        // حقل المدينة
                        _buildField(
                          controller: _villeController,
                          label: isAr ? 'المدينة' : 'Ville',
                          icon: Icons.location_on_outlined,
                          hint: isAr ? 'مثال: الجزائر العاصمة' : 'Ex: Alger',
                        ),

                        // حقل المهنة (يظهر فقط إذا كان المستخدم عاملاً)
                        if (isOuvrier) ...[
                          const SizedBox(height: 16),
                          _buildField(
                            controller: _metierController,
                            label: isAr ? 'المهنة' : 'Métier',
                            icon: Icons.handyman_outlined,
                            hint: isAr ? 'مثال: نجار، كهربائي' : 'Ex: Menuisier',
                          ),
                        ],

                        const SizedBox(height: 40),

                        // زر إنشاء الحساب (يظهر للجميع بدون شروط)
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _continuer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2B4C7E),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                              isAr ? 'إنشاء الحساب' : 'Créer le compte',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // رابط "لديك حساب بالفعل؟" (يظهر للجميع: مستخدم وعامل)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isAr ? "لديك حساب بالفعل؟ " : "Déjà inscrit ? ",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            GestureDetector(
                              onTap: () {
                                // هنا يتم التوجيه لصفحة الـ Login المشتركة لاحقاً
                                print("Go to Login Screen");
                              },
                              child: Text(
                                isAr ? "سجل دخولك" : "Se connecter",
                                style: const TextStyle(
                                  color: Color(0xFF2B4C7E),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Spacer(flex: 2),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ودجت الحقل
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType type = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E3A5F))),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8))],
          ),
          child: TextField(
            controller: controller,
            keyboardType: type,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              prefixIcon: Icon(icon, color: const Color(0xFF2B4C7E), size: 22),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            ),
          ),
        ),
      ],
    );
  }

  // زر الرجوع
  Widget _buildBackButton(bool isAr) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Icon(
          isAr ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_rounded,
          size: 18, color: const Color(0xFF2B4C7E),
        ),
      ),
    );
  }

  // دالة التوجيه الذكي بعد الضغط على زر إنشاء الحساب
  void _continuer() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => widget.typeUtilisateur == 0
              ? Accueil(langue: widget.langue)
              : const TableauOuvrier(langue: 'AR'),
        ),
            (route) => false,
      );
    }
  }
}