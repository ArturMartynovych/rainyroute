import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart' as geocod;
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rainyroute/Reusable_widgets/reusable_widget.dart';
import 'package:rainyroute/Screens/signin_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rainyroute/Servises/weather.dart';
import 'package:rainyroute/Utils/color_utils.dart';
import 'package:rainyroute/Reusable_widgets/navbar.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:rainyroute/Utils/constants.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  WeatherModel weather = WeatherModel();

  DateTime date = DateTime.now();

  late double temperature;
  late double temperatureMin;
  late double temperatureMax;
  late String weatherIcon;
  late String cityName;
  late String dayName;
  late String weatherCondition;

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        temperatureMin = 0;
        temperatureMax = 0;
        weatherIcon = 'Error';
        cityName = '';
        weatherCondition = '';
        return;
      }
      var temp = weatherData['main']['temp'];
      temperature = temp;

      var tempMin = weatherData['main']['temp_min'];
      temperatureMin = tempMin;

      var tempMax = weatherData['main']['temp_max'];
      temperatureMax = tempMax;

      weatherIcon =
          'http://openweathermap.org/img/wn/${weatherData['weather'][0]['icon']}@4x.png';

      cityName = weatherData['name'];
      dayName = DateFormat('EEEE', 'pl').format(date);
      weatherCondition = weatherData['weather'][0]['description'];
    });
  }

  String googleAPIKey = 'YOUR_API_KEY';
  final Future<Position> _positionFuture = Geolocator.getCurrentPosition();
  // ignore: unused_field
  User? _user;

  late GoogleMapController mapController;
  static LatLng? _initialPosition;
  // ignore: unused_field
  static LatLng? _lastMapPosition = _initialPosition;

  static final CameraPosition _currentCameraPosition = CameraPosition(
    target: _initialPosition!,
    zoom: 15.4746,
  );

  late Position _currentPosition;
  String _currentAddress = '';

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  String _startAddress = '';
  String _destinationAddress = '';
  String? _placeDistance;
  String? _placeTime;
  String _mapStyle = '';

  Set<Marker> markers = {};
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/icons/icon4.png")
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  Map<PolylineId, Polyline> polylines = {};

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      _user = null;
    });
    // ignore: use_build_context_synchronously
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignInScreen()));
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  Widget _textField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required double width,
    required IconData prefixIcon,
    Widget? suffixIcon,
    required Function(String) locationCallback,
  }) {
    return SizedBox(
      width: width * 0.8,
      child: TextFormField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        cursorColor: const Color.fromARGB(255, 46, 51, 82),
        style: TextStyle(
          color: const Color.fromARGB(255, 46, 51, 82).withOpacity(0.9),
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIcon,
            color: const Color.fromARGB(255, 46, 51, 82),
          ),
          suffixIcon: suffixIcon,
          labelText: label,
          labelStyle: TextStyle(
            color: const Color.fromARGB(255, 46, 51, 82).withOpacity(0.9),
          ),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: hexStringToColor('#F7F6F4').withOpacity(0.7),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 46, 51, 82).withOpacity(0.6),
              width: 0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: hexStringToColor('#FFA957'),
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.all(15),
          hintText: hint,
        ),
        onTap: () async {
          Prediction? place = await PlacesAutocomplete.show(
            context: context,
            types: [],
            strictbounds: false,
            apiKey: googleAPIKey,
            mode: Mode.overlay,
            components: [
              Component(Component.country, "pl"),
              Component(Component.country, "ua"),
              Component(Component.country, "de"),
              Component(Component.country, "fr"),
              Component(Component.country, "es"),
            ],
          );
          if (place != null) {
            final plist = GoogleMapsPlaces(
              apiKey: googleAPIKey,
              apiHeaders: await const GoogleApiHeaders().getHeaders(),
              //from google_api_headers package
            );
            String placeid = place.placeId ?? "0";
            final detail = await plist.getDetailsByPlaceId(placeid);
            if (label == 'Start') {
              setState(() {
                _currentAddress = detail.result.formattedAddress.toString();
                controller.text = _currentAddress;
                _startAddress = _currentAddress;
              });
            }
            if (label == 'Miejsce przeznaczenia') {
              setState(() {
                _currentAddress = detail.result.formattedAddress.toString();
                controller.text = _currentAddress;
                _destinationAddress = _currentAddress;
              });
            }
          }
        },
      ),
    );
  }

  _getCurrentLocation() async {
    if (await Permission.locationWhenInUse.serviceStatus.isEnabled ||
        await Permission.locationAlways.serviceStatus.isEnabled) {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) async {
        setState(() {
          _currentPosition = position;
          _initialPosition = LatLng(position.latitude, position.longitude);
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 18.0,
              ),
            ),
          );
        });
        await _getAddress();
      }).catchError((e) {});
    }
  }

  _getAddress() async {
    try {
      List<geocod.Placemark> p = await geocod.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      geocod.Placemark place = p[0];
      setState(() {
        _currentAddress =
            "${place.street}, ${place.postalCode}, ${place.locality}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } catch (e) {
      // print(e);
    }
  }

  Future<bool> _calculateDistance() async {
    try {
      List<geocod.Location> startPlacemark =
          await geocod.locationFromAddress(_startAddress);
      List<geocod.Location> destinationPlacemark =
          await geocod.locationFromAddress(_destinationAddress);

      double startLatitude = _startAddress == _currentAddress
          ? _currentPosition.latitude
          : startPlacemark[0].latitude;

      double startLongitude = _startAddress == _currentAddress
          ? _currentPosition.longitude
          : startPlacemark[0].longitude;

      double destinationLatitude = destinationPlacemark[0].latitude;
      double destinationLongitude = destinationPlacemark[0].longitude;

      String startCoordinatesString = '($startLatitude, $startLongitude)';
      String destinationCoordinatesString =
          '($destinationLatitude, $destinationLongitude)';

      Marker startMarker = Marker(
        markerId: MarkerId(startCoordinatesString),
        position: LatLng(startLatitude, startLongitude),
        infoWindow: InfoWindow(
          title: _startAddress,
        ),
        icon: markerIcon,
      );

      Marker destinationMarker = Marker(
        markerId: MarkerId(destinationCoordinatesString),
        position: LatLng(destinationLatitude, destinationLongitude),
        infoWindow: InfoWindow(
          title: _destinationAddress,
        ),
        icon: markerIcon,
      );

      markers.add(startMarker);
      markers.add(destinationMarker);

      double miny = (startLatitude <= destinationLatitude)
          ? startLatitude
          : destinationLatitude;
      double minx = (startLongitude <= destinationLongitude)
          ? startLongitude
          : destinationLongitude;
      double maxy = (startLatitude <= destinationLatitude)
          ? destinationLatitude
          : startLatitude;
      double maxx = (startLongitude <= destinationLongitude)
          ? destinationLongitude
          : startLongitude;

      double southWestLatitude = miny;
      double southWestLongitude = minx;

      double northEastLatitude = maxy;
      double northEastLongitude = maxx;

      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(northEastLatitude, northEastLongitude),
            southwest: LatLng(southWestLatitude, southWestLongitude),
          ),
          100.0,
        ),
      );

      await _getRoutes();

      return true;
    } catch (e) {
      // print(e);
    }
    return false;
  }

  _getRoutes() async {
    List<geocod.Location> startPlacemark =
        await geocod.locationFromAddress(_startAddress);
    double originLatitude = _startAddress == _currentAddress
        ? _currentPosition.latitude
        : startPlacemark[0].latitude;

    double originLongitude = _startAddress == _currentAddress
        ? _currentPosition.longitude
        : startPlacemark[0].longitude;

    LatLng originCoordinates = LatLng(originLatitude, originLongitude);

    List<geocod.Location> destinationPlacemark =
        await geocod.locationFromAddress(_destinationAddress);

    double destinationLatitude = destinationPlacemark[0].latitude;
    double destinationLongitude = destinationPlacemark[0].longitude;

    LatLng destinationCoordinates =
        LatLng(destinationLatitude, destinationLongitude);

    Uri url = Uri.https(
      "maps.googleapis.com",
      "/maps/api/directions/json",
      {
        "origin": _startAddress,
        "destination": _destinationAddress,
        "alternatives": 'true',
        "key": googleAPIKey,
        "language": 'pl',
        // "mode": 'driving',
      },
    );

    print(url);
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    print("DANE O TRASIE: $data");

    if (data["routes"] != null) {
      List<dynamic> routes = data["routes"];

      var weatherDataStart =
          await weather.getLocationWeather(originCoordinates);
      print("WEATHER: $weatherDataStart");
      var tempStart = weatherDataStart['main']['temp'];
      var tempMinStart = weatherDataStart['main']['temp_min'];
      var tempMaxStart = weatherDataStart['main']['temp_max'];
      var pressureStart = weatherDataStart['main']['pressure'];
      var humidityStart = weatherDataStart['main']['humidity'];
      var windSpeedStart = weatherDataStart['wind']['speed'];

      var weatherDataEnd =
          await weather.getLocationWeather(destinationCoordinates);
      var tempEnd = weatherDataEnd['main']['temp'];
      var tempMinEnd = weatherDataEnd['main']['temp_min'];
      var tempMaxEnd = weatherDataEnd['main']['temp_max'];
      var pressureEnd = weatherDataEnd['main']['pressure'];
      var humidityEnd = weatherDataEnd['main']['humidity'];
      var windSpeedEnd = weatherDataEnd['wind']['speed'];

      for (var route in routes.asMap().entries) {
        final lengthOfJSONInLoop = route.value['legs'][0]['steps'].length;

        final middleLat = route.value['legs'][0]['steps']
            [(lengthOfJSONInLoop / 2).toInt()]['end_location']['lat'];
        final middleLng = route.value['legs'][0]['steps']
            [(lengthOfJSONInLoop / 2).toInt()]['end_location']['lng'];

        LatLng middleCoordinatesTEST = LatLng(middleLat, middleLng);

        var weatherDataMiddle =
            await weather.getLocationWeather(middleCoordinatesTEST);

        var weatherConditionMiddle =
            weatherDataMiddle['weather'][0]['description'];

        var tempMiddle = weatherDataMiddle['main']['temp'];
        var tempMinMiddle = weatherDataMiddle['main']['temp_min'];
        var tempMaxMiddle = weatherDataMiddle['main']['temp_max'];
        var pressureMiddle = weatherDataMiddle['main']['pressure'];
        var humidityMiddle = weatherDataMiddle['main']['humidity'];
        var windSpeedMiddle = weatherDataMiddle['wind']['speed'];

        var routeTemp = (tempStart + tempMiddle + tempEnd) / 3;
        var routeTempMin = (tempMinStart + tempMinMiddle + tempMinEnd) / 3;
        var routeTempMax = (tempMaxStart + tempMaxMiddle + tempMaxEnd) / 3;
        var routePressure =
            (((pressureStart + pressureMiddle + pressureEnd) / 3)
                    .roundToDouble()
                    .toInt())
                .toString();
        var routeHumidity =
            (((humidityStart + humidityMiddle + humidityEnd) / 3).toInt())
                .toString();
        var routeWindSpeed =
            (((windSpeedStart + windSpeedMiddle + windSpeedEnd) / 3)
                    .roundToDouble())
                .toString();

        String weatherIconMiddle =
            'http://openweathermap.org/img/wn/${weatherDataMiddle['weather'][0]['icon']}@4x.png';

        var distance = route.value['legs'][0]['distance']['text'];
        var time = route.value['legs'][0]['duration']['text'];

        List<dynamic> legs = route.value["legs"];
        List<dynamic> steps = legs[0]["steps"];
        List<LatLng> polylinePointsRoute = [];

        for (var step in steps) {
          polylinePointsRoute
              .addAll(decodePolyline(step["polyline"]["points"]));
        }

        PolylineId id = PolylineId(route.value["summary"]);
        Polyline polyline = Polyline(
          polylineId: id,
          points: polylinePointsRoute,
          color: route.key == 0
              ? hexStringToColor("007500")
              : route.key == 1
                  ? hexStringToColor('00AA00')
                  : route.key == 2
                      ? hexStringToColor('46D446')
                      : hexStringToColor('67D467'),
          width: route.key == 0
              ? 7
              : route.key == 1
                  ? 4
                  : 3,
          onTap: () async {
            routeMessage(
              context,
              distance,
              time,
              routeTemp.toInt(),
              routeTempMax.floorToDouble().toInt(),
              routeTempMin.toInt(),
              weatherIconMiddle,
              weatherConditionMiddle,
              routeHumidity,
              routePressure,
              routeWindSpeed,
            );
          },
          consumeTapEvents: true,
        );

        setState(() {
          polylines[id] = polyline;
          _placeDistance = data['routes'][0]['legs'][0]['distance']['text'];

          _placeTime = data['routes'][0]['legs'][0]['duration']['text'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    addCustomIcon();
    _getCurrentLocation();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });
    });
    rootBundle.loadString('assets/mapStyles/greyMap.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pl');
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height,
      width: width,
      child: Scaffold(
        key: _scaffoldKey,
        body: FutureBuilder(
          future: _positionFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return lottie.Lottie.asset(
                'assets/json/cloud.json',
                repeat: true,
                reverse: false,
                animate: true,
              );
            } else {
              return Stack(
                children: [
                  SafeArea(
                    child: GoogleMap(
                      initialCameraPosition: _currentCameraPosition,
                      markers: Set<Marker>.of(markers),
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      onCameraMove: _onCameraMove,
                      compassEnabled: true,
                      polylines: Set<Polyline>.of(polylines.values),
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                        mapController.setMapStyle(_mapStyle);
                      },
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ClipOval(
                            child: Material(
                              color: hexStringToColor('#8f95b9'),
                              child: InkWell(
                                splashColor: hexStringToColor(
                                    '#393E5B'), // inkwell color
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Icon(
                                    Icons.add,
                                    color: hexStringToColor('#F7F6F4'),
                                  ),
                                ),
                                onTap: () {
                                  mapController.animateCamera(
                                    CameraUpdate.zoomIn(),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ClipOval(
                            child: Material(
                              color: hexStringToColor('#8f95b9'),
                              child: InkWell(
                                splashColor: hexStringToColor('#393E5B'),
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Icon(
                                    Icons.remove,
                                    color: hexStringToColor('#F7F6F4'),
                                  ),
                                ),
                                onTap: () {
                                  mapController.animateCamera(
                                    CameraUpdate.zoomOut(),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: Color.fromARGB(255, 46, 51, 82),
                          ),
                          onPressed: () {
                            _scaffoldKey.currentState!.openDrawer();
                          },
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            elevation: 28,
                            foregroundColor:
                                const Color.fromARGB(255, 46, 51, 82),
                          ),
                          onPressed: () async {
                            List<geocod.Placemark> p =
                                await geocod.placemarkFromCoordinates(
                                    _currentPosition.latitude,
                                    _currentPosition.longitude);
                            geocod.Placemark place = p[0];
                            var weatherData =
                                await weather.getCityWeather(place.locality!);
                            updateUI(weatherData);
                            // ignore: use_build_context_synchronously
                            weatherMessage(
                              context,
                              cityName,
                              dayName,
                              temperature.roundToDouble(),
                              temperatureMax.roundToDouble(),
                              temperatureMin.roundToDouble(),
                              weatherIcon,
                              weatherCondition,
                            );
                          },
                          child: const Text('Pokaż pogodę'),
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                          ),
                          width: width * 0.9,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text(
                                  'Wybierz swoją trasę',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                const SizedBox(height: 10),
                                _textField(
                                  label: 'Start',
                                  hint: 'Wybierz punkt startowy',
                                  prefixIcon: Icons.trip_origin,
                                  suffixIcon: IconButton(
                                    icon: const Icon(
                                      Icons.my_location,
                                      color: Color.fromARGB(255, 46, 51, 82),
                                    ),
                                    onPressed: () {
                                      _getAddress();
                                      startAddressController.text =
                                          _currentAddress;
                                      _startAddress = _currentAddress;
                                    },
                                  ),
                                  controller: startAddressController,
                                  focusNode: startAddressFocusNode,
                                  width: width,
                                  locationCallback: (String value) async {
                                    setState(() {
                                      _startAddress = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                _textField(
                                    label: 'Miejsce przeznaczenia',
                                    hint: 'Wybierz punkt przeznaczenia',
                                    prefixIcon: Icons.sports_score_outlined,
                                    controller: destinationAddressController,
                                    focusNode: desrinationAddressFocusNode,
                                    width: width,
                                    locationCallback: (String value) {
                                      setState(() {
                                        _destinationAddress = value;
                                      });
                                    }),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Visibility(
                                      visible:
                                          _placeDistance == null ? false : true,
                                      child: Text(
                                        'Odległość: $_placeDistance',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          _placeTime == null ? false : true,
                                      child: Text(
                                        'Czas: $_placeTime',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                ElevatedButton(
                                  onPressed: (_startAddress != '' &&
                                          _destinationAddress != '')
                                      ? () async {
                                          startAddressFocusNode.unfocus();
                                          desrinationAddressFocusNode.unfocus();
                                          setState(() {
                                            if (markers.isNotEmpty) {
                                              markers.clear();
                                            }
                                            if (polylines.isNotEmpty) {
                                              polylines.clear();
                                            }
                                            _placeTime = null;
                                            _placeDistance = null;
                                          });

                                          _calculateDistance();
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        hexStringToColor('#8f95b9'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Pokaż trasę'.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 10.0, bottom: 10.0),
                        child: ClipOval(
                          child: Material(
                            color: hexStringToColor('#8f95b9'),
                            child: InkWell(
                              splashColor: hexStringToColor('#393E5B'),
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    'assets/svg/navigationV2.svg',
                                    color: weatherLight,
                                    colorBlendMode: BlendMode.srcIn,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                              onTap: () {
                                mapController.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                      target: LatLng(
                                        _currentPosition.latitude,
                                        _currentPosition.longitude,
                                      ),
                                      zoom: 15.4746,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
        drawer: const NavBar(),
      ),
    );
  }
}

List<LatLng> decodePolyline(String encoded) {
  List<LatLng> poly = [];
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    LatLng point = LatLng((lat / 1E5), (lng / 1E5));
    poly.add(point);
  }
  return poly;
}
