import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CarouselSlider(
          items: [
            Container(
                child: Image.asset(
              'images/1.jpg',
              fit: BoxFit.cover,
            )),
            Container(child: Image.asset('images/2.jpg', fit: BoxFit.cover)),
            Container(child: Image.asset('images/12.jpg', fit: BoxFit.cover)),
          ],
          options: CarouselOptions(
              height: 400.0,
              enableInfiniteScroll: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlay: true,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              enlargeCenterPage: true,
              animateToClosest: true),
        )
      ],
    );
  }
}
