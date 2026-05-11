import 'package:supabase_flutter/supabase_flutter.dart';

class RealtimeService {
  final _supabase = Supabase.instance.client;
  RealtimeChannel? _channel;

  void startListening({
    required Function(Map<String, dynamic> payload) onNotification,
  }) {
    _channel = _supabase.channel('public:notifications');

    _channel!
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          callback: (payload) {
            onNotification(payload.newRecord);
          },
        )
        .subscribe();
  }

  void stopListening() {
    if (_channel != null) {
      _supabase.removeChannel(_channel!);
      _channel = null;
    }
  }
}
