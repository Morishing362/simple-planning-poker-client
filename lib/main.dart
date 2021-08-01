import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rust_app/presentation/bloc/field_bloc.dart';
import 'package:flutter_rust_app/repositories/repository.dart';
import 'package:http/http.dart' as http;

import 'presentation/bloc/page_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final httpClient = http.Client();
    final repository = BackendRepository(
      httpClient: httpClient,
    );
    return MaterialApp(
      title: 'Rust Communication App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => PageCubit()),
          BlocProvider(create: (_) => FieldBloc(repository)),
        ],
        child: BlocBuilder<PageCubit, PageState>(
          builder: (context, state) => Navigator(
            pages: state.pages,
            onPopPage: (route, result) {
              if (!route.didPop(result)) {
                return false;
              }
              context.read<PageCubit>().popPage();
              context.read<FieldBloc>().signOut();
              return true;
            },
          ),
        ),
      ),
    );
  }
}
