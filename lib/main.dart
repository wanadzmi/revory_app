import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revory/app.dart';
import 'package:revory/core/services/notification_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://zzxqdingxhktidqcteqi.supabase.co',
    publishableKey: 'sb_publishable_0zvt2me1rwjLyfRzJKp0bw_RxIIFiaA',
  );
  await NotificationService.initialize();
  runApp(const ProviderScope(child: RevoryApp()));
}
