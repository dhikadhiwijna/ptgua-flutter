// @dart=2.9
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptgua_flutter/data/model/pokemon_details_model.dart';
import 'package:ptgua_flutter/data/model/pokemon_info_response.dart';
import 'package:ptgua_flutter/data/model/pokemon_species_info_response.dart';
import 'package:ptgua_flutter/data/repository/pokemon_repository.dart';

class PokemonDetailsCubit extends Cubit<PokemonDetails> {
  final _pokemonRepository = PokemonRepository();
  PokemonDetailsCubit() : super(null);

  Future getPokemonDetails(int pokemonId) async {
    try {
      final response = await Future.wait([
        _pokemonRepository.getPokemonInfo(pokemonId),
        _pokemonRepository.getPokemonSpeciesInfo(pokemonId)
      ]);

      final pokemonInfo = response[0] as PokemonInfoResponse;
      final speciesInfo = response[1] as PokemonSpeciesInfoResponse;

      print(pokemonInfo.name);

      emit(PokemonDetails(
          id: pokemonInfo.id,
          name: pokemonInfo.name,
          imageUrl: pokemonInfo.imageUrl,
          types: pokemonInfo.types,
          height: pokemonInfo.height,
          weight: pokemonInfo.weight,
          description: speciesInfo.description));
    } catch (e) {
      print(pokemonId);
      throw Error();
    }
  }

  void clearPokemonDetails() => emit(PokemonDetails(
      id: 0,
      name: "",
      imageUrl: "",
      types: [],
      height: 0,
      weight: 0,
      description: ""));
}
