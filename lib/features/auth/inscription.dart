import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travvite_1/features/client/accueil.dart';
import 'package:travvite_1/features/ouvrier/tableau_ouvrier.dart';
import 'package:travvite_1/features/auth/Login.dart';
import '../../core/constantes/app_constantes.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/validators.dart';
import '../../data/repositories/auth_repository.dart';

class Inscription extends StatefulWidget {
  final int typeUtilisateur;
  final String langue;
  const Inscription({super.key, required this.typeUtilisateur, required this.langue});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  static const primary = AppConstants.primaryColor;

  final _authRepository = AuthRepository(); // 🆕

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telController = TextEditingController();
  final _villeController = TextEditingController();
  final _prixController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  int _etape = 1;

  String _categorie = 'KHADIMA';
  String _genre = 'HOMME';
  String _langueOuvrier = 'AR';
  String _typeJournee = 'TEMPS_PLEIN';
  bool _avecEnfants = false;
  String _niveauScolaire = 'SECONDAIRE';
  String _nationalite = 'MAURITANIENNE';
  String _typePrix = 'JOURNALIER';

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telController.dispose();
    _villeController.dispose();
    _prixController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _translateError(dynamic e) {
    final isAr = widget.langue == "AR";
    if (e is NetworkException) {
      return isAr ? 'لا يوجد اتصال بالإنترنت' : 'Pas de connexion internet';
    }
    if (e is NetworkTimeoutException) {
      return isAr ? 'انتهت مهلة الاتصال، حاول مجدداً' : 'Délai dépassé, réessayez';
    }
    if (e is SessionException) {
      return isAr ? 'جلسة منتهية، أعد المحاولة' : 'Session expirée, réessayez';
    }
    if (e is ServerException) {
      final msg = e.message.toLowerCase();
      if (msg.contains('téléphone') && msg.contains('utilisé')) {
        return isAr ? 'رقم الهاتف مستخدم مسبقاً' : 'Téléphone déjà utilisé';
      }
    }
    return isAr ? 'حدث خطأ، حاول مجدداً' : 'Une erreur est survenue';
  }

  @override
  Widget build(BuildContext context) {
    final isOuvrier = widget.typeUtilisateur == 1;
    final isAr = widget.langue == "AR";

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingLarge),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        Align(
                          alignment: isAr
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              if (_etape == 2) setState(() => _etape = 1);
                              else Navigator.pop(context);
                            },
                            child: Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 10)],
                              ),
                              child: Icon(
                                isAr
                                    ? Icons.arrow_forward_ios_rounded
                                    : Icons.arrow_back_ios_rounded,
                                size: 18, color: primary,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        if (isOuvrier) ...[
                          Row(children: [
                            Expanded(child: Container(
                                height: 4,
                                decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(2)))),
                            const SizedBox(width: 8),
                            Expanded(child: Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: _etape == 2
                                      ? primary
                                      : const Color(0xFFE0E7F0),
                                  borderRadius: BorderRadius.circular(2),
                                ))),
                          ]),
                          const SizedBox(height: 8),
                          Text(
                              isAr
                                  ? 'الخطوة $_etape من 2'
                                  : 'Étape $_etape sur 2',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppConstants.greyColor)),
                          const SizedBox(height: 16),
                        ],

                        Text(
                          _etape == 1
                              ? (isAr
                              ? (isOuvrier
                              ? 'إنشاء حساب عامل'
                              : 'إنشاء حساب جديد')
                              : (isOuvrier
                              ? 'Compte Ouvrier'
                              : 'Créer un compte'))
                              : (isAr
                              ? 'معلومات إضافية'
                              : 'Informations supplémentaires'),
                          style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.secondaryColor),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _etape == 1
                              ? (isAr
                              ? 'أدخل معلوماتك الأساسية'
                              : 'Entrez vos informations de base')
                              : (isAr
                              ? 'أدخل تفاصيل عملك'
                              : 'Entrez les détails de votre travail'),
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppConstants.greyColor),
                        ),
                        const SizedBox(height: 32),

                        if (_etape == 1)
                          Form(
                            key: _formKey1,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: Column(children: [
                              _buildField(
                                controller: _nomController,
                                label: isAr ? 'الاسم' : 'Nom',
                                icon: Icons.person_outline_rounded,
                                hint: isAr ? 'مثال: أحمد' : 'Ex: Ahmed',
                                action: TextInputAction.next,
                                validator: (v) => Validators.nom(v, isAr: isAr),
                              ),
                              const SizedBox(height: AppConstants.paddingMedium),
                              _buildField(
                                controller: _prenomController,
                                label: isAr ? 'اللقب' : 'Prénom',
                                icon: Icons.person_outline_rounded,
                                hint: isAr ? 'مثال: محمد' : 'Ex: Mohamed',
                                action: TextInputAction.next,
                                validator: (v) => Validators.nom(v, isAr: isAr),
                              ),
                              const SizedBox(height: AppConstants.paddingMedium),
                              _buildField(
                                controller: _telController,
                                label: isAr ? 'رقم الهاتف' : 'Téléphone',
                                icon: Icons.phone_android_rounded,
                                hint: '2X XXX XXXX',
                                type: TextInputType.phone,
                                action: TextInputAction.next,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(8),
                                ],
                                validator: (v) => Validators.telephone(v, isAr: isAr),
                              ),
                              const SizedBox(height: AppConstants.paddingMedium),
                              _buildField(
                                controller: _passwordController,
                                label: isAr ? 'كلمة المرور' : 'Mot de passe',
                                icon: Icons.lock_outline_rounded,
                                hint: isAr ? '6 أحرف على الأقل' : '6 caractères minimum',
                                isPassword: true,
                                showPassword: _showPassword,
                                action: TextInputAction.next,
                                onTogglePassword: () => setState(() => _showPassword = !_showPassword),
                                validator: (v) => Validators.password(v, isAr: isAr),
                              ),
                              const SizedBox(height: AppConstants.paddingMedium),
                              _buildField(
                                controller: _confirmPasswordController,
                                label: isAr ? 'تأكيد كلمة المرور' : 'Confirmer mot de passe',
                                icon: Icons.lock_outline_rounded,
                                hint: isAr ? 'أعد كتابة كلمة المرور' : 'Répétez le mot de passe',
                                isPassword: true,
                                showPassword: _showConfirmPassword,
                                action: TextInputAction.next,
                                onTogglePassword: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                                validator: (v) => Validators.confirmPassword(v, _passwordController.text, isAr: isAr),
                              ),
                              const SizedBox(height: AppConstants.paddingMedium),
                              _buildField(
                                controller: _villeController,
                                label: isAr ? 'المدينة' : 'Ville',
                                icon: Icons.location_on_outlined,
                                hint: isAr ? 'مثال: نواكشوط' : 'Ex: Nouakchott',
                                action: isOuvrier ? TextInputAction.next : TextInputAction.done,
                                validator: (v) => Validators.ville(v, isAr: isAr),
                              ),
                              if (isOuvrier) ...[
                                const SizedBox(height: AppConstants.paddingMedium),
                                _buildDropdown(
                                  label: isAr ? 'المهنة' : 'Métier',
                                  value: _categorie,
                                  items: AppConstants.categories,
                                  onChanged: (val) => setState(() => _categorie = val!),
                                ),
                              ],
                            ]),
                          ),

                        if (_etape == 2 && isOuvrier)
                          Form(
                            key: _formKey2,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: Column(children: [
                              _buildDropdown(
                                label: isAr ? 'الجنس' : 'Genre',
                                value: _genre,
                                items: AppConstants.genres,
                                onChanged: (val) => setState(() => _genre = val!),
                              ),
                              const SizedBox(height: AppConstants.paddingMedium),
                              _buildDropdown(
                                label: isAr ? 'اللغة' : 'Langue',
                                value: _langueOuvrier,
                                items: AppConstants.langues,
                                onChanged: (val) => setState(() => _langueOuvrier = val!),
                              ),
                              const SizedBox(height: AppConstants.paddingMedium),
                              _buildDropdown(
                                label: isAr ? 'نوع الدوام' : 'Type de journée',
                                value: _typeJournee,
                                items: AppConstants.disponibilites,
                                onChanged: (val) => setState(() => _typeJournee = val!),
                              ),
                              const SizedBox(height: AppConstants.paddingMedium),
                              _buildDropdown(
                                label: isAr ? 'مع أطفال؟' : 'Avec enfants?',
                                value: _avecEnfants ? 'OUI' : 'NON',
                                items: const {'OUI': 'نعم / Oui', 'NON': 'لا / Non'},
                                onChanged: (val) => setState(() => _avecEnfants = val == 'OUI'),
                              ),
                              const SizedBox(height: AppConstants.paddingMedium),
                              _buildDropdown(
                                label: isAr ? 'المستوى الدراسي' : 'Niveau scolaire',
                                value: _niveauScolaire,
                                items: AppConstants.niveauxEtude,
                                onChanged: (val) => setState(() => _niveauScolaire = val!),
                              ),
                              const SizedBox(height: AppConstants.paddingMedium),
                              _buildDropdown(
                                label: isAr ? 'الجنسية' : 'Nationalité',
                                value: _nationalite,
                                items: AppConstants.nationalites,
                                onChanged: (val) => setState(() => _nationalite = val!),
                              ),
                              const SizedBox(height: AppConstants.paddingMedium),
                              _buildDropdown(
                                label: isAr ? 'نوع السعر' : 'Type de prix',
                                value: _typePrix,
                                items: AppConstants.typesPrix,
                                onChanged: (val) => setState(() => _typePrix = val!),
                              ),
                              const SizedBox(height: AppConstants.paddingMedium),
                              _buildField(
                                controller: _prixController,
                                label: isAr ? 'السعر بـ MRU' : 'Prix en MRU',
                                icon: Icons.attach_money_rounded,
                                hint: isAr ? 'مثال: 1000.5' : 'Ex: 1000.5',
                                type: const TextInputType.numberWithOptions(decimal: true),
                                action: TextInputAction.done,
                                validator: (v) => Validators.prix(v, isAr: isAr),
                              ),
                            ]),
                          ),

                        const Spacer(),
                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _continuer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge)),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                              _etape == 1 && isOuvrier
                                  ? (isAr ? 'التالي ←' : 'Suivant →')
                                  : (isAr ? 'إنشاء الحساب' : 'Créer le compte'),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isAr ? 'لديك حساب بالفعل؟ ' : 'Déjà inscrit? ',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            InkWell(
                              onTap: () => Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => Login(langue: widget.langue)),
                                    (route) => route.isFirst,
                              ),
                              child: Text(
                                isAr ? 'سجل دخولك' : 'Se connecter',
                                style: const TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType type = TextInputType.text,
    bool isPassword = false,
    bool showPassword = false,
    VoidCallback? onTogglePassword,
    String? Function(String?)? validator,
    TextInputAction action = TextInputAction.next,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.secondaryColor)),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 8))
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: type,
            obscureText: isPassword && !showPassword,
            validator: validator,
            textInputAction: action,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              prefixIcon: Icon(icon, color: primary, size: 22),
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                onPressed: onTogglePassword,
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              errorStyle: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required Map<String, String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.secondaryColor)),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 8))
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
            items: items.entries
                .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  // ===== CONTINUER =====
  void _continuer() async {
    if (_isLoading) return;
    final isOuvrier = widget.typeUtilisateur == 1;
    final isAr = widget.langue == "AR";

    if (_etape == 1) {
      if (!(_formKey1.currentState?.validate() ?? false)) return;
      if (isOuvrier) {
        setState(() => _etape = 2);
        return;
      }
    }

    if (_etape == 2 && !(_formKey2.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      if (!isOuvrier) {
        await _authRepository.inscrireClient( // 🆕
          telephone: _telController.text.trim(),
          password: _passwordController.text.trim(),
          nom: _nomController.text.trim(),
          prenom: _prenomController.text.trim(),
          ville: _villeController.text.trim(),
        );
      } else {
        final user = await _authRepository.inscrireOuvrierEtape1( // 🆕
          telephone: _telController.text.trim(),
          password: _passwordController.text.trim(),
          nom: _nomController.text.trim(),
          prenom: _prenomController.text.trim(),
          ville: _villeController.text.trim(),
        );

        final prix = double.tryParse(_prixController.text.trim()) ?? 0;

        await _authRepository.inscrireOuvrierEtape2( // 🆕
          id: user.id,
          categorie: _categorie,
          genre: _genre,
          langue: _langueOuvrier,
          disponibilite: _typeJournee,
          accepteEnfants: _avecEnfants,
          niveauEtude: _niveauScolaire,
          nationalite: _nationalite,
          prixJournalier: _typePrix == 'JOURNALIER' ? prix : 0,
          prixMensuel: _typePrix == 'MENSUEL' ? prix : 0,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAr ? '✅ تم إنشاء حسابك بنجاح!' : '✅ Compte créé avec succès!'),
            backgroundColor: AppConstants.successColor,
            duration: const Duration(seconds: 2),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => widget.typeUtilisateur == 0
                  ? Accueil(langue: widget.langue)
                  : TableauOuvrier(langue: widget.langue),
            ),
                (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_translateError(e)),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}