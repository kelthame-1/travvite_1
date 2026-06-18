import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travvite_1/features/client/accueil.dart';
import 'package:travvite_1/features/ouvrier/tableau_ouvrier.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/validators.dart';
import '../../data/repositories/auth_repository.dart';

class Login extends StatefulWidget {
  final String langue;
  const Login({super.key, required this.langue});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static const primary = Color(0xFF2B4C7E);
  final _authRepository = AuthRepository(); // 🆕
  final _formKey = GlobalKey<FormState>();
  final _telController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _showPassword = false;

  @override
  void dispose() {
    _telController.dispose();
    _passwordController.dispose();
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
    if (e is ServerException) {
      final msg = e.message.toLowerCase();
      if (msg.contains('non trouvé') || msg.contains('introuvable')) {
        return isAr ? 'رقم الهاتف غير مسجل' : 'Numéro non enregistré';
      }
      if (msg.contains('mot de passe')) {
        return isAr ? 'كلمة المرور غير صحيحة' : 'Mot de passe incorrect';
      }
    }
    return isAr ? 'حدث خطأ، حاول مجدداً' : 'Une erreur est survenue';
  }

  @override
  Widget build(BuildContext context) {
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
                    child: AutofillGroup(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),

                            Align(
                              alignment: isAr ? Alignment.topRight : Alignment.topLeft,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  width: 44, height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.06),
                                      blurRadius: 10,
                                    )],
                                  ),
                                  child: Icon(
                                    isAr ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_rounded,
                                    size: 18, color: primary,
                                  ),
                                ),
                              ),
                            ),

                            const Spacer(),

                            Container(
                              width: 70, height: 70,
                              decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(Icons.handyman_rounded, size: 38, color: Colors.white),
                            ),

                            const SizedBox(height: 16),

                            Text(
                              isAr ? 'مرحباً بعودتك 👋' : 'Bon retour 👋',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3A5F),
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              isAr ? 'سجل دخولك للمتابعة' : 'Connectez-vous pour continuer',
                              style: const TextStyle(fontSize: 14, color: Color(0xFF9AA5B4)),
                            ),

                            const SizedBox(height: 32),

                            _buildLabel(isAr ? 'رقم الهاتف' : 'Téléphone', isAr),
                            const SizedBox(height: 8),
                            _buildFieldContainer(
                              child: TextFormField(
                                controller: _telController,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.telephoneNumber],
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(8),
                                ],
                                validator: (v) => Validators.telephone(v, isAr: isAr),
                                decoration: InputDecoration(
                                  hintText: '2X XXX XXXX',
                                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                                  prefixIcon: const Icon(Icons.phone_android_rounded, color: primary, size: 22),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                  errorStyle: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            _buildLabel(isAr ? 'كلمة المرور' : 'Mot de passe', isAr),
                            const SizedBox(height: 8),
                            _buildFieldContainer(
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: !_showPassword,
                                textInputAction: TextInputAction.done,
                                autofillHints: const [AutofillHints.password],
                                onFieldSubmitted: (_) => _login(),
                                validator: (v) => Validators.password(v, isAr: isAr),
                                decoration: InputDecoration(
                                  hintText: '••••••••',
                                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                                  prefixIcon: const Icon(Icons.lock_outline_rounded, color: primary, size: 22),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                      color: Colors.grey.shade400, size: 20,
                                    ),
                                    onPressed: () => setState(() => _showPassword = !_showPassword),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                  errorStyle: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            Align(
                              alignment: isAr ? Alignment.centerLeft : Alignment.centerRight,
                              child: Text(
                                isAr ? 'نسيت كلمة المرور؟' : 'Mot de passe oublié?',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            SizedBox(
                              width: double.infinity,
                              height: 58,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 0,
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                  width: 24, height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.5,
                                  ),
                                )
                                    : Text(
                                  isAr ? 'تسجيل الدخول' : 'Se connecter',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isAr ? 'ما عندك حساب؟ ' : 'Pas de compte? ',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Text(
                                    isAr ? 'سجل الآن' : 'S\'inscrire',
                                    style: const TextStyle(
                                      color: primary,
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
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isAr) {
    return Align(
      alignment: isAr ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E3A5F),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  void _login() async {
    if (_isLoading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final isAr = widget.langue == "AR";
    setState(() => _isLoading = true);

    try {
      final user = await _authRepository.login(
        telephone: _telController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAr ? '✅ مرحباً ${user.nom}!' : '✅ Bienvenue ${user.nom}!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => user.role == 'CLIENT'
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
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}