

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const CatApp());
}

class CatApp extends StatelessWidget {
  const CatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Котик дня',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _imageUrl;
  bool _isLoading = false;

  Future<void> _loadNewCat() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://api.thecatapi.com/v1/images/search',
        ),
      );

      if (response.statusCode != 200) {
        throw Exception();
      }

      final List<dynamic> data = jsonDecode(response.body);

      if (data.isEmpty || data[0]['url'] == null) {
        throw Exception();
      }

      final String imageUrl = data[0]['url'];

      if (!mounted) return;

      setState(() {
        _imageUrl = imageUrl;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNewCat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Котик дня'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const SizedBox(
                  height: 400,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_imageUrl != null)
                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: Image.network(
                    _imageUrl!,
                    fit: BoxFit.contain,

                    // Важно для Flutter Web.
                    webHtmlElementStrategy:
                        WebHtmlElementStrategy.prefer,
                  ),
                ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _loadNewCat,
                child: const Text('Новый котик'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}