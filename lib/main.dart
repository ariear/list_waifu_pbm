import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'List My Waifu',
      theme: ThemeData(
        fontFamily: 'Poppins'
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<dynamic>> loadJsonData() async {
    final String response = await rootBundle.loadString('assets/json/waifus.json');
    final data = await json.decode(response);
    return data["waifu_list"];
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 17, 30, 29),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.only(top: 24, left: 14, right: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daftar My Kisah',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                  future: loadJsonData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final data = snapshot.data as List<dynamic>;

                      return Expanded(
                        child: ListView.separated(
                          itemCount: data.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.zero,
                              color: Color.fromARGB(255, 38, 51, 50),
                              child: ListTile(
                                leading: data[index]['foto'] != null && data[index]['foto'] != ''
                                    ? CircleAvatar(
                                      backgroundImage: AssetImage(data[index]['foto']),
                                    )
                                    : const CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      child: Icon(Icons.person, color: Colors.white),
                                    ),
                                title: Text(
                                  data[index]['nama'],
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 38, 220, 219),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                                subtitle: Text(
                                  data[index]['anime'],
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(5, (starIndex) {
                                    final isActive = starIndex < data[index]['rating'];

                                    return Icon(
                                      isActive ? Icons.star : Icons.star_border,
                                      color: isActive ? Color.fromARGB(255, 38, 220, 219) : Colors.grey,
                                      size: 18,
                                    );
                                  }),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}