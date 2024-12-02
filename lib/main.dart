import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/repositories/providers.dart';
import 'package:selaga_ver1/repositories/routes.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Token()),
      ChangeNotifierProvider(create: (context) => UserId()),
      ChangeNotifierProvider(create: (context) => SelectedDate()),
      ChangeNotifierProvider(
        create: (context) => LapanganId(),
      ),
      ChangeNotifierProvider(create: (context) => HourAvailable()),
      ChangeNotifierProvider(create: (context) => HourUnAvailable()),
      ChangeNotifierProvider(create: (context) => SelectedHour()),
      ChangeNotifierProvider(
        create: (context) => PaymentMethod(),
      ),
      ChangeNotifierProvider(
        create: (context) => OrderName(),
      ),
      ChangeNotifierProvider(
        create: (context) => BookingId(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: MyRoutes().router,
      debugShowCheckedModeBanner: false,
      title: 'SELAGA',
    );
  }
}
