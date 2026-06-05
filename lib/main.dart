import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/inyection_container.dart';
import 'shared/theme.dart';
import 'feats/auth/presentation/pages/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  final injectionContainer = InjectionContainer();
  injectionContainer.init();
  
  runApp(MyApp(injectionContainer: injectionContainer));
}

class MyApp extends StatelessWidget {
  final InjectionContainer injectionContainer;
  
  const MyApp({super.key, required this.injectionContainer});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: injectionContainer.authViewmodel,
        ),
        ChangeNotifierProvider.value(
          value: injectionContainer.plantasViewmodel,
        ),
      ],
      child: MaterialApp(
        title: 'PlantCare',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const LoginPage(),
      ),
    );
  }
}
