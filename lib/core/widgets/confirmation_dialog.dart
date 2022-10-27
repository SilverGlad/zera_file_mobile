import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'network_image_cached.dart';

class ConfirmationDialogContent extends StatelessWidget {
  final String establishmentName;
  final String establishmentPic;

  ConfirmationDialogContent({Key key, this.establishmentName, this.establishmentPic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Prosseguir com o  pagamento?".toUpperCase(),
          style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorPrimary.withAlpha(40),
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 52,
                height: 52,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: NetworkImageCached(imageUrl: establishmentPic),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Text(
                  establishmentName,
                  style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          "Confira os itens e o estabelecimento antes de prosseguir.",
          style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
