import 'package:flutter/material.dart';
import 'package:sample_ar/ar_home_scene.dart';
import 'package:sample_ar/images/networkImge.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar:
            AppBar(elevation: 0, title: const Text('Augmented Reality Demo')),
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(children: [
            Positioned(
                top: size.width * 0.10,
                left: size.width * 0.05,
                child: Material(
                  borderRadius: const BorderRadius.all(Radius.circular(32)),
                  elevation: 12,
                  child: Container(
                    width: size.width * 0.90,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                        color: Colors.white),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SizedBox(
                              height: size.height * 0.20,
                              width: size.width * 0.25,
                              child: const Image(
                                  fit: BoxFit.contain,
                                  image: AssetImage('lib/images/img2.jpeg')),
                            ),
                          ),
                          SizedBox(
                              width: size.width * 0.25 - 56,
                              height: size.width * 0.20,
                              child: const Material(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32)),
                              )),
                          SizedBox(
                            child: Container(
                              height: size.height * 0.20,
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.purpleAccent,
                                    Colors.blueAccent
                                  ]),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(42),
                                      bottomRight: Radius.circular(32),
                                      topRight: Radius.circular(32))),
                              child: GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Home())),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Icon(Icons.view_in_ar,
                                            size: 32, color: Colors.white70),
                                      ),
                                      SizedBox(height: 5),
                                      Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Text(
                                          'View In Augmented Reality',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          )
                        ]),
                  ),
                )),
            Positioned(
                bottom: size.height * 0.07,
                left: size.width * 0.55,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => WikiAr()));
                  },
                  child: Container(
                    child: Row(children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.view_in_ar,
                            size: 32, color: Colors.white70),
                      ),
                      Text(
                        'View Mars in AR',
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.w700),
                      ),
                    ]),
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(32))),
                    width: size.width * 0.40,
                    height: size.width * .15,
                  ),
                ))
          ]),
        ));
  }
}
