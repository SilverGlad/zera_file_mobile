import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../core/data/connection/connection.dart';
import '../../../core/data/local/shared_preferences.dart';
import '../../../core/data/model/products.dart';
import '../../../core/data/request/save_product.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/constants.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../core/widgets/network_image_cached.dart';
import '../../../generated/l10n.dart';
import 'acompanhamentos_list_item.dart';

class ProductDetailBottomSheet extends StatefulWidget {
  final Products product;
  final String bdPath;
  final String establishmentId;
  final String comanda;
  final String mesa;
  final bool onlineOrder;
  final Function onProductAdded;

  const ProductDetailBottomSheet({Key key, this.product, this.bdPath, this.onProductAdded, this.comanda, this.mesa, this.onlineOrder, this.establishmentId})
      : super(key: key);

  @override
  _ProductDetailBottomSheetState createState() => _ProductDetailBottomSheetState();
}

class _ProductDetailBottomSheetState extends State<ProductDetailBottomSheet> {
  var _productQtd = 1;
  var _hasRequiredAcomp = false;
  var _requiredAcompsAdded = false;
  var _typedObservation = "";

  var _finalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    widget.product.acompanhamentos.forEach((element) {
      if (element.fLObrigar == "1") _hasRequiredAcomp = true;

      element.selected = false;
      element.selection = null;
      element.opEs?.forEach((element) {
        element.checked = false;
      });
    });

    setState(() {
      _requiredAcompsAdded = !_hasRequiredAcomp;
    });
  }

  @override
  Widget build(BuildContext context) {
    var floatPrice = double.parse(widget.product.preco.replaceAll(",", "."));
    _finalPrice = floatPrice * _productQtd;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.85,
      maxChildSize: bottomSheetMaxSize,
      builder: (context, scrollController) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.horizontal_rule_rounded,
                      color: Colors.black38,
                      size: 40,
                    ),
                    Divider(
                      color: Colors.black38,
                      height: 1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(top: 16, bottom: 80),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: Container(
                            width: double.infinity,
                            height: 250,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child: NetworkImageCached(imageUrl: widget.product.urlImagem),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8, left: 16, right: 16),
                          child: Text(
                            widget.product.nome,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: fontWeightMedium,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4, left: 16, right: 16),
                          child: Text(
                            widget.product.detalhes,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        widget.product.acompanhamentos.isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                                child: Text(
                                  S.of(context).menu_acompanhamentos,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            : Container(),
                        widget.product.acompanhamentos.isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.only(top: 6, left: 0, right: 0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => AcompanhamentoWidget(
                                    acompanhamentos: widget.product.acompanhamentos[index],
                                    onAcompanhamentoSelected: () {
                                      var allItensSelected = true;

                                      for (var element in widget.product.acompanhamentos) {
                                        if (element.fLObrigar == "1") {
                                          if (!element.selected) {
                                            allItensSelected = false;
                                            break;
                                          }
                                        }
                                      }

                                      setState(() {
                                        _requiredAcompsAdded = allItensSelected;
                                      });
                                    },
                                  ),
                                  itemCount: widget.product.acompanhamentos.length,
                                  physics: ClampingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                ),
                              )
                            : Container(),
                        Container(
                          margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                          child: TextFormField(
                            onChanged: (value) async {
                              setState(() {
                                _typedObservation = value;
                              });
                            },
                            style: TextStyle(fontSize: 14, color: Colors.black),
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(21),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              fillColor: colorEditText,
                              hintText: S.of(context).menu_observation,
                              hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
                decoration: BoxDecoration(
                  color: colorBackground,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      child: new RawMaterialButton(
                        shape: new CircleBorder(),
                        fillColor: colorPrimary,
                        elevation: 0.0,
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (_productQtd > 1) {
                            setState(() {
                              _productQtd--;
                            });
                          }
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        _productQtd.toString(),
                        style: TextStyle(fontSize: 16, fontWeight: fontWeightMedium),
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      child: new RawMaterialButton(
                        shape: new CircleBorder(),
                        fillColor: colorPrimary,
                        elevation: 0.0,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _productQtd++;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 24),
                        child: RaisedButton(
                          color: colorAccent,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.transparent),
                          ),
                          onPressed: _requiredAcompsAdded
                              ? () {
                                  if (widget.onlineOrder) {
                                    _addproductToCart();
                                  } else {
                                    _addProductToComanda();
                                  }
                                }
                              : null,
                          textColor: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                S.of(context).menu_add,
                                style: TextStyle(fontSize: 14, fontWeight: fontWeightMedium),
                              ),
                              Text(
                                "R\$ ${currencyFormatter.format(_finalPrice)}",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _addProductToComanda() async {
    var userId = await SharedPreferencesUtils.getLoggedUserId();
    var priceFormatted = currencyFormatter.format(_finalPrice).replaceAll(".", ",");

    var selectedAcomp = "";
    widget.product.acompanhamentos.forEach((acomp) {
      if (acomp.fLObrigar == "1") {
        selectedAcomp += acomp.opEs[acomp.selection].dS;
        selectedAcomp += "|";
      } else {
        acomp.opEs.forEach((options) {
          if (options.checked) {
            selectedAcomp += options.dS;
            selectedAcomp += "|";
          }
        });
      }
    });

    log("Acompanhamentos selecionados: $selectedAcomp");
    log("Id Produto: ${widget.product.id}");
    log("Id Usuario: $userId");
    log("Observacao: $_typedObservation");
    log("Numero pedido: ${widget.comanda}");
    log("Mesa: ${widget.mesa}");
    log("Quantidade: $_productQtd");
    log("Valor total: $priceFormatted");

    var itemToAdd = SaveProductRequest(
      aCOMPANHAMENTOS: selectedAcomp,
      iDPRODUTO: widget.product.id,
      iDUSU: userId,
      iDLoja: widget.establishmentId,
      oBS: _typedObservation,
      nrPedido: widget.comanda,
      qTDE: _productQtd.toString(),
      vLPRODUTO: priceFormatted,
      nrMesa: widget.mesa,
    );

    try {
      DialogsUtil.showLoaderDialog(context, title: S.of(context).menu_adding);

      var response = await ConnectionUtils.saveProductOnCarrinhoComanda(itemToAdd);

      if (response.erro.toLowerCase() == "false") {
        widget.onProductAdded.call();
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        DialogsUtil.showAlertDialog(
          context: context,
          message: response.mensagem,
          positiveButtonText: "OK",
          onPositiveClick: () {
            Navigator.pop(context);
          },
        );
      }
    } catch (_) {
      log("Error");
      var reason = "Erro ao adicionar o produto no carrinho.\nVerifique sua conexão e tente novamente.";
      Navigator.pop(context);
      DialogsUtil.showAlertDialog(
        context: context,
        message: reason,
        positiveButtonText: "OK",
        onPositiveClick: () {
          Navigator.pop(context);
        },
      );
    }
  }

  _addproductToCart() async {
    var userId = await SharedPreferencesUtils.getLoggedUserId();
    var hasOrder = await SharedPreferencesUtils.hasOrderCreatedAndValid();
    var priceFormatted = currencyFormatter.format(_finalPrice).replaceAll(".", ",");
    var orderNumber = "0";
    if (hasOrder) {
      orderNumber = await SharedPreferencesUtils.getOrderNumber();
    }

    var selectedAcomp = "";
    widget.product.acompanhamentos.forEach((acomp) {
      if (acomp.fLObrigar == "1") {
        selectedAcomp += acomp.opEs[acomp.selection].dS;
        selectedAcomp += "|";
      } else {
        acomp.opEs.forEach((options) {
          if (options.checked) {
            selectedAcomp += options.dS;
            selectedAcomp += "|";
          }
        });
      }
    });

    log("Acompanhamentos selecionados: $selectedAcomp");
    log("Id Produto: ${widget.product.id}");
    log("Id Usuario: $userId");
    log("Observacao: $_typedObservation");
    log("Numero pedido: $orderNumber");
    log("Path bd: ${widget.bdPath}");
    log("Quantidade: $_productQtd");
    log("Valor total: $priceFormatted");

    var itemToAdd = SaveProductRequest(
      aCOMPANHAMENTOS: selectedAcomp,
      iDPRODUTO: widget.product.id,
      iDUSU: userId,
      iDLoja: widget.establishmentId,
      oBS: _typedObservation,
      nrPedido: orderNumber,
      path: widget.bdPath,
      qTDE: _productQtd.toString(),
      vLPRODUTO: priceFormatted,
    );

    try {
      DialogsUtil.showLoaderDialog(context, title: S.of(context).menu_adding);

      var response = await ConnectionUtils.saveProductOnCarrinho(itemToAdd);

      if (response.erro.toLowerCase() == "false") {
        await SharedPreferencesUtils.saveOrderNumber(response.nrPedido, response.itens.length, widget.establishmentId);
        widget.onProductAdded.call();
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        DialogsUtil.showAlertDialog(
          context: context,
          message: response.mensagem,
          positiveButtonText: "OK",
          onPositiveClick: () {
            Navigator.pop(context);
          },
        );
      }
    } catch (_) {
      log("Error");
      var reason = "Erro ao adicionar o produto no carrinho.\nVerifique sua conexão e tente novamente.";
      Navigator.pop(context);
      DialogsUtil.showAlertDialog(
        context: context,
        message: reason,
        positiveButtonText: "OK",
        onPositiveClick: () {
          Navigator.pop(context);
        },
      );
    }
  }
}
