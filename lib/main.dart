import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:our_map/bloc/room_bloc/room_bloc.dart';
import 'package:our_map/helpers/SqlLiteHelper.dart';
import 'package:our_map/presentation/pages/HomePage.dart';

import 'bloc/building_bloc/building_bloc.dart';
import 'bloc/floor_bloc/floor_bloc.dart';
import 'bloc/section_bloc/section_bloc.dart';


requestLocationPermission() async {
  Location location = Location();
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestLocationPermission();
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BuildingBloc()),
        BlocProvider(create: (context) => FloorBloc()),
        BlocProvider(create: (context) => SectionBloc()),
        BlocProvider(create: (context) => RoomBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HQ',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: const MyHomePage(title: 'HQ Preventive Security'),
      ),
    );
  }
}


