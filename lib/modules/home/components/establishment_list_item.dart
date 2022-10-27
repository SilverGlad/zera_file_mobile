import 'package:flutter/material.dart';

import '../../../core/data/model/establishment.dart';
import '../../../core/widgets/network_image_cached.dart';
import '../../../generated/l10n.dart';

class EstablishmentListItem extends StatelessWidget {
  final Establishment establishment;
  final Function onTap;
  final int index;

  const EstablishmentListItem({
    Key key,
    this.establishment,
    this.onTap,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _establishmentOpen = establishment.statusLJ == "1";

    return Container(
      width: double.infinity,
      height: 76,
      margin: EdgeInsets.only(left: 12, right: 12, top: 1, bottom: 1),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          highlightColor: Colors.black12,
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                _buildImageContainer(context, _establishmentOpen),
                _buildInfoContainer(_establishmentOpen),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildInfoContainer(bool establishmentOpen) {
    return Expanded(
      child: Opacity(
        opacity: establishmentOpen ? 1 : 0.8,
        child: Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      establishment.nmLj,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                  ),
                  Icon(
                    Icons.location_on,
                    size: 10.0,
                    color: Colors.black54,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Text(
                      establishment.dISTANCIA,
                      style: TextStyle(fontSize: 8, color: Colors.black54),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.0),
                child: Text(
                  establishment.dsAtividadeLj,
                  style: TextStyle(fontSize: 8, color: Colors.black38),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    establishment.eNDLJ,
                    style: TextStyle(fontSize: 8, color: Colors.black38),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context, bool establishmentOpen) {
    return Stack(
      children: [
        Opacity(
          opacity: establishmentOpen ? 1 : 0.2,
          child: SizedBox(
            width: 52,
            height: 52,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: NetworkImageCached(imageUrl: establishment.uRLCAPALJ),
            ),
          ),
        ),
        !establishmentOpen
            ? SizedBox(
                width: 52,
                height: 52,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    S.of(context).detail_closed,
                    style: TextStyle(fontSize: 8, color: Colors.red, fontWeight: FontWeight.w900),
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
