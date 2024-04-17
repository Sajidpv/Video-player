import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  bool darkTheme = true;
  ThemeBloc() : super(ThemeInitial()) {
    on<ThemeEvent>((event, emit) {});
    on<ThemeChangedEvent>(_themeChanged);
  }

  void _themeChanged(
    ThemeChangedEvent event,
    Emitter<ThemeState> emit,
  ) {
    darkTheme = !darkTheme;
    emit(ThemeChangedState());
  }
}
