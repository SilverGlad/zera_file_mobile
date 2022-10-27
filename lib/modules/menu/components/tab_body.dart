import 'package:flutter/material.dart';
import '../../../core/data/model/menu_response.dart';
import '../../../core/data/model/products.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/constants.dart';
import '../../../core/widgets/network_image_cached.dart';
import 'product_detail.dart';

class TabBody extends StatefulWidget {
  final Cardapio menu;
  final String bdPath;
  final String establishmentId;
  final String comanda;
  final String mesa;
  final bool onlineOrder;
  final Function onProductAdded;
  final String typedSearch;
  const TabBody({Key key, this.menu, this.bdPath, this.onProductAdded, this.comanda, this.mesa, this.onlineOrder, this.establishmentId, this.typedSearch}) : super(key: key);

  @override
  _TabBodyState createState() => _TabBodyState();
}

class _TabBodyState extends State<TabBody> {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // _buildSearchContaier(context),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(top: 16, bottom: 140),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildItemList(context, widget.menu.produtos[index]);
            },
            itemCount: widget.menu.produtos.length,
            scrollDirection: Axis.vertical,
          ),
        ),
      ],
    );
  }


  Widget _buildItemList(BuildContext context, Products item) {
    if (item.nome.toLowerCase().contains(widget.typedSearch.toLowerCase())) {
      return Card(
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            _showItemDetail(context, item);
          },
          child: Container(
            padding: EdgeInsets.all(8),
            height: 96,
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: NetworkImageCached(imageUrl: item.urlImagem),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.nome,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: fontWeightMedium,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Text(
                            "R\$ ${item.preco}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: fontWeightMedium,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Text(
                            item.detalhes,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  void _showItemDetail(BuildContext context, Products item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (builder) {
        return ProductDetailBottomSheet(
          product: item,
          bdPath: widget.bdPath,
          establishmentId: widget.establishmentId,
          onlineOrder: widget.onlineOrder,
          comanda: widget.comanda,
          mesa: widget.mesa,
          onProductAdded: () {
            widget.onProductAdded.call();
          },
        );
      },
    );
  }
}
