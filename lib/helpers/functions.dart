import 'dart:math';

String camelize(String target){
  return "${target[0].toUpperCase()}${target.substring(1)}";
}

int generateRandomNumber({int min = 0, int max = 100}){
  Random random = new Random();
  int randomNumber = random.nextInt(max) + min;

  return randomNumber;
}