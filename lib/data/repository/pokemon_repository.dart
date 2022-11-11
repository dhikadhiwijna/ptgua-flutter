import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:ptgua_flutter/data/model/pokemon_info_response.dart';
import 'package:ptgua_flutter/data/model/pokemon_response.dart';
import 'package:ptgua_flutter/data/model/pokemon_species_info_response.dart';

class PokemonRepository {
  final baseUrl = "pokeapi.co";
  final client = http.Client();

  Future<PokemonResponse> getPokemonPage(int pageIndex) async {
    final queryParams = {
      "limit": 100.toString(),
      "offset": (pageIndex * 100).toString()
    };
    final uri = Uri.http(baseUrl, "/api/v2/pokemon", queryParams);
    final response = await client.get(uri);
    final json = await jsonDecode(response.body);

    return PokemonResponse.fromJson(json);
  }

  Future<PokemonInfoResponse> getPokemonInfo(int pokemonId) async {
    final uri = Uri.https(baseUrl, "/api/v2/pokemon/$pokemonId");

    try {
      final response = await client.get(uri);
      final json = await jsonDecode(response.body);
      return PokemonInfoResponse.fromJson(json);
    } catch (e) {
      print(e);
      throw Error();
    }
  }

  Future<PokemonSpeciesInfoResponse> getPokemonSpeciesInfo(
      int pokemonId) async {
    final uri = Uri.https(baseUrl, "/api/v2/pokemon-species/$pokemonId");

    try {
      final response = await client.get(uri);
      final json = await jsonDecode(response.body);
      return PokemonSpeciesInfoResponse.fromJson(json);
    } catch (e) {
      print(e);
      throw Error();
    }
  }
}
