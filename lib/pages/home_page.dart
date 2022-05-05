import 'dart:convert';

import 'package:coin_cap/pages/details_page.dart';
import 'package:coin_cap/services/https_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget{


  @override
  State<StatefulWidget> createState() {
   return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  double? _deviceheight, _devicewidth;
  String? _selectedcoin = "bitcoin";

  HTTPService? _http;


  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {

    _deviceheight = MediaQuery.of(context).size.height;
    _devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _selctedCoinDropdown(),
                _dataWidgets(),
            ],),
          )
        )
    );
  }

  Widget _selctedCoinDropdown(){

    List<String> _coins = ["bitcoin",
    "ethereum",
    "tether",
    "cardano",
    "ripple"];
    List<DropdownMenuItem<String>> _items = 
      _coins.map((e) => DropdownMenuItem(
        value: e,
        child: Text(e ,
        style: const 
        TextStyle(color: Colors.black,
        fontSize: 40,
        fontWeight: FontWeight.w600
        )
        ),
        ),
        ).toList();

    return DropdownButton(items: _items,
      value: _selectedcoin,
      onChanged: (
        String? _value
        ){
          setState(() {
            _selectedcoin = _value!;
          });
        },
      dropdownColor:Color.fromARGB(255, 255, 210, 215),
      iconSize: 30,
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
        color : Colors.black
        ),
        underline: Container(),
      );
  }

//widget for sending the data 
  Widget _dataWidgets() {
    //we will create a future builder function for this 
    return FutureBuilder(
      future: _http!.get("/coins/$_selectedcoin"),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if(_snapshot.hasData){
            Map _data = jsonDecode(
            _snapshot.data.toString());
            num _inrprice = _data["market_data"]["current_price"]["inr"];
            num _change = _data["market_data"]["price_change_percentage_24h"];
            Map _exchangerates = _data["market_data"]["current_price"];
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  GestureDetector(
                    onDoubleTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:(BuildContext _context){
                          return DetailsPage(rates: _exchangerates);
                        },
                        ),
                      );
                    },
                    child: _coinImagewidget(_data["image"]["large"]),

                    ),
                _currenPriceWidget(_inrprice),
                _percentchangeWidget(_change),
                _descriptionCardWidget(_data["description"]["en"]),
              ]
            );
        }
        else{
          return const Center(
            child: CircularProgressIndicator(color: Color.fromARGB(255, 140, 2, 0)),
          );
        }
      },
    );
  }

  Widget _currenPriceWidget(num _rate){
    return Text(
      "${_rate.toStringAsFixed(2)} USD",
      style: const TextStyle(
        color: Color.fromARGB(255, 161, 0, 0),
        fontWeight: FontWeight.bold,
        fontSize: 30
      ),
    );
  }

  Widget _percentchangeWidget(num _change){
    return Text(
      "${_change.toString()} %",
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Color.fromARGB(255, 182, 11, 28),
      ),
    );
  }

  Widget _coinImagewidget(String _imgurl){
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _deviceheight! * .02),
      height: _deviceheight! * .15,
      width: _devicewidth! * .15,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_imgurl),
        ),
      ),
    );
  }

  Widget _descriptionCardWidget(String _description){
    return Container(
      height: _deviceheight! * .51,
      width: _devicewidth! * .90,
      margin: EdgeInsets.symmetric(
        vertical: _deviceheight! * .05,
      ),
      padding: EdgeInsets.symmetric(
        vertical: _deviceheight! * .01,
        horizontal: _devicewidth! * .01,
        ),
      color: Color.fromARGB(121, 194, 123, 123),
      child: Text(_description, style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
    );
  }
}