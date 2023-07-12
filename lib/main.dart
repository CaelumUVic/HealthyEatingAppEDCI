import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const posSayingsStatic = [
  "Yep, that's not healthy!",
  "Great work!",
  "Great job!",
  "Well done!",
  "You nailed it!",
  "Fantastic!",
  "Impressive!",
  "Awesome work!",
  "You're a star!",
  "Brilliant!",
  "Excellent!",
  "Keep up the good work!"
];
const negSayingsStatic = [
  "No worries, try again!",
  "Keep going, you'll get it!",
  "Don't give up!",
  "You're making progress!",
  "Learning through mistakes!",
  "You're on the right path!",
  "Every attempt counts!",
  "Believe in yourself!",
  "Keep trying, you're getting there!",
  "You've got this!"
];
const badFoodsStatic = [
  'French fries',
  'Pizza',
  'Burger',
  'Hot dog',
  'Donuts',
  'Ice cream',
  'Fried chicken',
  'Potato chips',
  'Soda',
  'Candy'
];
const goodFoodsStatic = [
  'Broccoli',
  'Spinach',
  'Kale',
  'Quinoa',
  'Salmon',
  'Avocado',
  'Blueberries',
  'Greek yogurt',
  'Oatmeal',
  'Almonds'
];

// Extra Content for Intro
const verbiage = "A message from our friend ChatGPT:\n"
    "Hey there! Do you know why healthy food is so important for you? "
    "Well, I'll tell you! As ChatGPT, I say that healthy food is like magic fuel"
    "for your body. It helps you grow up strong, smart, and full of energy!\n"
    "When you eat healthy foods like fruits, vegetables, and whole grains, "
    "they give you the power to be a superhero! They have special vitamins"
    "and minerals that make your body feel good and help you stay healthy.";

// Defines the App Bar for the Entire Application
final appBar = AppBar(
    title: const Text("Eating Right",
        style: TextStyle(
            color: Colors.deepPurpleAccent,
            fontWeight: FontWeight.w800,
            fontFamily: "OpenDyslexic3",
            fontSize: 26,
            shadows: [
              Shadow(
                  color: Colors.white10,
                  offset: Offset(10.0, 10.0),
                  blurRadius: 8.0)
            ])),
    centerTitle: true,
    backgroundColor: Colors.lime);

// This function is what retrieves the food, whether or not it's bad, and
// what the file name is (the food name lowercase separated by _)
List getRandomFood(context) {
  // Bad Foods
  if (Random().nextInt(2) == 0) {
    var foodName = badFoodsStatic[Random().nextInt(badFoodsStatic.length)];
    var fileName = foodName.replaceAll(" ", "_").toLowerCase();
    return [
      Text(foodName,
          style: const TextStyle(
              fontSize: 20,
              fontFamily: "OpenDyslexic3",
              fontWeight: FontWeight.w700)),
      false,
      Image(
          image: AssetImage("assets/images/$fileName.jpg"),
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height - 400),
      foodName
    ];
  }
  // Good Foods
  else {
    var foodName = goodFoodsStatic[Random().nextInt(goodFoodsStatic.length)];
    var fileName = foodName.replaceAll(" ", "_").toLowerCase();
    return [
      Container(
          padding: const EdgeInsets.all(10),
          child: Text(foodName,
              style: const TextStyle(
                  fontSize: 20,
                  fontFamily: "OpenDyslexic3",
                  fontWeight: FontWeight.w700))),
      true,
      Image(
          image: AssetImage("assets/images/$fileName.jpg"),
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height - 400),
      foodName
    ];
  }
}

// The app initialization class, this was needed as context was going up through
// Inheritance
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Home());
  }
}

// The main home page that contains the Welcome message and start button
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: appBar,
          body: Column(children: [
            Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.topCenter,
                child: const Text("What is good to eat?",
                    style: TextStyle(
                        fontSize: 24,
                        fontFamily: "OpenDyslexic3",
                        fontWeight: FontWeight.w700))),
            Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.topCenter,
                child: const Text(verbiage,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center)),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FoodGame()));
                },
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text("Play the Game!",
                        style: TextStyle(fontSize: 20))))
          ])),
    );
  }
}

// This is a stateful wrapper for the food game, and allows me to hold the state
class FoodGame extends StatefulWidget {
  const FoodGame({super.key});
  @override
  State<FoodGame> createState() => _FoodGameState();
}

class _FoodGameState extends State<FoodGame> {
  List foodObj = [0, 0, 0, 0];
  bool firstRun = true;
  int score = 0;

  // This method is called every time the game needs to be updated, specifically
  // if the food needs to be updated
  void refresh(context) {
    setState(() {
      var oldFoodObj = foodObj;
      foodObj = getRandomFood(context);
      while (oldFoodObj[3] == foodObj[3]) {
        foodObj = getRandomFood(context);
      }
    });
  }

  // Added a congratulatory message when
  void checkIfCongratulationsAreInOrder() {
    final int maxScore = goodFoodsStatic.length + badFoodsStatic.length;
    if (score != 0 && score % maxScore == 0) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => Congratulations(score: score)));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (firstRun) {
      refresh(context);
      firstRun = false;
    }
    // Returns the main game page
    return MaterialApp(
        home: Scaffold(
            appBar: appBar,
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.topCenter,
                      child: const Text("Is this healthy?",
                          style: TextStyle(
                              fontSize: 24,
                              fontFamily: "OpenDyslexic3",
                              fontWeight: FontWeight.w700))),
                  foodObj[2],
                  foodObj[0],
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    MaterialButton(
                        onPressed: () {
                          if (!foodObj[1]) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const Incorrect()));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const Correct()));
                            refresh(context);
                            setState(() {
                              score++;
                            });
                            checkIfCongratulationsAreInOrder();
                          }
                        },
                        color: Colors.green,
                        padding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: const Image(
                            image: AssetImage("assets/buttons/thumbs_up.png"),
                            width: 100)),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                    MaterialButton(
                        onPressed: () {
                          if (foodObj[1]) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const Incorrect()));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const Correct()));
                            refresh(context);
                            setState(() {
                              score++;
                            });
                            checkIfCongratulationsAreInOrder();
                          }
                        },
                        color: Colors.lightBlue,
                        padding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: const Image(
                            image: AssetImage("assets/buttons/thumbs_down.png"),
                            width: 100)),
                  ]),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Score: $score",
                      style: const TextStyle(fontSize: 16),
                    ),
                  )
                ]))));
  }
}

// Returns a positive reinforcement given a positive outcome
String randomPositiveAffirmation() {
  return posSayingsStatic[Random().nextInt(posSayingsStatic.length)];
}

// Displays the state of a positive outcome
class Correct extends StatelessWidget {
  const Correct({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              padding: const EdgeInsets.all(10.0),
              child: Text(randomPositiveAffirmation(),
                  style: const TextStyle(
                      fontSize: 24,
                      fontFamily: "OpenDyslexic3",
                      fontWeight: FontWeight.w700,
                      color: Colors.white))),
          MaterialButton(
              child: const Image(
                  image: AssetImage("assets/buttons/next.png"), width: 100),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ]),
      ),
    ));
  }
}

// Returns a positive reinforcement given a negative outcome
String randomNegativeAffirmation() {
  return negSayingsStatic[Random().nextInt(negSayingsStatic.length)];
}

// Displays the state of a negative outcome
class Incorrect extends StatelessWidget {
  const Incorrect({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.red,
          body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(randomNegativeAffirmation(),
                      style: const TextStyle(
                          fontSize: 24,
                          fontFamily: "OpenDyslexic3",
                          fontWeight: FontWeight.w700,
                          color: Colors.white))),
              MaterialButton(
                  child: const Image(
                      image: AssetImage("assets/buttons/retry.png"),
                      width: 100),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ]),
          )),
    );
  }
}

class Congratulations extends StatelessWidget {
  int score;
  Congratulations({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                    "Wow, you've gotten $score right!\nCongratulations!",
                    style: const TextStyle(
                        fontSize: 24,
                        fontFamily: "OpenDyslexic3",
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center)),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text("Back to the Game!",
                      style: TextStyle(fontSize: 20)),
                ))
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
