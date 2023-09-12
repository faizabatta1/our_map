import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'building_information_page.dart';
import 'help_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.891473, 35.181196),
    zoom: 18.5,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(31.891473, 35.181196),
      zoom: 18
  );

  Set<Polygon> _polygons = {};

  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    loadBoundaries();
    loadBuildings();
    loadRoads();
    loadParkings();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 0,

        ),
        // drawerScrimColor: Colors.yellow.withOpacity(0.4),
        endDrawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),
                accountName: Text('HQ Preventive Security'),
                accountEmail: Text('HQPS@Palestine.free'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/user_avatar.png'),
                ),
              ),
              ListTile(
                title: Text("Help"),
                leading: Icon(Icons.help),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HelpPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.satellite,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              polylines: _polylines,
              polygons: _polygons,
              markers: Set.of([
                Marker(
                    markerId: MarkerId('xx'),
                    position: LatLng(31.891473, 35.181196),
                    infoWindow: InfoWindow(
                      title: "HQ",
                    )
                ),
              ]),

            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: EdgeInsets.all(8.0),
                width: 180,
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(color: Colors.red,width: 80,height: 6,),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Text('area',style: TextStyle(fontSize: 18)),
                            margin: EdgeInsets.only(left: 10),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(color: Colors.green,width: 80,height: 6,),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Text('buildings',style: TextStyle(fontSize: 18)),
                            margin: EdgeInsets.only(left: 10),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(color: Colors.blue,width: 80,height: 6,),
                        Expanded(
                          flex: 1,
                          child: Container(
                              child: Text('routes',style: TextStyle(fontSize: 18)),
                            margin: EdgeInsets.only(left: 10),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(color: Colors.yellow,width: 80,height: 6,),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Text('parkings',style: TextStyle(fontSize: 18)),
                            margin: EdgeInsets.only(left: 10),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.moving),
          onPressed: ()async{
            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));

          },
        ),
      ),
    );
  }

  void loadBoundaries() async {

    var boundaries = await loadAsset('assets/Boundaries.json');
    var geoJson = json.decode(boundaries);

    var feature = geoJson['features'][0];
    dynamic coords = feature['geometry']['coordinates'][0];
    List<LatLng> points = [];

    for(var coord in coords) {
      points.add(LatLng(coord[1], coord[0]));
    }

    var polygon = Polygon(
        polygonId: PolygonId('xxxx'),
        points: points,
        fillColor: Colors.red.withOpacity(0.3),
      strokeWidth: 0,
      onTap: (){
          print('yyyyyyyyyyyyyyyy');
      },
      consumeTapEvents: true,
      zIndex: 4
    );
    setState(() {
      _polygons.add(polygon);
    });
  }

  void loadBuildings() async{
    var boundaries = await loadAsset('assets/Buildings.json');
    var geoJson = json.decode(boundaries);

    List features = geoJson['features'];
    for(var feature in features){
      var coords = feature['geometry']['coordinates'];
      List<LatLng> points = [];
      for(var coord in coords[0]){
        points.add(LatLng(coord[1],coord[0]));
      }
      Polygon polygon = Polygon(
        polygonId: PolygonId('${feature['properties']['id']}'),
        points: points,
        fillColor: Colors.green.withOpacity(0.5),
        strokeWidth: 0,
        onTap: (){
          navigateToBuildingInformation(buildingId:feature['properties']['id'],buildlingName:feature['properties']['name']);
        },
        consumeTapEvents: true,
        zIndex: 5,

      );

      setState(() {
        _polygons.add(polygon);
      });
    }
  }

  Future<String> loadAsset(String path) async {
    return await rootBundle.loadString(path);
  }

  navigateToBuildingInformation({required buildingId, required buildlingName}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BuildingInformationPage(id:buildingId,name:buildlingName)));
  }

  loadRoads() async{
    var boundaries = await loadAsset('assets/Roads.json');
    var geoJson = json.decode(boundaries);

    List<dynamic> features = geoJson['features'];
    features.forEach((feature) {
      List<dynamic> coords = feature['geometry']['coordinates'];
      List<LatLng> polylineCoords = coords.map((coord) => LatLng(coord[1], coord[0])).toList();
      Polyline polyline = Polyline(
        points: polylineCoords,
        color: Colors.blue,
        polylineId: PolylineId(Random().nextInt(5000).toString()),
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,

      );
      _polylines.add(polyline);
    });
    setState(() {});
  }

  loadParkings() async{
    var boundaries = await loadAsset('assets/Parkings.json');
    var geoJson = json.decode(boundaries);

    List features = geoJson['features'];
    for(var feature in features){
      var coords = feature['geometry']['coordinates'];
      List<LatLng> points = [];
      for(var i in coords){
        for(var coord in i){
          points.add(LatLng(coord[1],coord[0]));
        }
        Polygon polygon = Polygon(
          polygonId: PolygonId('${Random().nextInt(5000)}'),
          points: points,
          fillColor: Colors.yellow.withOpacity(0.5),
          strokeWidth: 0,
          onTap: (){
            navigateToBuildingInformation(buildingId:feature['properties']['id'],buildlingName:feature['properties']['name']);
          },
          consumeTapEvents: true,
          zIndex: 50,

        );

        setState(() {
          _polygons.add(polygon);
        });
      }
    }
  }
}