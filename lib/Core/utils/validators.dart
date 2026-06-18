class Validators {

// ===== NORMALIZE =====
static String _normalize(String? value) {
return value?.trim().replaceAll(RegExp(r'\s+'), ' ') ?? '';
}

// ===== TELEPHONE =====
static String? telephone(String? value, {bool isAr = true}) {
final val = _normalize(value);
if (val.isEmpty) return isAr ? 'الهاتف مطلوب' : 'Téléphone requis';
if (val.length != 8) return isAr ? 'يجب أن يكون 8 أرقام' : '8 chiffres requis';
if (!RegExp(r'^[234]\d{7}$').hasMatch(val)) {
return isAr ? 'رقم موريتاني غير صحيح' : 'Numéro mauritanien invalide';
}
return null;
}

// ===== PASSWORD =====
static String? password(String? value, {bool isAr = true}) {
final val = value?.trim() ?? '';
if (val.isEmpty) return isAr ? 'كلمة المرور مطلوبة' : 'Mot de passe requis';
if (val.length < 8) return isAr ? 'أقل من 8 أحرف' : 'Minimum 8 caractères';
if (val.length > 15) return isAr ? 'كلمة المرور طويلة جداً' : 'Mot de passe trop long';
if (!RegExp(r'[A-Z]').hasMatch(val)) {
return isAr ? 'يجب أن يحتوي على حرف كبير' : 'Doit contenir une majuscule';
}
if (!RegExp(r'[0-9]').hasMatch(val)) {
return isAr ? 'يجب أن يحتوي على رقم' : 'Doit contenir un chiffre';
}
return null;
}

// ===== CONFIRM PASSWORD =====
static String? confirmPassword(String? value, String password, {bool isAr = true}) {
if ((value?.trim() ?? '') != password.trim()) {
return isAr ? 'كلمتا المرور غير متطابقتين' : 'Mots de passe différents';
}
return null;
}

// ===== NOM / PRENOM =====
static String? nom(String? value, {bool isAr = true}) {
final val = _normalize(value);
if (val.isEmpty) return isAr ? 'الاسم مطلوب' : 'Nom requis';
if (val.length < 2) return isAr ? 'الاسم قصير جداً' : 'Nom trop court';
if (val.length > 50) return isAr ? 'الاسم طويل جداً' : 'Nom trop long';
if (!RegExp(r"^[\u0600-\u06FFa-zA-Z\s\-']+$").hasMatch(val)) {
return isAr ? 'الاسم يجب أن يحتوي على حروف فقط' : 'Lettres uniquement';
}
return null;
}

// ===== VILLE =====
static String? ville(String? value, {bool isAr = true}) {
final val = _normalize(value);
if (val.isEmpty) return isAr ? 'المدينة مطلوبة' : 'Ville requise';
if (val.length < 2) return isAr ? 'اسم المدينة قصير جداً' : 'Nom de ville trop court';
if (val.length > 50) return isAr ? 'اسم المدينة طويل جداً' : 'Nom de ville trop long';
if (RegExp(r'[0-9]').hasMatch(val)) {
return isAr ? 'اسم المدينة لا يحتوي على أرقام' : 'Pas de chiffres dans le nom';
}
return null;
}

// ===== PRIX =====
static String? prix(String? value, {bool isAr = true, double min = 100, double max = 100000}) {
final val = _normalize(value);
if (val.isEmpty) return isAr ? 'السعر مطلوب' : 'Prix requis';
if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(val)) {
return isAr ? 'سعر غير صحيح' : 'Prix invalide';
}
final parsed = double.tryParse(val);
if (parsed == null || parsed <= 0) {
return isAr ? 'السعر يجب أن يكون أكبر من 0' : 'Prix doit être > 0';
}
if (parsed < min) return isAr ? 'السعر لا يقل عن $min MRU' : 'Prix minimum $min MRU';
if (parsed > max) return isAr ? 'السعر لا يزيد عن $max MRU' : 'Prix maximum $max MRU';
return null;
}

// ===== REQUIRED =====
static String? required(String? value, String fieldName, {bool isAr = true}) {
final val = _normalize(value);
if (val.isEmpty) return isAr ? '$fieldName مطلوب' : '$fieldName requis';
if (val.length > 100) return isAr ? '$fieldName طويل جداً' : '$fieldName trop long';
return null;
}
}