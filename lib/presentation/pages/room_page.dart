import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rust_app/presentation/bloc/field_bloc.dart';
import '../../entities/entity.dart' as entity;

class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Poker Room'),
        ),
        body: const ChatRoom(),
      );
}

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) => BlocBuilder<FieldBloc, FieldState>(
        builder: (context, state) {
          final userId = context.read<FieldBloc>().repository.userId;
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.tableState.isOpen)
                  Text(state.tableState.result.toString()),
                const SizedBox(height: 32),
                Center(
                  child: CardGrid(
                    cards: state.cards,
                    isOpen: state.tableState.isOpen,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ['1', '2', '3', '5']
                      .map((number) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  context.read<FieldBloc>().cardPost(
                                      entity.Card(
                                          userId: userId, number: number));
                                },
                                child: Text(number)),
                          ))
                      .toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ['8', '13', '21', '34']
                      .map((number) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  context.read<FieldBloc>().cardPost(
                                      entity.Card(
                                          userId: userId, number: number));
                                },
                                child: Text(number)),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 32),
                if (!state.tableState.isOpen)
                  TextButton(
                    onPressed: () {
                      context.read<FieldBloc>().cardDelete();
                    },
                    child: const Text('Delete'),
                  ),
                if (userId == 'admin')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!state.tableState.isOpen)
                        TextButton(
                          onPressed: () {
                            context.read<FieldBloc>().requestRequest();
                          },
                          child: const Text('Result'),
                        ),
                      TextButton(
                        onPressed: () {
                          context.read<FieldBloc>().clean();
                        },
                        child: const Text('Clean'),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      );
}

class CardGrid extends StatelessWidget {
  const CardGrid({required this.cards, required this.isOpen, Key? key})
      : super(key: key);

  final List<entity.Card> cards;
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    final count = cards.length;
    final int rowCount = count ~/ 6;
    final mod = count % 6;

    final List<Widget> rows = [];

    for (var i = 0; i < rowCount; i++) {
      final List<Widget> row = [];
      for (var j = 0; j < 6; j++) {
        row.add(
          NumberCard(
            point: cards[i * 6 + j].number,
            userId: cards[i * 6 + j].userId,
            isOpen: isOpen,
          ),
        );
      }
      rows.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: row,
        ),
      );
    }

    final List<Widget> lastRow = [];
    for (var j = 0; j < mod; j++) {
      lastRow.add(
        NumberCard(
          point: cards[rowCount * 6 + j].number,
          userId: cards[rowCount * 6 + j].userId,
          isOpen: isOpen,
        ),
      );
    }

    rows.add(Row(
      mainAxisSize: MainAxisSize.min,
      children: lastRow,
    ));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }
}

class NumberCard extends StatelessWidget {
  const NumberCard(
      {required this.point,
      required this.userId,
      required this.isOpen,
      Key? key})
      : super(key: key);

  final String point;
  final String userId;
  final bool isOpen;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: 64,
            child: Column(
              children: [
                SizedBox(
                  height: 64,
                  child: Center(
                    child: Text(
                      isOpen ? point : '****',
                    ),
                  ),
                ),
                Text(
                  userId,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      );
}
