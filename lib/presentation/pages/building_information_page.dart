import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_map/presentation/widgets/building_success.dart';

import '../../bloc/building_bloc/building_bloc.dart';

class BuildingInformationPage extends StatefulWidget{
  final int id;
  final String name;
  const BuildingInformationPage({super.key, required this.id, required this.name});

  @override
  State<BuildingInformationPage> createState() => _BuildingInformationPageState();
}

class _BuildingInformationPageState extends State<BuildingInformationPage> {
  TextEditingController buildingNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BuildingBloc>().add(
        BuildingLoadInformation(id: widget.id)
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: BlocBuilder<BuildingBloc,BuildingState>(
          builder: (context,state){
            if(state is BuildingLoading){
              return const Center(child: CircularProgressIndicator());
            }else if(state is BuildingLoadingSuccess){
              return BuildingSuccess(state: state);
            }else if(state is BuildingLoadingFailure){
              return Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(state.message),
                    TextButton(
                      onPressed: (){
                        context.read<BuildingBloc>().add(
                            BuildingLoadInformation(id: widget.id)
                        );
                      },
                      child: Text('try again',style: TextStyle(fontSize: 20),),
                    )
                  ],
                ),
              );
            }else if(state is BuildingNotFound){
              return Container(
                width: double.infinity,
                color: Colors.yellow.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('there is no data about this building',style: TextStyle(fontSize: 20),),
                      SizedBox(height: 10,),
                      Text('create building now',style: TextStyle(fontSize: 16),),
                      SizedBox(height: 20,),
                      TextField(
                        controller: buildingNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'building name',
                          hintText: 'building name'
                        ),
                      ),
                      SizedBox(height: 20,),
                      ElevatedButton(
                          onPressed: (){
                            if(buildingNameController.text.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('please enter a building name'),
                                  dismissDirection: DismissDirection.horizontal,
                                )
                              );
                            }else if(buildingNameController.text.length < 6){
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('building name is very short'),
                                    dismissDirection: DismissDirection.horizontal,
                                  )
                              );
                            }else{
                              context.read<BuildingBloc>().add(
                                  BuildingInitialize(id: widget.id, name: buildingNameController.text)
                              );
                            }
                          },
                          child: Text('create'.toUpperCase(),style: TextStyle(fontSize: 20),)
                      )
                    ],
                  ),
                ),
              );
            }else{
              return Center(
                child: Text('unknown state'),
              );
            }
          },
        ),
      ),
    );
  }
}