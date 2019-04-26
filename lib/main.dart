import 'package:flutter/material.dart';
import 'package:movies_db_bloc/domain/providers/app_provider.dart';
import 'package:movies_db_bloc/presenter/app/app.dart';

void main() {
  print('main');
  runApp(new AppProvider(
    child: App(),
    appName: "Movies-Db",
    apiBaseUrl: "https://api.themoviedb.org/3",
    flavorName: "develop",
    secretPath: "secrets.json",
  ));
}