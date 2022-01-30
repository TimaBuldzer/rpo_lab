import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rpo/state/settings.dart';

class SettingsPageScreen extends StatelessWidget {
  final Controller ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Изменение размера шрифта'),
            FlatButton(
              onPressed: () {
                ctrl.increment();
              },
              color: Colors.red,
              child: Text('Увеличить шрифт'),
            ),
            FlatButton(
              onPressed: () {
                ctrl.decrement();
              },
              color: Colors.green,
              child: Text('Уменьшить шрифт'),
            ),
            Text('Изменения цвета текста'),
            FlatButton(
              onPressed: () {
                ctrl.changeColor(Colors.pink);
              },
              color: Colors.pink,
              child: Text('Сделать текст розовым'),
            ),
            FlatButton(
              onPressed: () {
                ctrl.changeColor(Colors.green);
              },
              color: Colors.green,
              child: Text('Сделать текст зеленым'),
            ),
            FlatButton(
              onPressed: () {
                ctrl.changeColor(Colors.yellow);
              },
              color: Colors.yellow,
              child: Text('Сделать текст желтым'),
            ),
          ],
        ),
      ),
    );
  }
}
