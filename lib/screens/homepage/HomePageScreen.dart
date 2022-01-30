import 'package:flutter/material.dart';
import 'package:rpo/screens/entitiespage/EntitiesPageScreen.dart';
import 'package:rpo/screens/mapspage/MapsPageScreen.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int selectedIndex = 0;

  Widget getBody() {
    if (selectedIndex == 0) {
      return const EntitiesPageScreen();
    }else if(selectedIndex == 1){
      return const MapsPageScreen();
    }else{
      return const EntitiesPageScreen();
    }
  }

  void onTapHandler(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Мое супер крутое приложение!')),
      ),
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapHandler,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Сущности',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Карта',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
      ),
    );
  }
}
