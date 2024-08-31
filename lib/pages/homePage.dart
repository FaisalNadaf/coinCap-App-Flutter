import 'dart:convert';
import 'package:coincap_app_flutter/Services/https_Service.dart';
import 'package:coincap_app_flutter/pages/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  State<StatefulWidget> createState() {
    return _homePageState();
  }
}

class _homePageState extends State<HomePage> {
  _homePageState();

  late double _width, _height;
  String? _selectedCoin = "bitcoin";
  HTTPService? _http;

  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _coinDropDown(),
            _datacontainer(),
          ],
        ),
      )),
    );
  }

  Widget _coinDropDown() {
    List<String> _coins = ["bitcoin", "doge", "bnb", "solana", "usdc", "xrp"];
    List<DropdownMenuItem<String>> _item = _coins
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
        .toList();
    return DropdownButton(
      value: _coins.first,
      items: _item,
      onChanged: (_value) {
        setState(() {
          _selectedCoin = _value;
        });
      },
      dropdownColor: const Color.fromARGB(255, 98, 0, 255),
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      iconSize: 30,
      underline: Container(),
    );
  }

  Widget _datacontainer() {
    return FutureBuilder(
        future: _http!.get("/coins/bitcoin"),
        builder: (BuildContext _context, AsyncSnapshot _snapShot) {
          if (_snapShot.hasData) {
            Map _data = jsonDecode(
              _snapShot.data.toString(),
            );

            num _usdPrice = _data["market_data"]["current_price"]["usd"];
            num _ath_change_percentage =
                _data["market_data"]["ath_change_percentage"]["usd"];
            bool red;
            if (_ath_change_percentage.isNegative) {
              red = true;
            } else {
              red = false;
            }
            return Column(
              children: [
                GestureDetector(
                  onDoubleTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext _context) {
                          return DetailPage();
                        },
                      ),
                    );
                  },
                  child: _imgContainer(
                    _data["image"]["large"],
                  ),
                ),
                _currentPrice(_usdPrice, _ath_change_percentage, red),
                _aboutCrypto(_data["description"]["en"]),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
        });
  }

  Widget _currentPrice(num price, num ath, bool red) {
    return Column(
      children: [
        Text(
          price.toStringAsFixed(2) + " USD",
          style: const TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.w100,
          ),
        ),
        Text(
          ath.toString() + "%",
          style: TextStyle(
            fontSize: 15,
            color: red
                ? const Color.fromARGB(255, 238, 16, 0)
                : Color.fromARGB(255, 175, 175, 175),
            fontWeight: FontWeight.w100,
          ),
        )
      ],
    );
  }

  Widget _imgContainer(String img) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: _height * 0.02,
      ),
      height: _height * 0.08,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            img.toString(),
          ),
        ),
      ),
    );
  }

  Widget _aboutCrypto(String data) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: _height * 0.03),
      height: _height * 0.4,
      width: _width * 0.8,
      child: Text(
        data,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
