import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Moedas extends StatefulWidget {
  const Moedas({Key? key}) : super(key: key);

  @override
  State<Moedas> createState() => _MoedasState();
}

class _MoedasState extends State<Moedas> {
  String baseCurrency = 'USD'; // Moeda base padrão
  Map<String, dynamic> exchangeRates = {}; // Relações monetárias

  @override
  void initState() {
    super.initState();
    fetchExchangeRates();
  }

  Future<void> fetchExchangeRates() async {
    final response = await http.get(
      Uri.parse('https://api.exchangerate-api.com/v4/latest/$baseCurrency'),
    );

    if (response.statusCode == 200) {
      setState(() {
        exchangeRates = json.decode(response.body)['rates'];
      });
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moedas'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Ocupa toda a largura da tela
            children: [
              Text('Moeda Base:'),
              Container(
                width: double.infinity, // Largura total
                child: DropdownButton<String>(
                  value: baseCurrency,
                  onChanged: (value) {
                    setState(() {
                      baseCurrency = value!;
                      fetchExchangeRates();
                    });
                  },
                  items: ['USD', 'EUR', 'BRL', 'JPY', 'CAD'] // Adicione mais moedas conforme necessário
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              Text('Relação Monetária:'),
              if (exchangeRates.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: exchangeRates.keys.map((String currency) {
                    return Text('$currency: ${exchangeRates[currency]}');
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
