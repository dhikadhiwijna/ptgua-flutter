import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptgua_flutter/bloc/pokemon_details_cubit.dart';

class NavCubit extends Cubit<int> {
  // PokemonDetailsCubit pokemonDetailsCubit;
  // NavCubit({required this.pokemonDetailsCubit}) : super(0);
  NavCubit() : super(0);

  Future showPokemonDetails(int pokemonId) async {
    emit(pokemonId);
  }

  void popToPokedex() {
    emit(0);
  }
}
