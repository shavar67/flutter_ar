import 'dart:async';

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:sample_ar/constants.dart';

import 'package:vector_math/vector_math_64.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ARKitController _arKitController;
  Timer? _timer;
  ARKitPlane? plane;
  @override
  void Dispose() {
    _timer?.cancel;
    _arKitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            child: ARKitSceneView(
                showFeaturePoints: true,
                planeDetection: ARPlaneDetection.horizontal,
                onARKitViewCreated: onARKitedCreated),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.05,
                width: size.width * 0.40,
                decoration: const BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.all(Radius.circular(32))),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: blue,
                      ),
                      onPressed: () => Navigator.pop(context)),
                  const Text('Return home',
                      style: TextStyle(
                        color: blue,
                        fontWeight: FontWeight.w700,
                      )),
                  const SizedBox()
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }

  void onARKitedCreated(ARKitController controller) {
    _arKitController = controller;
    final material = ARKitMaterial(
        lightingModelName: ARKitLightingModel.lambert,
        diffuse: ARKitMaterialProperty.image('lib/images/img2.jpeg'));

    final sphere = ARKitSphere(
      materials: [material],
      radius: 0.1,
    );
    final node = ARKitNode(
      geometry: sphere,
      position: Vector3(0, 0, -0.5),
      eulerAngles: Vector3.zero(),
    );
    _arKitController.add(node);

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      final rotation = node.eulerAngles;
      rotation.x += 0.1;
      node.eulerAngles = rotation;
    });
  }
}
