import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_rust_app/repositories/repository.dart';
import '../../entities/entity.dart' as entity;

class FieldState extends Equatable {
  const FieldState(this.cards, this.presence, this.tableState, this.signedIn);

  final List<entity.Card> cards;
  final List<String> presence;
  final entity.TableState tableState;
  final bool signedIn;

  @override
  List<Object?> get props => [cards, presence, tableState, signedIn];
}

abstract class FieldEvent {}

class SignedIn extends FieldEvent {}

class SignedOut extends FieldEvent {}

class CardPosted extends FieldEvent {
  CardPosted(this.cards);
  final List<entity.Card> cards;
}

class CardDeleted extends FieldEvent {
  CardDeleted(this.cards);
  final List<entity.Card> cards;
}

class ResultRequested extends FieldEvent {
  ResultRequested(this.tableState);
  final entity.TableState tableState;
}

class Cleaned extends FieldEvent {
  Cleaned(this.tableState);
  final List<entity.Card> cards = [];
  final entity.TableState tableState;
}

class FieldBloc extends Bloc<FieldEvent, FieldState> {
  FieldBloc(this.repository)
      : super(FieldState(
          const <entity.Card>[],
          const <String>[],
          entity.TableState(result: 0, isOpen: false),
          false,
        ));

  final BackendRepository repository;

  Future<void> listenField() async {
    await for (final message in repository.wsChannel!.stream) {
      final json = jsonDecode(message as String);
      if (json['proc_id'] == 'card_posted' ||
          json['proc_id'] == 'card_deleted' ||
          json['proc_id'] == 'refreshed') {
        final data = json['data'] as List;
        final cards = data
            .map((card) => entity.Card.fromJson(card as Map<String, dynamic>))
            .toList();
        add(CardPosted(cards));
      }
      if (json['proc_id'] == 'result') {
        final tableState =
            entity.TableState.fromJson(json['data'] as Map<String, dynamic>);
        add(ResultRequested(tableState));
      }
      if (json['proc_id'] == 'cleaned') {
        final tableState = entity.TableState(result: 0.0, isOpen: false);
        add(Cleaned(tableState));
      }
    }
  }

  Future<void> signIn(entity.UserData userData) async {
    final connectionUrl = await repository.register(userData);
    await repository.connect(connectionUrl);
    add(SignedIn());
  }

  void signOut() {
    repository.unregister();
    repository.disconnect();
    add(SignedOut());
  }

  void cardPost(entity.Card card) => repository.cardPost(card);

  void cardDelete() {
    final card =
        state.cards.firstWhere((card) => card.userId == repository.userId);
    repository.cardDelete(card);
  }

  void requestRequest() => repository.result();

  void clean() => repository.clean();

  void refresh() => repository.refresh();

  @override
  Stream<FieldState> mapEventToState(FieldEvent event) async* {
    if (event is SignedIn) {
      yield FieldState(
        state.cards,
        state.presence,
        state.tableState,
        true,
      );
    }
    if (event is SignedIn) {
      yield FieldState(
        state.cards,
        state.presence,
        state.tableState,
        false,
      );
    }
    if (event is CardPosted) {
      yield FieldState(
        event.cards,
        state.presence,
        state.tableState,
        state.signedIn,
      );
    }
    if (event is ResultRequested) {
      yield FieldState(
        state.cards,
        state.presence,
        event.tableState,
        state.signedIn,
      );
    }
    if (event is Cleaned) {
      yield FieldState(
        event.cards,
        state.presence,
        event.tableState,
        state.signedIn,
      );
    }
  }
}
