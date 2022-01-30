import 'package:get/get.dart';
import 'package:flutter/material.dart';
class Controller extends GetxController {
  var fontSize = 20.obs;
  var color = Rx<Color>(Colors.black);

  void changeColor(Color c){
    color.value = c;
  }

  void increment() {
    fontSize++;
  }

  void decrement(){
    fontSize--;
  }
}
