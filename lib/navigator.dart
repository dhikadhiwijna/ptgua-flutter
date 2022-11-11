import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptgua_flutter/bloc/nav_cubit.dart';
import 'package:ptgua_flutter/bloc/pokemon_details_cubit.dart';
import 'package:ptgua_flutter/pages/pokemon_details_widget.dart';
import 'package:ptgua_flutter/pages/pokemon_widget.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavCubit, int>(
      builder: (context, pokemonId) {
        return Navigator(
          pages: [
            const MaterialPage(child: PokemonWidget()),
            if (pokemonId != 0)
              const MaterialPage(child: PokemonDetailsWidget())
          ],
          onPopPage: (route, result) {
            BlocProvider.of<NavCubit>(context).popToPokedex();
            BlocProvider.of<PokemonDetailsCubit>(context).clearPokemonDetails();
            return route.didPop(result);
          },
        );
      },

      // print(pokemonId);
    );
  }
}
