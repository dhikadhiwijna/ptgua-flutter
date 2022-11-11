class PokemonDetails {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height;
  final int weight;
  final String description;

  PokemonDetails(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.types,
      required this.height,
      required this.weight,
      required this.description});

  toJSONEncodable() {
    Map<String, dynamic> m = {};

    m['id'] = id;
    m['name'] = name;
    m['imageUrl'] = id;
    m['types'] = name;
    m['height'] = id;
    m['weight'] = name;
    m['description'] = description;

    return m;
  }
}
