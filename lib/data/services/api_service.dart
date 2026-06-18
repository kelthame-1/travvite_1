import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:travvite_1/Core/errors/exceptions.dart';
import '../../core/constantes/app_constantes.dart';

class ApiService {
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  static final Duration _timeout = const Duration(
    seconds: AppConstants.timeoutSeconds,
  );

  // ===== BUILD HEADERS =====
  static Map<String, String> _buildHeaders(String? token) {
    if (token == null) return _headers;
    return {..._headers, 'Authorization': 'Bearer $token'};
  }

  // ===== PARSE RESPONSE =====
  static dynamic _parseResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final bytes = response.bodyBytes;
      if (bytes.isEmpty) return {};
      return jsonDecode(utf8.decode(bytes));
    }

    String erreur = 'Erreur serveur';
    try {
      final error = jsonDecode(response.body);
      erreur = error['erreur'] ?? error['message'] ?? erreur;
    } catch (_) {}

    if (response.statusCode == 401) throw const SessionException('Session expirée');
    if (response.statusCode == 403) throw const ServerException('Accès refusé');
    if (response.statusCode == 404) throw const ServerException('Ressource introuvable');

    throw ServerException(erreur);
  }

  // ===== HANDLE ERRORS =====
  static Exception _handleError(dynamic e) {
    if (e is SessionException) return e;
    if (e is ServerException) return e;
    if (e is NetworkException) return e;
    if (e is NetworkTimeoutException) return e;
    if (e is SocketException) return NetworkException('Pas de connexion internet');
    if (e is TimeoutException) return NetworkTimeoutException('Délai dépassé, réessayez');
    return ServerException(e.toString());
  }

  // ===== GET =====
  static Future<dynamic> get(String url, {String? token}) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: _buildHeaders(token))
          .timeout(_timeout);
      return _parseResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ===== POST =====
  static Future<dynamic> post(String url, Map<String, dynamic> body,
      {String? token}) async {
    try {
      final response = await http
          .post(Uri.parse(url),
          headers: _buildHeaders(token), body: jsonEncode(body))
          .timeout(_timeout);
      return _parseResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ===== PUT =====
  static Future<dynamic> put(String url, Map<String, dynamic> body,
      {String? token}) async {
    try {
      final response = await http
          .put(Uri.parse(url),
          headers: _buildHeaders(token), body: jsonEncode(body))
          .timeout(_timeout);
      return _parseResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ===== PATCH =====
  static Future<dynamic> patch(String url, Map<String, dynamic> body,
      {String? token}) async {
    try {
      final response = await http
          .patch(Uri.parse(url),
          headers: _buildHeaders(token), body: jsonEncode(body))
          .timeout(_timeout);
      return _parseResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ===== DELETE =====
  static Future<dynamic> delete(String url, {String? token}) async {
    try {
      final response = await http
          .delete(Uri.parse(url), headers: _buildHeaders(token))
          .timeout(_timeout);
      return _parseResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
}