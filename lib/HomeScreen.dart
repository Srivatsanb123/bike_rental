// ignore_for_file: use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Welcome to Bike Rental App!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MTB (Mountain Bike):',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'The MTB (Mountain Bike) is designed for adventurous riders seeking thrilling off-road experiences. It features a robust frame, advanced suspension systems, and rugged tires, making it suitable for conquering challenging terrains such as mountain trails, rocky paths, and forest tracks. With its versatile gearing options and responsive handling, the MTB offers an exhilarating ride for those passionate about outdoor exploration and adrenaline-fueled adventures.',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Normal Bicycle:',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'The Normal Bicycle is an excellent choice for everyday commuting, leisurely rides, and urban exploration. With its comfortable saddle, ergonomic handlebars, and lightweight frame, it offers a smooth and enjoyable riding experience on city streets, bike paths, and scenic routes. Whether youre commuting to work, running errands, or simply enjoying a leisurely ride in the park, the Normal Bicycle provides versatility, convenience, and comfort for riders of all ages and skill levels.',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Electric Bicycle:',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'The Electric Bicycle revolutionizes the cycling experience by combining human-powered pedaling with electric-assist technology. Ideal for commuters, fitness enthusiasts, and recreational riders alike, the Electric Bicycle offers effortless pedaling, extended range, and enhanced speed capabilities. Its integrated electric motor provides a boost when needed, making uphill climbs and long-distance rides more manageable and enjoyable. Experience the convenience, versatility, and eco-friendly benefits of the Electric Bicycle for a seamless and efficient riding experience.',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
