import 'package:cura_watch/core/api/dio_consumer.dart';
import 'package:cura_watch/features/auth/bloc/auth_bloc_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBlocBloc>(
      create: (context) => AuthBlocBloc(DioConsumer(Dio())),
      child: BlocConsumer<AuthBlocBloc, AuthBlocState>(
        listener: (context, state) {
          if (state is AuthBlocSuccess) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () =>
                      context.read<AuthBlocBloc>().add(AuthLogOut()),
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
            body: Center(child: Text('home screen')),
          );
        },
      ),
    );
  }
}
