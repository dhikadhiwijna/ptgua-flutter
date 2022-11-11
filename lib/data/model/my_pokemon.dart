import 'package:ptgua_flutter/data/model/pokemon_details_model.dart';

class MyPokemon {
  List<PokemonDetails>? myPokemon = [];

  addPokemon(PokemonDetails pokemonDetails) {
    return myPokemon?.addAll([pokemonDetails]);
  }
}

class MyPokemonInitial extends MyPokemon {}
