class ApiConstantes {
static const bool isEmulator = true;

static const String _emulatorUrl = 'http://10.0.2.2:8080/api';
static const String _deviceUrl = 'http://192.168.56.1:8080/api';

static String get baseUrl => isEmulator ? _emulatorUrl : _deviceUrl;

// Auth
static String get inscriptionClient => '$baseUrl/auth/inscription/client';
static String get inscriptionOuvrierEtape1 => '$baseUrl/auth/inscription/ouvrier/etape1';
static String get inscriptionOuvrierEtape2 => '$baseUrl/auth/inscription/ouvrier/etape2';
static String get login => '$baseUrl/auth/login';

// Ouvriers
static String get ouvriers => '$baseUrl/ouvriers';
static String get ouvriersPlusNotes => '$baseUrl/ouvriers/plus-notes';
static String get ouvriersFilter => '$baseUrl/ouvriers/filtrer';

// Reservations
static String get reservations => '$baseUrl/reservations';

// Evaluations
static String get evaluations => '$baseUrl/evaluations';

// Notifications
static String get notifications => '$baseUrl/notifications';
}