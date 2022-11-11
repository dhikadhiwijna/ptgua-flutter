// @dart=2.9
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptgua_flutter/bloc/my_pokemon_bloc.dart';
import 'package:ptgua_flutter/bloc/pokemon_details_cubit.dart';
import 'package:ptgua_flutter/data/model/pokemon_details_model.dart';

class PokemonDetailsWidget extends StatelessWidget {
  const PokemonDetailsWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        int selectedPokemonId = Random().nextInt(100) + 1;
        BlocProvider.of<PokemonDetailsCubit>(context)
            .getPokemonDetails(selectedPokemonId);
        return true;
      },
      child: BlocBuilder<PokemonDetailsCubit, PokemonDetails>(
          builder: (context, details) {
        return details != null
            ? Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  title: Text(details.name),
                  backgroundColor: Colors.transparent,
                ),
                backgroundColor: details != null
                    ? _pokemonColor(details.types.isNotEmpty
                        ? details?.types[0]
                        : 0.toString())
                    : Colors.white,
                body: SafeArea(
                  child: Stack(
                    children: [
                      Positioned(
                        height: MediaQuery.of(context).size.height / 1.5,
                        width: MediaQuery.of(context).size.width - 20,
                        left: 10,
                        top: MediaQuery.of(context).size.height * 0.1,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(
                                height: 70,
                              ),
                              Text(
                                details.name.toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 26),
                              ),
                              Text('Weight: ${details.weight}'),
                              Text('Height: ${details.height}'),
                              const Text(
                                "Types",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: details.types
                                      .map((e) => _pokemonTypeView(e))
                                      .toList()),
                              const Text(
                                "Description",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                details.description,
                              ),
                              SizedBox(
                                width: 200,
                                height: 45,
                                child: BlocBuilder<MyPokemonBloc,
                                        ListPokemonState>(
                                    builder: (context, state) {
                                  if (state is PokemonInitial) {
                                    return OutlinedButton(
                                        onPressed: () {
                                          BlocProvider.of<MyPokemonBloc>(
                                                  context)
                                              .add(AddPokemonRequest(
                                                  pokemonDetails: [details]));
                                          final pokemonName = details.name;
                                          final snackBar = SnackBar(
                                            duration:
                                                const Duration(seconds: 1),
                                            content: Text(
                                                "Yay! You catch $pokemonName!"),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          primary: Colors.white,
                                        ),
                                        child: const Text("Catch"));
                                  } else if (state is AddPokemonSuccess) {
                                    final catchedPokemon = state.pokemonList
                                        .where((element) =>
                                            element.id == details.id)
                                        .toList();
                                    final releasedPokemon = state.pokemonList
                                        .where((element) =>
                                            element.id != details.id)
                                        .toList();
                                    final pokemonList = state.pokemonList;
                                    addPokemonToList() async {
                                      final pokemonName = details.name;
                                      final snackBar = SnackBar(
                                        duration: const Duration(seconds: 1),
                                        content:
                                            Text("You catch $pokemonName!"),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      pokemonList.add(details);

                                      BlocProvider.of<MyPokemonBloc>(context)
                                          .add(AddPokemonRequest(
                                              pokemonDetails: pokemonList));
                                    }

                                    if (catchedPokemon.isNotEmpty) {
                                      return OutlinedButton(
                                          onPressed: () {
                                            final pokemonName = details.name;
                                            final snackBar = SnackBar(
                                              duration:
                                                  const Duration(seconds: 1),
                                              content: Text(
                                                  "You released $pokemonName!"),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                            state.pokemonList.add(details);
                                            BlocProvider.of<MyPokemonBloc>(
                                                    context)
                                                .add(AddPokemonRequest(
                                                    pokemonDetails:
                                                        releasedPokemon));
                                          },
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            primary: Colors.white,
                                          ),
                                          child: const Text("Release"));
                                    }
                                    return OutlinedButton(
                                        onPressed: () {
                                          addPokemonToList();
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          primary: Colors.white,
                                        ),
                                        child: const Text("Catch"));
                                  } else {
                                    return const SizedBox();
                                  }
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Hero(
                            tag: details.id,
                            child: details.imageUrl.isNotEmpty
                                ? Container(
                                    width: 230,
                                    height: 230,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(details.imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : const SizedBox()),
                      )
                    ],
                  ),
                ),
              )
            : const Center(child: Text("no"));
      }),
    );
  }
}

_pokemonColor(String type) {
  Color color;

  switch (type) {
    case 'normal':
      color = const Color(0xFFbdbeb0);
      break;
    case 'poison':
      color = const Color(0xFF995E98);
      break;
    case 'psychic':
      color = const Color(0xFFE96EB0);
      break;
    case 'grass':
      color = const Color(0xFF9CD363);
      break;
    case 'ground':
      color = const Color(0xFFE3C969);
      break;
    case 'ice':
      color = const Color(0xFFAFF4FD);
      break;
    case 'fire':
      color = const Color(0xFFE7614D);
      break;
    case 'rock':
      color = const Color(0xFFCBBD7C);
      break;
    case 'dragon':
      color = const Color(0xFF8475F7);
      break;
    case 'water':
      color = const Color(0xFF6DACF8);
      break;
    case 'bug':
      color = const Color(0xFFC5D24A);
      break;
    case 'dark':
      color = const Color(0xFF886958);
      break;
    case 'fighting':
      color = const Color(0xFF9E5A4A);
      break;
    case 'ghost':
      color = const Color(0xFF7774CF);
      break;
    case 'steel':
      color = const Color(0xFFC3C3D9);
      break;
    case 'flying':
      color = const Color(0xFF81A2F8);
      break;
    case 'fairy':
      color = const Color(0xFFEEB0FA);
      break;
    case 'electric':
      color = const Color.fromARGB(255, 255, 166, 0);
      break;
    case '0':
      color = const Color(0xFFFFFFFF);
      break;
    default:
      color = const Color(0xFFF2F2F2);
      break;
  }
  return color;
}

Widget _pokemonTypeView(String type) {
  Color color;

  switch (type) {
    case 'normal':
      color = const Color(0xFFbdbeb0);
      break;
    case 'poison':
      color = const Color(0xFF995E98);
      break;
    case 'psychic':
      color = const Color(0xFFE96EB0);
      break;
    case 'grass':
      color = const Color(0xFF9CD363);
      break;
    case 'ground':
      color = const Color(0xFFE3C969);
      break;
    case 'ice':
      color = const Color(0xFFAFF4FD);
      break;
    case 'fire':
      color = const Color(0xFFE7614D);
      break;
    case 'rock':
      color = const Color(0xFFCBBD7C);
      break;
    case 'dragon':
      color = const Color(0xFF8475F7);
      break;
    case 'water':
      color = const Color(0xFF6DACF8);
      break;
    case 'bug':
      color = const Color(0xFFC5D24A);
      break;
    case 'dark':
      color = const Color(0xFF886958);
      break;
    case 'fighting':
      color = const Color(0xFF9E5A4A);
      break;
    case 'ghost':
      color = const Color(0xFF7774CF);
      break;
    case 'steel':
      color = const Color(0xFFC3C3D9);
      break;
    case 'flying':
      color = const Color(0xFF81A2F8);
      break;
    case 'fairy':
      color = const Color(0xFFEEB0FA);
      break;
    case 'electric':
      color = Color.fromARGB(255, 255, 166, 0);
      break;
    case '0':
      color = const Color(0xFFFFFFFF);
      break;
    default:
      color = const Color(0xFFF2F2F2);
      break;
  }
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Text(
        type.toUpperCase(),
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
