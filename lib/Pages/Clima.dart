import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Clima extends StatefulWidget {
  final Function(String) onLocationChanged;

  const Clima({Key? key, required this.onLocationChanged}) : super(key: key);

  @override
  State<Clima> createState() => _ClimaState();
}

class _ClimaState extends State<Clima> {
  String apiKey = 'feccd0d50ccc5f1cf797c26c47e3779d';
  String selectedLocation = 'Selecione um estado';
  String weatherData = '';

  Future<void> fetchWeatherData(String location) async {
    final response = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$location,BR&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      setState(() {
        weatherData = response.body;
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  void _showLocationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildLocationTile('Acre'),
            _buildLocationTile('Alagoas'),
            _buildLocationTile('Amapá'),
            _buildLocationTile('Amazonas'),
            _buildLocationTile('Bahia'),
            _buildLocationTile('Ceará'),
            _buildLocationTile('Distrito Federal'),
            _buildLocationTile('Espírito Santo'),
            _buildLocationTile('Goiás'),
            _buildLocationTile('Maranhão'),
            _buildLocationTile('Mato Grosso'),
            _buildLocationTile('Mato Grosso do Sul'),
            _buildLocationTile('Minas Gerais'),
            _buildLocationTile('Pará'),
            _buildLocationTile('Paraíba'),
            _buildLocationTile('Paraná'),
            _buildLocationTile('Pernambuco'),
            _buildLocationTile('Piauí'),
            _buildLocationTile('Rio de Janeiro'),
            _buildLocationTile('Rio Grande do Norte'),
            _buildLocationTile('Rio Grande do Sul'),
            _buildLocationTile('Rondônia'),
            _buildLocationTile('Roraima'),
            _buildLocationTile('Santa Catarina'),
            _buildLocationTile('São Paulo'),
            _buildLocationTile('Sergipe'),
            _buildLocationTile('Tocantins'),
          ],
        ),
      ),
    );
  }

  void _changeLocation(BuildContext context, String newLocation) {
    widget.onLocationChanged(newLocation); // Chama a função de callback
    setState(() {
      selectedLocation = newLocation;
    });
    fetchWeatherData(selectedLocation);
    Navigator.pop(context); // Fecha o modal
  }

  Widget _buildLocationTile(String location) {
    return ListTile(
      title: Text(location),
      onTap: () {
        _changeLocation(context, location);
      },
      leading: Icon(Icons.location_city), // Adiciona um ícone ao lado do estado
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _showLocationPicker(context);
            },
          ),
        ],
      ),
      body: Center(
        child: weatherData.isEmpty
            ? CircularProgressIndicator()
            : WeatherDisplay(weatherData: weatherData),
      ),
    );
  }
}

class WeatherDisplay extends StatelessWidget {
  final String weatherData;

  const WeatherDisplay({Key? key, required this.weatherData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = json.decode(weatherData);
    final cityName = data['name'];
    final temperature = data['main']['temp'];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Cidade: $cityName'),
        Text('Temperatura: $temperature °C'),
        // Adicione mais informações conforme necessário
      ],
    );
  }
}
