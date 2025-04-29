import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapmetricflutterdemo/views.dart';
import 'package:mapmetrics/mapmetrics.dart';

import 'helping_methods.dart';

Color primaryColor = Color(0xfff6f7f9);
const Color accentColor = Color(0xffEC421B);
const Color buttonBackground = Color(0xffe22620);
const Color secondaryColor = Color(0xff1C1C35);
const Color textFieldBackground = Color(0xfff7f7fa);
const Color textColor = Color(0xff2a2e43);
const Color titleColor = Color(0xff1e263f);
const Color greenColor = Color(0xff13c113);
const Color greyColor = Color(0xffb2b9c8);
const Color focusBorderColor = Color(0xff279cd9);
const Color hintColor = Color.fromRGBO(178, 185, 200, 1);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false; // Track the current theme

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black, // title and icon colors
          elevation: 0, // remove shadow if you want
          centerTitle: true, // center the title if you want
        ),
        brightness: Brightness.light,
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MyHomePage(
        title: 'Home',
        onThemeChanged: (bool value) {
          setState(() {
            isDarkMode = value;
          });
        },
        isDarkMode: isDarkMode,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  final String title;
  final ValueChanged<bool> onThemeChanged;
  final bool isDarkMode;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late MapController _controller;
  TextEditingController searchEditTextController = TextEditingController();
  Position? userLatLng;
  bool isSearched = false;

  animateCamera(Position latlng) {
    userLatLng = latlng;
    _controller.animateCamera(center: latlng, zoom: 15);
  }

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.width;
    String token = "";
    if (Platform.isAndroid) {
      token =
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxYTc2OTU3ZC0yOGRlLTRkNzktYmUzNS0xODE1YTRmNjQ5NzMiLCJzY29wZSI6WyJtYXBzIiwiYXV0b2NvbXBsZXRlIiwiZ2VvY29kZSJdLCJpYXQiOjE3NDU4NDUxODV9.DvXGM_Xz2ve1JDkrSGk9LZFXpwNTLcnSe5b4JFeMFl4";
    } else {
      token =
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxYTc2OTU3ZC0yOGRlLTRkNzktYmUzNS0xODE1YTRmNjQ5NzMiLCJzY29wZSI6WyJtYXBzIiwiYXV0b2NvbXBsZXRlIiwiZ2VvY29kZSJdLCJpYXQiOjE3NDU4NDUxODV9.DvXGM_Xz2ve1JDkrSGk9LZFXpwNTLcnSe5b4JFeMFl4";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Switch(
            value: widget.isDarkMode,
            onChanged: widget.onThemeChanged,
            activeColor: Colors.white,
            inactiveThumbColor: Colors.black,
          ),
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: MapLibreMap(
              key: ValueKey(widget.isDarkMode), // <<< ADD THIS LINE
              onMapCreated: (controller) {
                _controller = controller;
              },
              options: MapOptions(
                initZoom: 15,
                // initStyle:
                //     "https://gateway.mapmetrics.org/basemaps-assets/examples/styles/NightGrid.json?token=$token",
                initStyle:
                    widget.isDarkMode
                        ? "https://gateway.mapmetrics.org/basemaps-assets/examples/styles/NightGrid.json?token=$token"
                        : "https://gateway.mapmetrics.org/basemaps-assets/examples/styles/AtlasGlow.json?token=$token",
              ),
              onEvent: _onEvent,
              children: [
                SourceAttribution(),
                MapScalebar(),
                MapControlButtons(
                  showTrackLocation: true,
                  showZoomInOutButton: true,
                  onCurrentLocation: (location) {
                    userLatLng = location;
                    HelpingMethods()
                        .getAddress(
                          userLatLng!.lat.toDouble(),
                          userLatLng!.lng.toDouble(),
                        )
                        .then(
                          (value) =>
                              searchEditTextController.text =
                                  value!.fullAddress!,
                        );
                  },
                ),
              ],
            ),
          ),
          // Container(
          //   width: screenSize,
          //   height: 20,
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [Colors.white, Colors.white.withOpacity(0.0)],
          //       stops: [0.5, 1],
          //       end: Alignment.bottomCenter,
          //       begin: Alignment.topCenter,
          //     ),
          //   ),
          // ),
          Container(
            margin: const EdgeInsets.only(left: 23, right: 23, top: 15),
            width: screenSize,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                const BoxShadow(
                  color: Color(0x6778849e),
                  offset: Offset(0, 10),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
                const BoxShadow(color: Color(0x6778849e)),
                const BoxShadow(
                  color: Color(0x6778849e),
                  offset: Offset(0, -2),
                  blurRadius: 5,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: EditText(
                controller: searchEditTextController,
                textInputAction: TextInputAction.search,
                hintText: "Search Location",
                suffixIcon:
                    isSearched ? "src/black_cross.png" : "src/search_icon.png",
                readOnly: true,
                onTap: () async {
                  if (isSearched) {
                    setState(() {
                      isSearched = !isSearched;
                      searchEditTextController.text = "";
                    });
                  } else {
                    final sessionToken = Uuid().generateV4();
                    final Suggestion? result = await showSearch(
                      context: context,
                      delegate: AddressSearch(sessionToken),
                    );
                    if (result != null) {
                      searchEditTextController.text = result.label!;
                      animateCamera(
                        Position(result.coordinates[0], result.coordinates[1]),
                      );
                    }
                    setState(() {
                      isSearched = true;
                    });
                  }
                },
              ),
            ),
          ),
          Center(child: Image.asset('src/bluepin.png', scale: 3)),
          Positioned(
            bottom: 80,
            left: 20,
            child: Image.asset(
              'src/logo.png', // <-- your icon path here
              width: 85, // Adjust width if needed
              height: 25,
            ),
          ),
        ],
      ),
    );
  }

  void _onEvent(MapEvent event) {
    if (event is MapEventMapCreated) {
      if (event.mapController.camera != null) {
        userLatLng = event.mapController.camera!.center;
        HelpingMethods()
            .getAddress(userLatLng!.lat.toDouble(), userLatLng!.lng.toDouble())
            .then(
              (value) => searchEditTextController.text = value!.fullAddress!,
            );
      }
    } else if (event is MapEventMoveCamera) {
      userLatLng = event.camera.center;
    } else if (event is MapEventCameraIdle || event is MapEventIdle) {
      HelpingMethods()
          .getAddress(userLatLng!.lat.toDouble(), userLatLng!.lng.toDouble())
          .then((value) => searchEditTextController.text = value!.fullAddress!);
    }
  }
}

class AddressSearch extends SearchDelegate<Suggestion> {
  AddressSearch(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }

  final sessionToken;
  PlaceApiProvider? apiClient;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
        ),
        tooltip: 'Clear',
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
      ),
      tooltip: 'Back',
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, Suggestion(coordinates: []));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder(
          future:
              query == ""
                  ? null
                  : apiClient!.fetchSuggestions(
                    query,
                    Localizations.localeOf(context).languageCode,
                  ),
          builder:
              (context, snapshot) =>
                  query == ''
                      ? Container(
                        padding: EdgeInsets.all(16.0),
                        child: Text(''), //Enter your address
                      )
                      : snapshot.hasData
                      ? ListView.builder(
                        itemBuilder:
                            (context, index) => ListTile(
                              title: Text(
                                (snapshot.data![index] as Suggestion).label!,
                              ),
                              onTap: () {
                                close(
                                  context,
                                  snapshot.data![index] as Suggestion,
                                );
                              },
                            ),
                        itemCount: snapshot.data!.length,
                      )
                      : Text('Loading...'),
        ),
      ),
    );
  }
}

// For storing our result
class Suggestion {
  final String? name;
  final String? label;
  final String? street;
  final String? locality;
  final String? country;
  final String? state;
  final List<double> coordinates;

  Suggestion({
    this.name,
    this.label,
    this.locality,
    this.country,
    this.street,
    this.state,
    required this.coordinates,
  });

  // The factory constructor now expects the whole feature JSON,
  // extracting both properties and the geometry details.
  factory Suggestion.fromJson(Map<String, dynamic> featureJson) {
    final Map<String, dynamic> propertiesJson =
        featureJson['properties'] as Map<String, dynamic>;
    final Map<String, dynamic> geometryJson =
        featureJson['geometry'] as Map<String, dynamic>;

    // Extract and convert the coordinates to a List<double>
    final List<double> coords = List<double>.from(
      (geometryJson['coordinates'] as List).map((e) => (e as num).toDouble()),
    );

    return Suggestion(
      name: propertiesJson['name'],
      label: propertiesJson['label'],
      locality: propertiesJson['locality'],
      country: propertiesJson['country'],
      street: propertiesJson['borough'],
      state: propertiesJson['region'],
      coordinates: coords,
    );
  }

  @override
  String toString() {
    return 'Suggestion(label: $label, name: $name)';
  }
}

class PlaceApiProvider {
  PlaceApiProvider(this.sessionToken);

  final sessionToken;
  final String country = 'US';

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJlN2E1MjQwMi1lY2M3LTQ3MzAtYTUxOS1mZDc5MTMwMTZlNmYiLCJzY29wZSI6WyJtYXBzIiwiYXV0b2NvbXBsZXRlIiwiZ2VvY29kZSJdLCJpYXQiOjE3NDU4MzUyMTR9.VMOKZMLMWjl5G9cl4IoWZiuH9GATF-cpeA2gO7ZEuas';
    final request =
        'https://gateway.mapmetrics.org/v1/autocomplete?text=$input&token=$token';
    print(request);
    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List featuresJson = jsonResponse['features'] as List;
      final List<Suggestion> propertiesList =
          featuresJson.map((feature) => Suggestion.fromJson(feature)).toList();
      return propertiesList;
    } else {
      throw Exception(
        'Failed to fetch properties. Status Code: ${response.statusCode}',
      );
    }
  }
}

class Place {
  String? streetNumber;
  String? street;
  String? city;
  String? zipCode;
  double? lat;
  double? lng;

  Place({this.streetNumber, this.street, this.city, this.zipCode});

  @override
  String toString() {
    return 'Place(streetNumber: $streetNumber, street: $street, city: $city, zipCode: $zipCode)';
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
