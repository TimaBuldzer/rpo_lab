import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rpo/screens/models/EntityModel.dart';
import 'package:weather/weather.dart';

import '../../constants.dart';

class EntitiesPageScreen extends StatefulWidget {
  const EntitiesPageScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EntitiesPageScreen> createState() => _EntitiesPageScreenState();
}

class _EntitiesPageScreenState extends State<EntitiesPageScreen> {
  List<ListTile> entites = [];

  Future<String> getWeather(double latitude, double longitude) async {
    WeatherFactory wf =
        WeatherFactory(kWeatherFactoryApiKey, language: Language.RUSSIAN);
    Weather w = await wf.currentWeatherByLocation(latitude, longitude);
    return w.temperature!.celsius!.ceil().toString();
  }

  void getEntities(AsyncSnapshot<QuerySnapshot> snapshot) async {
    List<Entity> entities = [];
    for (var doc in snapshot.data!.docs) {
      Entity entity = Entity(
        doc['name'],
        doc['img'],
        doc['coordinates'].latitude,
        doc['coordinates'].longitude,
        '',
      );
      entity.value = await getWeather(entity.latitude, entity.longitude);
      entities.add(entity);
    }

    for (Entity entity in entities) {
      ListTile tile = ListTile(
        leading: CircleAvatar(backgroundImage: Image.network(entity.img).image),
        title: Text(entity.name),
        subtitle:
            Text('Широта: ${entity.latitude}\nДолгота: ${entity.longitude}'),
        trailing: Text('${entity.value} °C'),
      );
      setState(() {
        this.entites.add(tile);
      });
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('coords').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Text('Нету информации.');
          }
          if (snapshot.hasError) {
            return const Text('Что-то пошло не так.');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          }

          return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
              leading: CircleAvatar(
                  backgroundImage: Image.network(data['img']).image),
              title: Text(data['name']),
              subtitle: Text(
                  'Широта: ${data['coordinates'].latitude}\nДолгота: ${data['coordinates'].longitude}'),
              trailing: FutureBuilder(
                future: getWeather(data['coordinates'].latitude,
                    data['coordinates'].longitude),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return CircularProgressIndicator();
                  }
                  return Text('${snapshot.data} °C');
                },
              ),
            );
          }).toList());
        },
      ),
    );
  }
}
