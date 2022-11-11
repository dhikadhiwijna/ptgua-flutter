// @dart=2.9
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ptgua_flutter/bloc/my_pokemon_bloc.dart';
import 'package:ptgua_flutter/bloc/nav_cubit.dart';
import 'package:ptgua_flutter/bloc/pokemon_bloc.dart';
import 'package:ptgua_flutter/bloc/pokemon_details_cubit.dart';
import 'package:ptgua_flutter/data/model/pokemon_details_model.dart';

class PokemonWidget extends StatefulWidget {
  const PokemonWidget({Key key}) : super(key: key);

  @override
  State<PokemonWidget> createState() => _PokemonWidgetState();
}

class _PokemonWidgetState extends State<PokemonWidget> {
  int _menuIndex = 0;
  int selectedPokemonId = Random().nextInt(100) + 1;

  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<PokemonDetailsCubit>(context)
        .getPokemonDetails(selectedPokemonId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonBloc, PokemonState>(
        builder: (context, pokemonState) {
      return BlocConsumer<MyPokemonBloc, ListPokemonState>(
          listener: (context, rebuiltState) {},
          builder: (context, myPokemonState) {
            return BlocBuilder<PokemonDetailsCubit, PokemonDetails>(
                builder: (context, pokemonDetails) {
              return Scaffold(
                floatingActionButton: Visibility(
                  visible: _menuIndex == 0 ? true : false,
                  child: FloatingActionButton.extended(
                    tooltip: 'Catch Random Pokemon',
                    onPressed: () async {
                      final randomNumber = Random().nextInt(100) + 1;
                      BlocProvider.of<PokemonDetailsCubit>(context)
                          .getPokemonDetails(randomNumber);
                      setState(() {
                        selectedPokemonId = randomNumber;
                        if (pokemonDetails != null) {
                          if (myPokemonState is PokemonInitial) {
                            BlocProvider.of<MyPokemonBloc>(context).add(
                                AddPokemonRequest(
                                    pokemonDetails: [pokemonDetails]));
                          } else if (myPokemonState is AddPokemonSuccess) {
                            final catchedPokemon = myPokemonState.pokemonList
                                .where((element) => element.id == randomNumber)
                                .toList();
                            final pokemonList = myPokemonState.pokemonList;
                            if (catchedPokemon.isNotEmpty) {
                              final pokemonName = pokemonDetails.name;
                              final snackBar = SnackBar(
                                duration: const Duration(seconds: 1),
                                content: Text(
                                    "Oh no! You catch $pokemonName, You already have it!"),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              pokemonList.add(pokemonDetails);

                              BlocProvider.of<MyPokemonBloc>(context).add(
                                  AddPokemonRequest(
                                      pokemonDetails: pokemonList));
                            }
                          }
                          final pokemonName = pokemonDetails.name;
                          final snackBar = SnackBar(
                            duration: const Duration(seconds: 1),
                            content: Text("Yay! You Catch $pokemonName!"),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    },
                    label: pokemonDetails == null
                        ? const Text("Catch Random Pokemon")
                        : const Icon(Icons.add),
                  ),
                ),
                appBar: AppBar(
                  title: Text(_menuIndex == 0 ? "PokéDex" : "My Pokémon"),
                  backgroundColor: Colors.red,
                ),
                body: SafeArea(
                    child: _menuIndex == 0
                        ? pokemonState is PokemonLoadInProgress
                            ? const Center(child: CircularProgressIndicator())
                            : pokemonState is PokemonLoadSuccess
                                ? Expanded(
                                    child: GridView.builder(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 1.4),
                                        itemCount:
                                            pokemonState.pokemonList.length,
                                        itemBuilder: (context, index) {
                                          handleClick() {
                                            BlocProvider.of<NavCubit>(context)
                                                .showPokemonDetails(pokemonState
                                                    .pokemonList[index].id);
                                            BlocProvider.of<
                                                        PokemonDetailsCubit>(
                                                    context)
                                                .getPokemonDetails(pokemonState
                                                    .pokemonList[index].id);
                                          }

                                          return GestureDetector(
                                            onTap: () => handleClick(),
                                            child: Hero(
                                              tag: pokemonState
                                                  .pokemonList[index].id,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 12),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.redAccent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Stack(children: [
                                                    Positioned(
                                                        top: 20,
                                                        left: 20,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      15,
                                                                  vertical: 5),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15)),
                                                          child: Text(
                                                            pokemonState
                                                                .pokemonList[
                                                                    index]
                                                                .name,
                                                            style: const TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        )),
                                                    Positioned(
                                                      bottom: -30,
                                                      right: -30,
                                                      height: 120,
                                                      width: 120,
                                                      child: Container(
                                                        width: 100,
                                                        height: 100,
                                                        decoration:
                                                            const BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: AssetImage(
                                                                "assets/pokeball.png"),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: -10,
                                                      right: -10,
                                                      height: 120,
                                                      width: 120,
                                                      child: Container(
                                                        width: 100,
                                                        height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                pokemonState
                                                                    .pokemonList[
                                                                        index]
                                                                    .pokemonImage),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                : pokemonState is PokemonLoadFailed
                                    ? Center(
                                        child:
                                            Text(pokemonState.error.toString()),
                                      )
                                    : const SizedBox()
                        : myPokemonState is AddPokemonSuccess
                            ? myPokemonState.pokemonList.isNotEmpty
                                ? GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2),
                                    itemCount:
                                        myPokemonState.pokemonList.length,
                                    itemBuilder: (context, index) {
                                      handleClick() {
                                        BlocProvider.of<NavCubit>(context)
                                            .showPokemonDetails(myPokemonState
                                                .pokemonList[index].id);
                                        BlocProvider.of<PokemonDetailsCubit>(
                                                context)
                                            .getPokemonDetails(myPokemonState
                                                .pokemonList[index].id);
                                      }

                                      return GestureDetector(
                                        onTap: () => handleClick(),
                                        child: Hero(
                                          tag: myPokemonState
                                              .pokemonList[index].id,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 12),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.redAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Stack(children: [
                                                Positioned(
                                                    top: 20,
                                                    left: 20,
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 15,
                                                          vertical: 5),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Text(
                                                        myPokemonState
                                                            .pokemonList[index]
                                                            .name,
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )),
                                                Positioned(
                                                  bottom: -30,
                                                  right: -30,
                                                  height: 120,
                                                  width: 120,
                                                  child: Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration:
                                                        const BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/pokeball.png"),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: -10,
                                                  right: -10,
                                                  height: 120,
                                                  width: 120,
                                                  child: Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            myPokemonState
                                                                .pokemonList[
                                                                    index]
                                                                .imageUrl),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                : Center(
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: 300,
                                        // color: Colors.red,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset(
                                              "assets/pokeball.png",
                                              width: 200,
                                            ),
                                            const Text(
                                                "You don't have any pokemon. Go Catch one!")
                                          ],
                                        )))
                            : Center(
                                child: Container(
                                    alignment: Alignment.center,
                                    height: 300,
                                    // color: Colors.red,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Image.asset(
                                          "assets/pokeball.png",
                                          width: 200,
                                        ),
                                        const Text(
                                            "You don't have any pokemon. Get your first Pokemon!")
                                      ],
                                    )))),
                bottomNavigationBar: Container(
                  height: 90,
                  color: Colors.black,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: GNav(
                        backgroundColor: Colors.black,
                        color: Colors.white,
                        activeColor: Colors.white,
                        tabBackgroundColor: Colors.red,
                        padding: const EdgeInsets.all(12),
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        gap: 10,
                        onTabChange: (index) {
                          setState(() {
                            _menuIndex = index;
                          });
                        },
                        tabs: const [
                          GButton(icon: Icons.home, text: "Home"),
                          GButton(
                            icon: Icons.mode_standby_outlined,
                            text: "My Pokemon",
                          )
                        ]),
                  ),
                ),
              );
            });
          });
    });
  }
}

class PokemonStorage {
  List<PokemonDetails> items = [];

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}
