import 'package:flutter/material.dart';

import 'google_maps_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
              color: Colors.indigo,
              child: const Center(
                child: Text('ARView'),
              )),
          DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.1,
              builder: (context, _scrollController) {
                return SingleChildScrollView(
                    controller: _scrollController,
                    child: Material(
                      color: Colors.white,
                      child: Column(
                        children: const [MapView()],
                      ),
                    ));
              })
        ],
      ),
    );
  }
}
