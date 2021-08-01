import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rust_app/presentation/bloc/field_bloc.dart';
import 'package:flutter_rust_app/presentation/bloc/page_cubit.dart';
import 'package:flutter_rust_app/repositories/repository.dart';

import '../../entities/entity.dart' as entity;
import 'room_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 256,
                child: TextField(
                  controller: _controller,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              BlocListener<FieldBloc, FieldState>(
                listener: (context, fieldState) {
                  if (fieldState.signedIn) {
                    context.read<FieldBloc>().listenField();
                    context.read<FieldBloc>().refresh();
                    context
                        .read<PageCubit>()
                        .toPage(const MaterialPage(child: ChatRoomPage()));
                  }
                },
                child: ElevatedButton(
                  onPressed: () async {
                    final text = _controller.text;
                    await context
                        .read<FieldBloc>()
                        .signIn(entity.UserData(userId: text, url: url));
                  },
                  child: const Text('Enter the room'),
                ),
              ),
            ],
          ),
        ),
      );
}
