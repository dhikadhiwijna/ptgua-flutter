import 'package:flutter/material.dart';

Widget homeNoDataFirst() {
  return Center(
      child: Container(
          alignment: Alignment.center,
          height: 300,
          // color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                "assets/pokeball.png",
                width: 200,
              ),
              const Text("You don't have any pokemon. Get your first Pokemon!")
            ],
          )));
}

Widget homeNoData() {
  return Center(
      child: Container(
          alignment: Alignment.center,
          height: 300,
          // color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                "assets/pokeball.png",
                width: 200,
              ),
              const Text("You don't have any pokemon. Go Catch one!")
            ],
          )));
}
