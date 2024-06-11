import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'dart:async';

import '../widgets/bottom_app_bar.dart';
import '../services/weather_service.dart';
import '../models/city.dart';
import '../utils/utils.dart';
import 'tab_currently.dart';
import 'tab_daily.dart';
import 'tab_weekly.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/DailyChart.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class SelectedTab {
  SelectedTab._privateConstructor();

  static final SelectedTab instance = SelectedTab._privateConstructor();

  final List<ValueNotifier<bool>> isSelectedList = [
    ValueNotifier<bool>(true),
    ValueNotifier<bool>(false),
    ValueNotifier<bool>(false),
  ];
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _textFieldController = TextEditingController();
  List<City> _cities = [];
  final _textFieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  Timer? _debounce;
  final ValueNotifier<City?> _selectedCity = ValueNotifier<City?>(null);
  final ValueNotifier<String?> _errorMessage = ValueNotifier<String?>(null);
  late Future<City> _cityFuture;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _textFieldController.addListener(_handleSearch);
    _initLocationAndData();
  }

  Future<void> _initLocationAndData() async {
    await getLocation();
    _cityFuture = fetchWeatherDataSafe(_selectedCity.value, _errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    print('\x1B[33mBuild Method called\x1B[0m');
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/img/background_sized.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: _appBar(context),
        body: Center(child: _tabBarView(context)),
        bottomNavigationBar: _bottomAppBar(context)
      )
    );
  }

  void _handleSearch() async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      String query = _textFieldController.text;
      if (query.length > 1) {
        List<City> results = await fetchCitiesData(query);
        setState(() {
          _cities = results;
        });
        if (_cities.isNotEmpty && _textFieldController.text.isNotEmpty) {
          _showSearchResults(_cities);
        }
      }
    });
  }

  AppBar _appBar(BuildContext context) {
    print('\x1B[30mAppBar called\x1B[0m');
    var logger = Logger();
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      title: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
            color: Colors.white,
          ),
          Expanded(
            child: Column(
              children: [searchField(context, logger)],
            ),
          ),
          _buildVerticalDivider(),
          IconButton(
            icon: const Icon(Icons.near_me),
            color: Colors.white,
            onPressed: () async {
              _textFieldController.clear();
              _selectedCity.value = await fetchCurrentCityData();
              if (_overlayEntry != null && _overlayEntry!.mounted) {
                _overlayEntry!.remove();
                _overlayEntry = null;
                _cities = [];
              }
            },
          )
        ],
      ),
    );
  }

  TextField searchField(BuildContext context, Logger logger) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      key: _textFieldKey,
      controller: _textFieldController,
      decoration: const InputDecoration(
        hintText: 'Search location',
        hintStyle: TextStyle(color: Colors.grey),
        border: InputBorder.none,
      ),
      onTap: () {
        if (_overlayEntry != null && _overlayEntry!.mounted) {
          _overlayEntry!.remove();
          _overlayEntry = null;
        }
      },
      onSubmitted: (String value) async {
        final completer = Completer<void>();
        if (_overlayEntry != null && _overlayEntry!.mounted) {
          _overlayEntry!.remove();
          _overlayEntry = null;
        }
        try {
          if (_debounce?.isActive ?? false) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AlertDialog(
                    content: Row(
                      children: [
                        CircularProgressIndicator(),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Loading..."),
                        ),
                      ],
                    ),
                  );
                }).then((_) => {
                  if (!completer.isCompleted) {
                    completer.complete()
                  }
            });
            try {
              _selectedCity.value = await fetchTextInputCityData(_textFieldController.text);
            } catch (e) {
              if (e is SocketException) {
                _errorMessage.value =
                    'The service connection is lost, please check your internet connection or try again later';
              } else {
                _errorMessage.value =
                    'Could not find any result for the supplied address or coordinates';
              }
              _textFieldController.clear();
              //return;
            }
            _debounce?.cancel();
            _textFieldController.clear();
          } else if (_cities.isNotEmpty) {
            _debounce?.cancel();
            _overlayEntry!.remove();
            _selectedCity.value = _cities.first;
            if (_overlayEntry != null && _overlayEntry!.mounted) {
              _overlayEntry!.remove();
              _overlayEntry = null;
              _cities = [];
            } else {
              _textFieldController.clear();
              _overlayEntry!.remove();
              _selectedCity.value = await fetchCurrentCityData();
            }
          }
        } catch (e) {
          _errorMessage.value =
              'Could not find any result for the supplied address or coordinates';
          _textFieldController.clear();
        } finally {
          if (!completer.isCompleted) {
            completer.complete();
          }
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      },
    );
  }

  void _showSearchResults(List<City> cities) {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _textFieldKey.currentContext != null) {
        RenderBox renderBox =
            _textFieldKey.currentContext!.findRenderObject() as RenderBox;
        var size = renderBox.size;
        var offset = renderBox.localToGlobal(Offset.zero);
        _overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
            left: offset.dx,
            top: offset.dy + size.height,
            width: size.width,
            child: Material(
              elevation: 4.0,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.location_city),
                    trailing: const Icon(Icons.arrow_forward),
                    title: Text(cities[index].name),
                    subtitle: Text(
                        '${cities[index].region}, ${cities[index].country}'),
                    onTap: () {
                      _textFieldController.removeListener(_handleSearch);
                      _textFieldController.text = cities[index].name;
                      _textFieldController.addListener(_handleSearch);
                      _textFieldController.clear();
                      if (_overlayEntry != null &&
                          _overlayEntry!.mounted) {
                        _overlayEntry!.remove();
                        _overlayEntry = null;
                        _cities = [];
                      }
                      _selectedCity.value = cities[index];
                      FocusScope.of(context).unfocus();
                    },
                  );
                },
              ),
            ),
          ));
        Overlay.of(context).insert(_overlayEntry!);
      }
    });
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 32,
      width: 1,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }

  CustomBottomAppBar _bottomAppBar(BuildContext context) {
    return CustomBottomAppBar(
      color: Theme.of(context).colorScheme.tertiary,
      height: 80,
      tabController: _tabController,
    );
  }

  Widget _tabBarView(BuildContext context) {
    String connectionError =
        'Geolocation is not available, please enable it in your App settings';
    return ValueListenableBuilder<String?>(
      valueListenable: _errorMessage,
      builder: (BuildContext context, String? errorMessage, Widget? child) {
        if (errorMessage != null) {
          _errorMessage.value = null;
          return errorView(errorMessage);
        } else {
          return ValueListenableBuilder<City?>(
            valueListenable: _selectedCity,
            builder: (BuildContext context, City? city, Widget? child) {
              return StreamBuilder<Position?>(
                stream: positionStream().asBroadcastStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<Position?> snapshot) {
                  print("\x1B[33m selectedCity: ${_selectedCity.value?.name}\x1B[0m");
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (_selectedCity.value != null) {
                    return displayFetchedData(city, context, connectionError);
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return errorView(connectionError);
                  } else {
                    return displayFetchedData(city, context, connectionError);
                  }
                },
              );
            }
          );
        }
      }
    );
  }

  FutureBuilder<City> displayFetchedData(
      City? city, BuildContext context, String connexionError) {
    return FutureBuilder<City>(
      future: fetchWeatherDataSafe(city, _errorMessage),
      // future: _cityFuture,
      builder: (BuildContext context, AsyncSnapshot<City> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          //print(snapshot);
          return errorView(connexionError);
        } else if (!snapshot.hasData) {
          return const Text('No data available');
        } else {
          City cityWeatherData = snapshot.data!;
          return TabBarView(
            controller: _tabController,
            children: <Widget>[
              _tabViewCurrently(context, cityWeatherData),
              _tabViewToday(context, cityWeatherData),
              _tabViewWeekly(context, cityWeatherData),
            ],
          );
        }
      },
    );
  }

  Center errorView(String error) {
    return Center(
      child: Text(
        error,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.red, fontSize: 23),
      ),
    );
  }

  Tab _noCitySelected(BuildContext context) {
    return Tab(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('Currently', style: Theme.of(context).textTheme.displaySmall),
        Text('No city selected',
            style: Theme.of(context).textTheme.displaySmall),
      ]),
    );
  }

  _tabViewCurrently(BuildContext context, City? city) {
    if (city == null) {
      return _noCitySelected(context);
    } else {
      return TabCurrently(city: city);
    }
  }

  _tabViewToday(BuildContext context, City? city) {
    if (city == null) {
      return _noCitySelected(context);
    } else {
      //return DailyChart(city: city);
      return TabDaily(city: city);
    }
  }

  _tabViewWeekly(BuildContext context, City? city) {
    if (city == null) {
      return _noCitySelected(context);
    } else {
      return TabWeekly(city: city);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textFieldController.dispose();
    super.dispose();
  }
}
