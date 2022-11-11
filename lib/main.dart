// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptgua_flutter/bloc/my_pokemon_bloc.dart';
import 'package:ptgua_flutter/bloc/nav_cubit.dart';
import 'package:ptgua_flutter/bloc/pokemon_bloc.dart';
import 'package:ptgua_flutter/bloc/pokemon_details_cubit.dart';
import 'package:ptgua_flutter/navigator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);
  final pokemonDetailsCubit = PokemonDetailsCubit();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PT GUE - Flutter Test',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  PokemonBloc()..add(PokemonPageRequest(page: 0))),
          BlocProvider(create: (context) => NavCubit()),
          BlocProvider<PokemonDetailsCubit>(
              create: (context) => PokemonDetailsCubit()),
          BlocProvider<MyPokemonBloc>(create: (context) => MyPokemonBloc()),
        ],
        child: const AppNavigator(),
      ),
    );
  }
}
