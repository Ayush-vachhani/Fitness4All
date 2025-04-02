import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  static final String baseUrl = dotenv.env['SERVER_URL']!; // Use the server URL from the environment file
  static final storage = FlutterSecureStorage();

  static Map<String, dynamic>? userDetails;

  static Future<void> login(String email, String password, {bool rememberMe = false}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/collections/users/auth-with-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'identity': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final authData = json.decode(response.body);
      debugPrint('AuthData: ${authData.toString()}');

      // Save token securely
      await storage.write(key: 'auth_token', value: authData['token']);
      if (rememberMe) {
        await storage.write(key: 'remember_me', value: 'true');
      }

      // Fetch user details after successful login
      await fetchUserDetails(authData['record']['id'], authData['token']);
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      debugPrint('ResponseData: ${responseData.toString()}');
      throw Exception('Invalid credentials. Please try again.');
    } else {
      debugPrint('Failed to authenticate. Status code: ${response.statusCode}');
      throw Exception('Failed to authenticate. Please try again.');
    }
  }

  static Future<void> fetchUserDetails(String userId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/collections/users/records/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      userDetails = json.decode(response.body);
      debugPrint('UserDetails: ${userDetails.toString()}');
    } else {
      debugPrint('Failed to fetch user details. Status code: ${response.statusCode}');
      throw Exception('Failed to fetch user details. Please try again.');
    }
  }

  static Future<void> logout() async {
    await storage.delete(key: 'auth_token');
    await storage.delete(key: 'remember_me');
    userDetails = null;
  }

  static Future<void> register(String email, String password, String username, String age, String height, String weight, String level, String goal, XFile? profileImage) async {
    final body = {
      'email': email,
      'password': password,
      'passwordConfirm': password,
      'username': username,
      'age': age,
      'height': height,
      'weight': weight,
      'level': level,
      'goal': goal,
    };

    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/collections/users/records'));
    request.fields.addAll(body);

    if (profileImage != null) {
      request.files.add(await http.MultipartFile.fromPath('profileImage', profileImage.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      debugPrint('Registration successful');
    } else {
      final responseData = json.decode(await response.stream.bytesToString());
      debugPrint('Failed to register. Status code: ${response.statusCode}');
      debugPrint('Response body: $responseData');

      if (response.statusCode == 400 && responseData['data'] != null && responseData['data']['email'] != null && responseData['data']['email']['code'] == 'validation_not_unique') {
        throw Exception('The email address is already in use. Please use a different email.');
      }

      throw Exception('Failed to register. Please try again.');
    }
  }

  static Future<String?> getAuthToken() async {
    return await storage.read(key: 'auth_token');
  }

  static Future<bool> isRememberMeEnabled() async {
    return (await storage.read(key: 'remember_me')) == 'true';
  }

  static Future<void> enableTwoFactorAuth(String userId, String method) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/collections/_mfas/records'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getAuthToken()}',
      },
      body: json.encode({
        'collectionRef': '_pb_users_auth_',
        'recordRef': userId,
        'method': method,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('2FA enabled successfully.');
    } else {
      debugPrint('Failed to enable 2FA. Status code: ${response.statusCode}');
      throw Exception('Failed to enable 2FA. Please try again.');
    }
  }

  static Future<void> generateAndStoreOtp(String userId, String sentTo) async {
    final otp = _generateOtp();
    final response = await http.post(
      Uri.parse('$baseUrl/api/collections/_otps/records'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getAuthToken()}',
      },
      body: json.encode({
        'collectionRef': '_pb_users_auth_',
        'recordRef': userId,
        'password': otp,
        'sentTo': sentTo,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('OTP generated and stored successfully.');
      // Send OTP to user via email or SMS
      await _sendOtpToUser(sentTo, otp);
    } else {
      debugPrint('Failed to generate OTP. Status code: ${response.statusCode}');
      throw Exception('Failed to generate OTP. Please try again.');
    }
  }

  static String _generateOtp() {
    // Generate a random 6-digit OTP
    final random = Random();
    return (random.nextInt(900000) + 100000).toString();
  }

  static Future<void> _sendOtpToUser(String sentTo, String otp) async {
    // Implement function to send OTP to user via email or SMS
    // This is a placeholder implementation
    debugPrint('Sending OTP $otp to $sentTo');
  }

  static Future<void> verifyTwoFactorAuth(String userId, String otp) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/collections/_otps/records?filter[recordRef]=$userId&filter[password]=$otp'),
      headers: {
        'Authorization': 'Bearer ${await getAuthToken()}',
      },
    );

    final otpData = json.decode(response.body);

    if (response.statusCode == 200 && otpData.isNotEmpty) {
      debugPrint('2FA verified successfully.');
    } else {
      debugPrint('Failed to verify 2FA. Status code: ${response.statusCode}');
      throw Exception('Failed to verify 2FA. Please try again.');
    }
  }
}