import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/data/model/establishment.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/launcher_utils.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../generated/l10n.dart';
import 'facilities_list_item.dart';

class Body extends StatelessWidget {
  final Establishment establishment;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const Body({Key key, this.establishment, this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 160),
      children: [
        _buildAddressCard(context),
        _buildContactCard(context),
        _buildFacilitiesCard(context),
        _buildBusyTimeCard(context),
      ],
    );
  }

  Widget _buildAddressCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 12, right: 12, top: 12),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(9),
        ),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    S.of(context).detail_address_title,
                    style: TextStyle(fontSize: 16, fontWeight: fontWeightMedium),
                  ),
                ),
                Text(
                  S.of(context).detail_distanceLabel(establishment.dISTANCIA),
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                establishment.provideFullAddress(),
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  padding: EdgeInsets.only(left: 4, right: 4),
                  onPressed: () {
                    LauncherUtils.openMap(
                      double.parse(establishment.lATITUDELJ.replaceAll(",", ".")),
                      double.parse(establishment.lONGITUDELJ.replaceAll(",", ".")),
                    );
                  },
                  child: Text(
                    S.of(context).detail_openMap,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorPrimary,
                      fontWeight: fontWeightMedium,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 12, right: 12, top: 12),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(9),
        ),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Builder(builder: (context) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      S.of(context).detail_contact_title,
                      style: TextStyle(fontSize: 16, fontWeight: fontWeightMedium),
                    ),
                  ),
                  establishment.siteLJ.isNotEmpty
                      ? IconButton(
                          onPressed: () => _launchUrl(establishment.siteLJ, context),
                          splashRadius: 20,
                          visualDensity: VisualDensity.compact,
                          icon: Icon(
                            Icons.language_rounded,
                          ),
                        )
                      : SizedBox(),
                  establishment.facebookLJ.isNotEmpty
                      ? IconButton(
                          onPressed: () => _launchUrl(establishment.facebookLJ, context),
                          splashRadius: 20,
                          visualDensity: VisualDensity.compact,
                          icon: Icon(
                            Icons.facebook_rounded,
                          ),
                        )
                      : SizedBox(),
                  establishment.instaLJ.isNotEmpty
                      ? IconButton(
                          onPressed: () => _launchUrl(establishment.instaLJ, context),
                          splashRadius: 20,
                          visualDensity: VisualDensity.compact,
                          icon: SvgPicture.asset("assets/icons/ic_instagram.svg"),
                        )
                      : SizedBox(),
                  establishment.twitterLJ.isNotEmpty
                      ? IconButton(
                          onPressed: () => _launchUrl(establishment.twitterLJ, context),
                          splashRadius: 20,
                          visualDensity: VisualDensity.compact,
                          icon: SvgPicture.asset("assets/icons/ic_twitter.svg"),
                        )
                      : SizedBox(),
                ],
              );
            }),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                S.of(context).detail_contact_message,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    padding: EdgeInsets.only(left: 4, right: 4),
                    onPressed: () {
                      LauncherUtils.callTo(establishment.fONELJ);
                    },
                    child: Text(
                      establishment.fONELJ,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorPrimary,
                        fontWeight: fontWeightMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchUrl(String url, BuildContext context) async {
    try {
      await launch(url);
    } catch (e) {
      DialogsUtil.showAlertDialog(
        context: context,
        message: "Não foi possível abrir este link, caso o problema persista entre em contato com nossa equipe.",
        positiveButtonText: "OK",
      );
    }
  }

  Widget _buildFacilitiesCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 12, right: 12, top: 12),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(9),
        ),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 2),
            child: Text(
              S.of(context).detail_facilities_title,
              style: TextStyle(fontSize: 16, fontWeight: fontWeightMedium),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              padding: EdgeInsets.only(bottom: 8),
              height: 100,
              child: ListView.builder(
                padding: EdgeInsets.only(left: 8, right: 8),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) => _generateFacilitiesListItem(context, index),
                itemCount: 4,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _generateFacilitiesListItem(BuildContext context, int index) {
    List<IconData> _facilityIcons = [Icons.child_care, Icons.accessibility, Icons.local_parking, Icons.wifi];

    List<String> _facilityMessages = [
      S.of(context).detail_facilities_kids,
      S.of(context).detail_facilities_accesibility,
      S.of(context).detail_facilities_parking,
      S.of(context).detail_facilities_wifi,
    ];

    switch (index) {
      case 0:
        {
          if (establishment.flKidsLJ == "1") {
            return FacilitiesListItem(
              icon: _facilityIcons[index],
              message: _facilityMessages[index],
            );
          } else {
            return Container();
          }
          break;
        }
      case 1:
        {
          if (establishment.flAcessibilidadeLJ == "1") {
            return FacilitiesListItem(
              icon: _facilityIcons[index],
              message: _facilityMessages[index],
            );
          } else {
            return Container();
          }
          break;
        }
      case 2:
        {
          if (establishment.flEstacionamentoLJ == "1") {
            return FacilitiesListItem(
              icon: _facilityIcons[index],
              message: _facilityMessages[index],
            );
          } else {
            return Container();
          }
          break;
        }
      case 3:
        {
          if (establishment.flWifiLJ == "1") {
            return FacilitiesListItem(
              icon: _facilityIcons[index],
              message: _facilityMessages[index],
            );
          } else {
            return Container();
          }
          break;
        }
    }
  }

  Widget _buildBusyTimeCard(BuildContext context) {
    var busyTimeCompleted = establishment.dsFUNCIONAMENTOLJ;
    var weekday = busyTimeCompleted.split("|");

    List<String> weekdayBusyTimes = ["", "", "", "", "", "", ""];

    for (var i = 1; i < weekday.length; i++) {
      var weekdayValues = weekday[i];
      var weekdayValuesSplited = weekdayValues.split(";");
      if (weekdayValuesSplited[0] == "1") {
        weekdayBusyTimes[i - 1] = weekdayValuesSplited[1] + " - " + weekdayValuesSplited[2];
      } else {
        weekdayBusyTimes[i - 1] = S.of(context).detail_time_closed;
      }
    }

    return Card(
      margin: EdgeInsets.only(left: 12, right: 12, top: 12),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(9),
        ),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 2),
            child: Text(
              S.of(context).detail_time_title,
              style: TextStyle(fontSize: 16, fontWeight: fontWeightMedium),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //monday
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          S.of(context).weekday_monday,
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Container(width: 40),
                      Expanded(child: Text(weekdayBusyTimes[0], textAlign: TextAlign.start, style: TextStyle(fontSize: 14))),
                    ],
                  ),
                ),

                //tuesday
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          S.of(context).weekday_tuesday,
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Container(width: 40),
                      Expanded(child: Text(weekdayBusyTimes[1], textAlign: TextAlign.start, style: TextStyle(fontSize: 14))),
                    ],
                  ),
                ),

                //wednesday
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          S.of(context).weekday_wednesday,
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Container(width: 40),
                      Expanded(child: Text(weekdayBusyTimes[2], textAlign: TextAlign.start, style: TextStyle(fontSize: 14))),
                    ],
                  ),
                ),

                //thursday
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          S.of(context).weekday_thursday,
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Container(width: 40),
                      Expanded(child: Text(weekdayBusyTimes[3], textAlign: TextAlign.start, style: TextStyle(fontSize: 14))),
                    ],
                  ),
                ),

                //friday
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          S.of(context).weekday_friday,
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Container(width: 40),
                      Expanded(child: Text(weekdayBusyTimes[4], textAlign: TextAlign.start, style: TextStyle(fontSize: 14))),
                    ],
                  ),
                ),

                //saturday
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          S.of(context).weekday_saturday,
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Container(width: 40),
                      Expanded(
                        child: Text(weekdayBusyTimes[5], textAlign: TextAlign.start, style: TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                ),

                //suday
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          S.of(context).weekday_sunday,
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Container(width: 40),
                      Expanded(
                        child: Text(weekdayBusyTimes[6], textAlign: TextAlign.start, style: TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
