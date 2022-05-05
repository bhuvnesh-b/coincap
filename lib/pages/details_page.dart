import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  //final is used for those values which will not be changed in the future
  final Map rates;

  const DetailsPage({required this.rates});

  @override
  Widget build(BuildContext context) {
    //assigning the values of the map to list
    List _currencies = rates.keys.toList();
    List _exchangerates = rates.values.toList();
    return Scaffold(body: SafeArea(
      child: ListView.builder(
        itemCount: _currencies.length,
        itemBuilder:(_context, _index) {
          String _currency = _currencies[_index].toString().toUpperCase();
          String _exchangerate = _exchangerates[_index].toString();
          return ListTile(
            
            title: Text(
              "$_currency: $_exchangerate",
              style:const TextStyle(
                fontWeight: FontWeight.w600,

              )
              ),
          );
        },
        ),
    ));
  }
}