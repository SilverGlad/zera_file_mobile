import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/data/connection/connection.dart';
import '../../../../core/data/model/establishment.dart';
import '../../../../core/data/request/establishment_request.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../generated/l10n.dart';
import '../../../establishment_detail/establishment_detail.dart';
import '../establishment_list_item.dart';

class RestaurantsPageView extends StatefulWidget {
  Function _refreshList;
  Function openEnterDialog;

  @override
  _RestaurantsPageViewState createState() => _RestaurantsPageViewState();

  void refreshList() {
    _refreshList.call();
  }
}

class _RestaurantsPageViewState extends State<RestaurantsPageView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  var _loadingData = true;
  var _errorMessage = "";
  var _result = List<Establishment>.empty();

  var _locLatitude = "";
  var _locLongitude = "";

  var _locationEnabled = false;

  @override
  void initState() {
    _checkLocation();
    _setupListeners();
    super.initState();
  }

  void _setupListeners() {
    widget._refreshList = () {
      _checkLocation();
    };
  }

  void _checkLocation() async {
    var checkPermission = await Geolocator.checkPermission();
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if ((checkPermission == LocationPermission.always || checkPermission == LocationPermission.whileInUse) && serviceEnabled) {
      var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _locationEnabled = true;
        _locLatitude = position.latitude.toString() ?? "";
        _locLongitude = position.longitude.toString() ?? "";
      });
    } else {
      _locationEnabled = false;
    }

    _loadEstablishments();
  }

  void _askPermission() async {
    var checkPermission = await Geolocator.checkPermission();
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (checkPermission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    } else if (checkPermission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    } else if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }

    _checkLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: colorBackground,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 16, bottom: 60),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            !_locationEnabled ? _buildLocationView(context) : Container(),
            _loadingData || (_errorMessage.isNotEmpty && _result.isEmpty) ? _buildLoadingAndErrorView() : _buildListView(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationView(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 12, right: 12, top: 1, bottom: 1),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
        ),
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  S.of(context).home_locationMessage,
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: TextButton(
                  onPressed: _askPermission,
                  child: Text(
                    S.of(context).home_allow,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorPrimary,
                      fontWeight: fontWeightMedium,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingAndErrorView() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 56),
      alignment: Alignment.center,
      child: _errorMessage.isEmpty
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colorPrimary),
            )
          : Text(
              _errorMessage,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      primary: false,
      shrinkWrap: true,
      itemBuilder: (context, index) => EstablishmentListItem(
        index: index,
        establishment: _result[index],
        onTap: () => _navigateToDetail(context, _result[index]),
      ),
      itemCount: _result.length,
      scrollDirection: Axis.vertical,
    );
  }

  void _navigateToDetail(BuildContext context, Establishment establishment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EstablishmentDetailScreen(
          establishment: establishment,
          openEnterDialog: widget.openEnterDialog,
        ),
      ),
    );
  }

  _loadEstablishments() async {
    try {
      var response = await ConnectionUtils.provideEstablishemntsList(
        EstablishmentRequest(
          latitude: _locLatitude,
          longitude: _locLongitude,
        ),
      );

      setState(() {
        if (response.restaurantes != null && response.restaurantes.isNotEmpty) {
          _errorMessage = "";
          _result = response.restaurantes;
        } else {
          _errorMessage = response.mensagem != null && response.mensagem.isNotEmpty ? response.mensagem : "Nenhum restaurante encontrado.";
        }

        _loadingData = false;
      });
    } catch (error) {
      log("Error: $error");
      setState(() {
        _loadingData = false;
        _errorMessage = "Nenhum restaurante encontrado.";
      });
    }
  }
}
