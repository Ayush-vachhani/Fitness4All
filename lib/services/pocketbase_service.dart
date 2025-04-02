import 'package:pocketbase/pocketbase.dart';
import 'package:logging/logging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final pb = PocketBase(dotenv.env['SERVER_URL']!); // Use the server URL from the environment file
final _logger = Logger('PocketBaseService');

Future<void> authenticate() async {
  try {
    // ignore: unused_local_variable
    final user = await pb.collection('users').authWithPassword('your-email@example.com', 'your-password');
    _logger.info('Authenticated successfully');
  } catch (e) {
    _logger.severe('Authentication Error: $e');
  }
}

void logout() {
  pb.authStore.clear();
  _logger.info('Logged out successfully');
}

void main() {
  // Configure logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  // Example usage
  authenticate();
}