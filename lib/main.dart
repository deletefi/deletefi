import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trade_fi/geonames_service.dart'; // Импортируем сервис GeoNames

const supabaseUrl = 'https://iopcjbwulgwkipmbufrv.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlvcGNqYnd1bGd3a2lwbWJ1ZnJ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjg3NDU4MzUsImV4cCI6MjA0NDMyMTgzNX0.MUgpbM-6XoWyr5widDGF0yQEQN3JchVD1ksIjUhXP20'; // Убедитесь, что это ваш действующий ключ

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final GeoNamesService _geoNamesService =
      GeoNamesService(); // Используем сервис

  List<dynamic> countries = [];
  String? selectedCountry; // Выбранная страна

  @override
  void initState() {
    super.initState();
    _fetchCountries(); // Загружаем страны при инициализации страницы
  }

  Future<void> _fetchCountries() async {
    try {
      final fetchedCountries = await _geoNamesService.fetchCountries();
      setState(() {
        countries =
            fetchedCountries; // Обновляем состояние с полученными странами
        selectedCountry = countries.isNotEmpty
            ? countries[0]['name']
            : null; // Устанавливаем первую страну как выбранную
      });
    } catch (e) {
      print('Ошибка при получении стран: $e');
    }
  }

  Future<void> signInWithEmail() async {
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: emailController.text,
      password: passwordController.text,
    );

    if (response.session != null) {
      print('User signed in: ${response.user!.email}');
    } else {
      print('Error signing in: Please check your credentials.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Supabase Auth & GeoNames Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: signInWithEmail,
              child: Text('Sign In with Email'),
            ),
            SizedBox(height: 20), // Отступ между элементами
            if (countries.isNotEmpty)
              DropdownButton<String>(
                value: selectedCountry,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCountry = newValue;
                  });
                },
                items:
                    countries.map<DropdownMenuItem<String>>((dynamic country) {
                  return DropdownMenuItem<String>(
                    value: country['name'],
                    child: Text(country['name']),
                  );
                }).toList(),
              ),
            if (countries.isEmpty)
              CircularProgressIndicator(), // Показать индикатор загрузки, если страны еще загружаются
          ],
        ),
      ),
    );
  }
}
