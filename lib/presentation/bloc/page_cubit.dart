import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../pages/home_page.dart';

class PageState extends Equatable {
  const PageState(this.pages) : super();

  final List<MaterialPage> pages;

  @override
  List<Object?> get props => [pages];
}

class PageCubit extends Cubit<PageState> {
  PageCubit()
      : super(const PageState(
            [MaterialPage(child: HomePage(title: 'Sample App'))]));

  void toPage(MaterialPage page) {
    final pages = List.of(state.pages)..add(page);
    emit(PageState(pages));
  }

  void popPage() {
    final pages = List.of(state.pages);
    pages.removeLast();
    emit(PageState(pages));
  }
}
