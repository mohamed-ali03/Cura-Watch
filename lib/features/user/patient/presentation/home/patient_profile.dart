import 'package:cura_watch/core/database/cache/cache_helper.dart';
import 'package:cura_watch/core/services/service_locator.dart';
import 'package:flutter/material.dart';

class PatientProfile extends StatelessWidget {
  const PatientProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          IconButton(
            onPressed: () {
              getIt<CacheHelper>().clearData();
              Navigator.pushNamed(context, '/');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
