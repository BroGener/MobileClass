import 'package:flutter/material.dart';

class Lab3 extends StatelessWidget {
  const Lab3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            titleText(),
            descriptionText(),
            sectionHeader('BY MEAT'),
            meatRow(),
            sectionHeader('BY COURSE'),
            courseRow(),
            sectionHeader('BY DESSERT'),
            dessertRow(),
          ],

        ),
      ),
    );
  }
  Widget titleText() {
    return const Text(
      'BROWSE CATEGORIES',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  Widget descriptionText() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Not sure about exactly which recipe you're looking for? "
            "Do a search, or dive into our most popular categories.",
      ),
    );
  }

  Widget sectionHeader(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
  Widget meatRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        circleTextCenter(label: 'BEEF', imagePath: 'images/beef.jpg'),
        circleTextCenter(label: 'CHICKEN', imagePath: 'images/chicken.jpg'),
        circleTextCenter(label: 'PORK', imagePath: 'images/pork.jpg'),
        circleTextCenter(label: 'SEAFOOD', imagePath: 'images/seafood.jpg'),
      ],
    );
  }

  Widget courseRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        circleTextBottom(label: 'Main Dishes', imagePath: 'images/main_dishes.jpg'),
        circleTextBottom(label: 'Salad', imagePath: 'images/salad.jpg'),
        circleTextBottom(label: 'Side Dishes', imagePath: 'images/side_dishes.jpg'),
        circleTextBottom(label: 'Crockpot', imagePath: 'images/crockpot.jpg'),
      ],
    );
  }

  Widget dessertRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        circleTextBottom(label: 'Ice Cream', imagePath: 'images/icecream.jpg'),
        circleTextBottom(label: 'Brownies', imagePath: 'images/brownies.jpg'),
        circleTextBottom(label: 'Pies', imagePath: 'images/pies.jpg'),
        circleTextBottom(label: 'Cookies', imagePath: 'images/cookies.jpg'),
      ],
    );
  }

  Widget circleTextCenter({required String label, required String imagePath}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 42,
          backgroundImage: AssetImage(imagePath),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget circleTextBottom({required String label, required String imagePath}) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CircleAvatar(
          radius: 42,
          backgroundImage: AssetImage(imagePath),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

}
