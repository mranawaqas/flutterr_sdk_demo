import 'dart:async';
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
  final _points = <Point>[];
  bool _imageLoaded = false;
  Timer? _debounceTimer;
  bool _isCameraMoving = false;

  //final _markerPositions = [];

  Position? _originalPosition;
  MapGestures _mapGestures = const MapGestures.all();

  animateCamera(Position latlng) {
    userLatLng = latlng;
    _controller.animateCamera(center: latlng, zoom: 15);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
    return Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    print("hrere");
    double screenSize = MediaQuery.of(context).size.width;
    String token = "";
    if (Platform.isAndroid) {
      token =
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxYTc2OTU3ZC0yOGRlLTRkNzktYmUzNS0xODE1YTRmNjQ5NzMiLCJzY29wZSI6WyJtYXBzIiwiYXV0b2NvbXBsZXRlIiwiZ2VvY29kZSJdLCJpYXQiOjE3NDU4NDUyODV9.O06EfF1-eg0EWjJuICstFrsHzKSPCtxJZYxXkMmkZjQ";
    } else {
      token =
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxYTc2OTU3ZC0yOGRlLTRkNzktYmUzNS0xODE1YTRmNjQ5NzMiLCJzY29wZSI6WyJtYXBzIiwiYXV0b2NvbXBsZXRlIiwiZ2VvY29kZSJdLCJpYXQiOjE3NDU4NDUyNDJ9.tz5olfEqMXOUUBUYF_IE_QXyZnwisxDUVPtDD-qWzu4";
    }
    String nightFile =
        "https://gateway.mapmetrics.org/basemaps-assets/examples/styles/NightGrid.json?token=$token";
    String lightFile =
        "https://gateway.mapmetrics.org/basemaps-assets/examples/styles/AtlasGlow.json?token=$token";
    //   String lightFile =
    //   "https://mapmetricblob.blob.core.windows.net/mapmetric/Users/jimvanderheiden/DEVPROG/protomaps/basemaps/styles/AtlasGlowMarker.json";
    // String nightFile =
    // "https://mapmetricblob.blob.core.windows.net/mapmetric/Users/jimvanderheiden/DEVPROG/protomaps/basemaps/styles/AtlasGlowMarker.json";
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(""),
        //   backgroundColor: Colors.transparent,
        //   actions: [
        //     Switch(
        //       value: widget.isDarkMode,
        //       onChanged: widget.onThemeChanged,
        //       activeColor: Colors.white,
        //       inactiveThumbColor: Colors.black,
        //     ),
        //   ],
        // ),
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: MapLibreMap(
                key: ValueKey(widget.isDarkMode),
                onMapCreated: (controller) {
                  _controller = controller;
                },
                options: MapOptions(
                  initZoom: 15,
                  initStyle: widget.isDarkMode ? nightFile : lightFile,
                  gestures: _mapGestures,
                ),
                onEvent: _onEvent,
                layers: [],
                children: [
                  WidgetLayer(
                    allowInteraction: true,
                    markers: List.generate(
                      _points.length,
                      (index) => Marker(
                        size: const Size.square(50),
                        point: _points[index].coordinates,
                        child: GestureDetector(
                          onTap: () => _onTap(index),
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: Image.asset('src/bluepin.png', scale: 3),
                          ),
                        ),
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                  ),
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

            // Top right theme switch
            Positioned(
              top: 50,
              right: 10,
              child: Switch(
                value: widget.isDarkMode,
                onChanged: widget.onThemeChanged,
                activeColor: Colors.white,
                inactiveThumbColor: Colors.black,
              ),
            ),

            // Search box
            Positioned(
              top: 120,
              left: 23,
              right: 23,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  //color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x6778849e),
                      offset: Offset(0, 10),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                    BoxShadow(color: Color(0x6778849e)),
                    BoxShadow(
                      color: Color(0x6778849e),
                      offset: Offset(0, -2),
                      blurRadius: 5,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: EditText(
                    textColor:
                        widget.isDarkMode ? Colors.white : Colors.black87,
                    focusBordercolor:
                        widget.isDarkMode ? Colors.black87 : Colors.white,
                    bordercolor:
                        widget.isDarkMode ? Colors.black87 : Colors.white,
                    backgroundColor:
                        widget.isDarkMode ? Colors.black87 : Colors.white,
                    controller: searchEditTextController,
                    textInputAction: TextInputAction.search,
                    hintText: "Search Location",
                    suffixIcon:
                        isSearched
                            ? "src/black_cross.png"
                            : "src/search_icon.png",
                    readOnly: true,
                    onTap: () async {
                      if (isSearched) {
                        setState(() {
                          _points.clear();
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
                            Position(
                              result.coordinates[0],
                              result.coordinates[1],
                            ),
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
            ),

            // Pin icon on move
            Visibility(
              visible: _isCameraMoving,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSearched = !isSearched;
                      searchEditTextController.text = "";
                    });
                  },
                  child: Image.asset('src/bluepin.png', scale: 3),
                ),
              ),
            ),

            // Logo at bottom
            Positioned(
              bottom: 80,
              left: 10,
              child: Image.asset('src/logo.png', width: 100, height: 25),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(int index) {
    HelpingMethods()
        .getAddress(
          _points[index].coordinates.lat.toDouble(),
          _points[index].coordinates.lng.toDouble(),
        )
        .then((value) => _showMarkerDetails(value?.fullAddress ?? ""));
  }

  Future<void> _showMarkerDetails(String index) async {
    await showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Details marker'),
            content: Text(index),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );

    return;
  }

  Future<void> _onEvent(MapEvent event) async {
    if (event is MapEventLongClick) {
      //final position = event.point;
      _points.clear();
      _points.add(Point(coordinates: event.point));
      isSearched = true;
      setState(() {});
      userLatLng = event.point;
      HelpingMethods()
          .getAddress(userLatLng!.lat.toDouble(), userLatLng!.lng.toDouble())
          .then((value) => searchEditTextController.text = value!.fullAddress!);
    } else if (event is MapEventStyleLoaded) {
      final response = await http.get(
        Uri.parse(
          'https://upload.wikimedia.org/wikipedia/commons/f/f2/678111-map-marker-512.png',
        ),
      );
      final bytes = response.bodyBytes;
      await event.style.addImage('marker', bytes);
      setState(() {
        _imageLoaded = true;
      });
    } else if (event is MapEventClick) {
      // setState(() {
      //   _points.add(Point(coordinates: event.point));
      // });
    } else if (event is MapEventMapCreated) {
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
      // Show the moving icon
      // if (!_isCameraMoving) {
      //   setState(() {
      //     _isCameraMoving = true;
      //   });
      // }
      if (Platform.isIOS) {
        _debounceTimer?.cancel();
        _debounceTimer = Timer(Duration(milliseconds: 200), () {
          HelpingMethods()
              .getAddress(
                userLatLng!.lat.toDouble(),
                userLatLng!.lng.toDouble(),
              )
              .then((value) {
                if (value != null) {
                  searchEditTextController.text = value.fullAddress!;
                }
              });
          // Hide the moving icon
          // setState(() {
          //   _isCameraMoving = false;
          // });
        });
      }
    } else if (event is MapEventCameraIdle || event is MapEventIdle) {
      // Hide the moving icon
      // setState(() {
      //   _isCameraMoving = false;
      // });
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
    // final theme = Theme.of(context);
    return Scaffold(
      //  backgroundColor: theme.scaffoldBackgroundColor,
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
    //print(request);
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
