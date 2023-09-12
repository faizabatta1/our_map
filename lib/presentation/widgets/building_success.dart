import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_map/bloc/building_bloc/building_bloc.dart';
import 'package:our_map/bloc/floor_bloc/floor_bloc.dart';
import 'package:our_map/bloc/room_bloc/room_bloc.dart';
import 'package:our_map/bloc/section_bloc/section_bloc.dart';
import 'package:our_map/data/repositories/BuildingRepositoryImpl.dart';
import 'package:our_map/presentation/widgets/RadioSelect.dart';

import '../../data/models/Floor.dart';
import '../../data/models/Section.dart';

class BuildingSuccess extends StatefulWidget {
  final BuildingLoadingSuccess state;
  BuildingSuccess({Key? key, required this.state}) : super(key: key);

  @override
  State<BuildingSuccess> createState() => _BuildingSuccessState();
}

class _BuildingSuccessState extends State<BuildingSuccess> {
  TextEditingController floorNameController = TextEditingController();
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedValue = 0;

  int _selectedItems = 0;

  TextEditingController sectionNameController = TextEditingController();
  TextEditingController roomNameController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  int _selectedSectionItem = 0;



  @override
  void initState() {
    super.initState();
    context.read<FloorBloc>().add(
        LoadBuildingFloors(buildingId: widget.state.data['id'])
    );

    context.read<SectionBloc>().add(
        LoadSectionsEvent(
            buildingId: widget.state.data['id']
        )
    );

    context.read<RoomBloc>().add(
        LoadRoomsEvent(
            buildingId: widget.state.data['id']
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.centerLeft,
                color: Colors.teal,
                child: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios,color: Colors.white,size: 30,),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('building information',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedValue,
        onTap: (index){
          setState(() {
            _selectedValue = index;
          });

          _pageController.animateToPage(index, duration: Duration(milliseconds: 200), curve:Curves.easeIn);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'floors'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.factory),
              label: 'sections'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.g_translate),
              label: 'rooms'
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 15,),
            Text('${widget.state.data['name']}',style: TextStyle(fontSize: 30),),
            SizedBox(height: 20,),
            Expanded(
              flex: 1,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index){
                  setState(() {
                    _selectedValue = index;
                  });
                },
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('number of floors: ${context.watch<FloorBloc>().floors!.length}',style: TextStyle(fontSize: 20),),
                            IconButton(
                              onPressed: ()async{
                                await showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        title: Text('adding new Floor'),
                                        content: Container(
                                          height: 100,
                                          width: double.infinity,
                                          child: Column(
                                            children: [
                                              TextField(
                                                controller: floorNameController,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    hintText: 'floor name',
                                                    labelText: 'floor name'
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: (){
                                                Navigator.pop(context);
                                              },
                                              child: Text('cancel')
                                          ),
                                          TextButton(
                                              onPressed: () async{
                                                if(floorNameController.text.isNotEmpty){
                                                  context.read<FloorBloc>().add(
                                                      FloorCreating(floor: Floor(
                                                          buildingId: widget.state.data['id'],
                                                          name: floorNameController.text
                                                      ))
                                                  );

                                                  Navigator.pop(context);
                                                }else{
                                                  showSnackbar(message: 'please enter floor name', context: context);
                                                }
                                              },
                                              child: Text('create')
                                          )
                                        ],
                                      );
                                    }
                                );
                              },
                              icon: Icon(Icons.add,color: Colors.teal,size: 30,),
                            ),
                          ],
                        ),
                      ),
                      BlocConsumer<FloorBloc,FloorState>(
                          builder: (context,state){
                            if(state is FloorLoading){
                              return Column(
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 10,),
                                  Text('Loading Floors',style: TextStyle(fontSize: 20),)
                                ],
                              );
                            }else if(state is FloorsAreEmpty){
                              return Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(state.message,style: TextStyle(fontSize: 20),),
                                ),
                              );
                            }else if(state is FloorLoadingSuccess){
                              return Expanded(
                                flex: 1,
                                child: ListView(
                                  children: [
                                    ...state.floors.map((floor) => CustomBuildingInfoCard(element: floor,))
                                  ],
                                ),
                              );
                            }else{
                              return Container(color: Colors.red,height: 200,width: 200,);
                            }
                          },
                          listener: (context,state){

                          }
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('number of sections ${context.watch<SectionBloc>().sections.length}',style: TextStyle(fontSize: 20),),
                            IconButton(
                              icon: Icon(Icons.add,size: 30,),
                              color: Colors.teal,
                              onPressed: ()async{
                                await showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        content: Container(
                                          height: 200,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                TextField(
                                                  controller: sectionNameController,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    hintText: 'section name',
                                                    labelText: 'section name'
                                                  ),
                                                ),
                                                SizedBox(height: 10,),
                                                Container(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text('choose the floor'),
                                                ),
                                                SizedBox(height: 10,),
                                                ElevatedButton(
                                                    onPressed: ()async{
                                                      List<Floor> floors = context.read<FloorBloc>().floors!;

                                                      final int? results = await showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return MultiSelect(items: floors);
                                                        },
                                                      );
                                                      setState(() {
                                                        _selectedItems = results!;
                                                      });
                                                    },
                                                    child: Text('pick up'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        title: Text('add new section'),
                                        actions: [
                                          TextButton(
                                            child: Text('cancel'),
                                            onPressed: (){
                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: Text('create'),
                                            onPressed: (){
                                              context.read<SectionBloc>().add(
                                                SectionCreateEvent(name: sectionNameController.text,floorId:_selectedItems,buildingId:widget.state.data['id'])
                                              );

                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                );
                              },
                            )
                          ],
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: BlocBuilder<SectionBloc,SectionState>(
                            builder: (context,state){
                              if(state is SectionLoading){
                                return CircularProgressIndicator();
                              }else if(state is SectionLoadingSuccess){
                                return ListView(
                                  children: [
                                    ...state.sections.map((section){

                                      return Container(
                                        margin: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            color: Colors.teal,
                                            borderRadius: BorderRadius.circular(8.0)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex:1,
                                                    child: Container(
                                                      margin: EdgeInsets.only(left: 10),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(section.name,style: TextStyle(fontSize: 20,color: Colors.white),),
                                                        ],
                                                      ),

                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: (){
                                                      context.read<SectionBloc>().add(
                                                        SectionRemoveEvent(section: section)
                                                      );
                                                    },
                                                    icon: Icon(Icons.delete_outline,color: Colors.white,size: 30,),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                color:Colors.transparent,
                                                height: 100,
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('floor ${section.floorName}',style: TextStyle(fontSize: 20,color: Colors.white))
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),

                                  ],
                                );
                              }else if(state is SectionsAreEmpty){
                                return Center(
                                  child: Text(state.message,style: TextStyle(fontSize: 20),),
                                );
                              }else if(state is SectionRemovingFailure){
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(state.message,style: TextStyle(fontSize: 20),),
                                    TextButton(
                                      child: Text('refresh page',style: TextStyle(fontSize: 16),),
                                      onPressed: (){
                                        context.read<SectionBloc>().add(
                                          LoadSectionsEvent(buildingId: widget.state.data['id'])
                                        );
                                      },
                                    )
                                  ],
                                );
                              }else if(state is SectionLoadingFailure){
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(state.message),
                                    ElevatedButton(
                                        onPressed: (){
                                          context.read<SectionBloc>().add(
                                            LoadSectionsEvent(buildingId: widget.state.data['id'])
                                          );
                                        },
                                        child: Text('try again')
                                    )
                                  ],
                                );
                              }else{
                                return Center(
                                  child: Text('State Not Implemented'),
                                );
                              }
                            },
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('number of rooms ${context.watch<RoomBloc>().rooms.length}',style: TextStyle(fontSize: 20),),
                            IconButton(
                              icon: Icon(Icons.add,size: 30,),
                              color: Colors.teal,
                              onPressed: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context){
                                  return AlertDialog(
                                    content: Container(
                                      height: 200,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: roomNameController,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  hintText: 'room name',
                                                  labelText: 'room name'
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text('choose the section'),
                                            ),
                                            SizedBox(height: 10,),
                                            ElevatedButton(
                                              onPressed: ()async{
                                                List<Section> sections = context.read<SectionBloc>().sections;

                                                final int? results = await showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return MultiSelect(items: sections);
                                                  },
                                                );
                                                setState(() {
                                                  _selectedSectionItem = results!;
                                                });
                                              },
                                              child: Text('pick up'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    title: Text('add new room'),
                                    actions: [
                                      TextButton(
                                        child: Text('cancel'),
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: Text('create'),
                                        onPressed: (){
                                          context.read<RoomBloc>().add(
                                              RoomsCreateEvent(
                                                  name: roomNameController.text,
                                                  buildingId:widget.state.data['id'],
                                                sectionId: _selectedSectionItem,
                                                floorId:_selectedItems
                                              )
                                          );

                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                }
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: BlocBuilder<RoomBloc,RoomState>(
                          builder: (context,state){
                            if(state is RoomLoading){
                              return Center(child: CircularProgressIndicator());
                            }else if(state is RoomLoadingSuccess){
                              return ListView(
                                children: [
                                  ...state.rooms.map((room){

                                    return Container(
                                      margin: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          color: Colors.teal,
                                          borderRadius: BorderRadius.circular(8.0)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex:1,
                                                  child: Container(
                                                    margin: EdgeInsets.only(left: 10),
                                                    child: SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(room.name,style: TextStyle(fontSize: 20,color: Colors.white),),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: (){
                                                    context.read<RoomBloc>().add(
                                                        RoomsRemoveEvent(room: room)
                                                    );
                                                  },
                                                  icon: Icon(Icons.delete_outline,color: Colors.white,size: 30,),
                                                )
                                              ],
                                            ),
                                            Container(
                                              color: Colors.transparent,
                                              height: 100,
                                              width: double.infinity,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('floor ${room.floorName}',style: TextStyle(fontSize: 20,color: Colors.white)),
                                                  SizedBox(width: 10,),
                                                  Text('section ${room.sectionName}',style: TextStyle(fontSize: 20,color: Colors.white)),
                                                  Text(room.note!)
                                                ],
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.topRight,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStatePropertyAll(Colors.red),
                                                  foregroundColor: MaterialStatePropertyAll(Colors.white)
                                                ),
                                                child: Text('write note',style: TextStyle(color: Colors.white,fontSize: 20),),
                                                onPressed: ()async{
                                                  await showDialog(
                                                      context: context,
                                                      builder: (context){
                                                        return AlertDialog(
                                                          title: Text('add note to ${room.name}'),
                                                          content: TextField(
                                                            controller: _noteController,
                                                            decoration: InputDecoration(
                                                              border: OutlineInputBorder(),
                                                              hintText: 'note',
                                                              labelText: 'note'
                                                            ),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: (){
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text('cancel')
                                                            ),
                                                            TextButton(
                                                                onPressed: (){
                                                                  context.read<RoomBloc>().add(
                                                                    RoomAddNote(
                                                                        note: _noteController.text, roomId: room.id!, buildingId: widget.state.data['id'])
                                                                  );
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Text('add')
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                                ],
                              );
                            }else if(state is RoomsAreEmpty){
                              return Center(
                                child: Text(state.message,style: TextStyle(fontSize: 20),),
                              );
                            }else if(state is RoomRemovingFailure){
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(state.message,style: TextStyle(fontSize: 20),),
                                  TextButton(
                                    child: Text('refresh page',style: TextStyle(fontSize: 16),),
                                    onPressed: (){
                                      context.read<SectionBloc>().add(
                                          LoadSectionsEvent(buildingId: widget.state.data['id'])
                                      );
                                    },
                                  )
                                ],
                              );
                            }else if(state is RoomLoadingFailure){
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(state.message),
                                  ElevatedButton(
                                      onPressed: (){
                                        context.read<SectionBloc>().add(
                                            LoadSectionsEvent(buildingId: widget.state.data['id'])
                                        );
                                      },
                                      child: Text('try again')
                                  )
                                ],
                              );
                            }else{
                              return Center(
                                child: Text('State Not Implemented'),
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSnackbar({required String message,required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'ok',
          onPressed: (){
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        dismissDirection: DismissDirection.horizontal,
      )
    );
  }
}


class CustomBuildingInfoCard extends StatelessWidget{
  final element;
  CustomBuildingInfoCard({required this.element});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print(element.id);
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(8.0)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Text(element.name,style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.w600),),
            GestureDetector(
              child: Icon(Icons.delete_outline,color: Colors.white,size: 30,),
              onTap: (){
                context.read<FloorBloc>().add(
                  RemoveFloorEvent(floor: element as Floor)
                );
              },
            )
          ],
        ),
      ),
    );
  }
}