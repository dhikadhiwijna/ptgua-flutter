// {
//   "count": 1154,
//   "next": "https://pokeapi.co/api/v2/pokemon?offset=7&limit=2",
//   "previous": "https://pokeapi.co/api/v2/pokemon?offset=3&limit=2",
//   "results": [
//     {
//       "name": "charizard",
//       "url": "https://pokeapi.co/api/v2/pokemon/6/"
//     },
//     {
//       "name": "squirtle",
//       "url": "https://pokeapi.co/api/v2/pokemon/7/"
//     }
//   ]
// }

// front_default:"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/132.png"

class PokemonList {
  final int id;
  final String name;

  String get pokemonImage =>
      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png";

  PokemonList({required this.id, required this.name});

  factory PokemonList.fromJson(Map<String, dynamic> json) {
    final name = json["name"];
    final url = json["url"] as String;
    final id = int.parse(url.split("/")[6]);

    return PokemonList(id: id, name: name);
  }
}

class PokemonResponse {
  late List<PokemonList> pokemonData;
  final bool canLoadNextPage;

  PokemonResponse({required this.pokemonData, required this.canLoadNextPage});

  factory PokemonResponse.fromJson(Map<String, dynamic> json) {
    final canLoadNextPage = json["next"] != null;
    final pokemonData = (json["results"] as List)
        .map((item) => PokemonList.fromJson(item))
        .toList();

    return PokemonResponse(
        pokemonData: pokemonData, canLoadNextPage: canLoadNextPage);
  }
}
