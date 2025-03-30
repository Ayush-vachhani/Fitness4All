import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('http://0.0.0.0:8090');

void logout() {
  pb.authStore.clear();
}