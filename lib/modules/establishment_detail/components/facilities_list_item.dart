import 'package:flutter/material.dart';
import '../../../core/data/model/establishment.dart';
import '../../../core/utils/colors.dart';

class FacilitiesListItem extends StatelessWidget {
  final IconData icon;
  final String message;

  const FacilitiesListItem({Key key, this.icon, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: double.infinity,
      child: Column(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(9))),
              elevation: 2,
              color: colorPrimary,
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
