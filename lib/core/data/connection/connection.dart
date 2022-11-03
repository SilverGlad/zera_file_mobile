import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:zera_fila/core/data/model/check_cupom_response.dart';
import 'package:zera_fila/core/data/request/check_cupom_request.dart';
import '../model/base_response.dart';
import '../model/carrinho.dart';
import '../model/comanda_response.dart';
import '../model/credit_card_brand_response.dart';
import '../model/establishment_list.dart';
import '../model/get_user_data_response.dart';
import '../model/menu_response.dart';
import '../model/orderResponse.dart';
import '../model/schedule_response.dart';
import '../model/user_data.dart';
import '../request/check_comanda_request.dart';
import '../request/confirm_comanda_request.dart';
import '../request/creditcard_request.dart';
import '../request/establishment_request.dart';
import '../request/get_user_data.dart';
import '../request/menu_request.dart';
import '../request/password_request.dart';
import '../request/rating_request.dart';
import '../request/remove_product.dart';
import '../request/request_sms_update_request.dart';
import '../request/save_product.dart';
import '../request/schedule_request.dart';
import '../request/base_request.dart';

class ConnectionUtils {
  static const BASE_URL = "http://zerafila.dyndns.org:7000/datasnap/rest/TSM1";
  static const PROD_URL = "https://esitef-ec.softwareexpress.com.br/e-sitef/api";
  static const BASE_AUTH_LOGIN = "TOKEN_AUTENTICACAO_API";
  static const BASE_AUTH_PASSWORD = "123";

  static Map<String, String> _provideBasicHeader = {
    "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    'authorization': 'Basic ' +
        base64Encode(
          utf8.encode('$BASE_AUTH_LOGIN:$BASE_AUTH_PASSWORD'),
        ),
  };

  //pathBD = nlgdjogz~;A9+_cuiOcmc,FA)]NVFK3-BAD
  // localhost:c:/ZeraFila/BD/ZF_LJ1.FDB
  //id = 1

  static Future<EstablishmentListResponse> provideEstablishemntsList(
    EstablishmentRequest data,
    {bool unique, String idUnique}
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/restaurantes'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log('Result: ' + json.decode(response.body).toString());
    var result = EstablishmentListResponse.fromJson(json.decode(response.body), unique: unique, idUnique: idUnique);
    return result;
  }

  static Future<MenuResponse> provideEstablishmentMenu(
    MenuRequest data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/cardapio'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = MenuResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<BaseResponse> registerNewUser(
    UserData data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/cadastrausuario'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = BaseResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<BaseResponse> updateUser(
    UserData data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/alterausuario'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = BaseResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<BaseResponse> loginUser(
    UserData data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/login'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = BaseResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<UserDataResponse> getUserData(
    UserDataRequest data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/ConsultaUsuario'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = UserDataResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<BaseResponse> sendPassword(
    PasswordRequest data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/ReenviaSenha'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = BaseResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<Carrinho> saveProductOnCarrinho(
    SaveProductRequest data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/IncluirProduto'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = Carrinho.fromJson(json.decode(response.body));
    return result;
  }

  static Future<Carrinho> saveProductOnCarrinhoComanda(
    SaveProductRequest data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/IncluirProdutoNaComanda'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = Carrinho.fromJson(json.decode(response.body));
    return result;
  }

  static Future<ScheduleResponse> getScheduleOptions(
    ScheduleRequest data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/ConsultarAgendamentoLoja'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = ScheduleResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<BaseResponse> removeProductOnCarrinho(
    RemoveProductRequest data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/ApagarProduto'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = BaseResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<BaseResponse> removeProductOnComanda(
    RemoveProductRequest data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/CancelarIemNaComanda'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = BaseResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<CreditCardBrandResponse> checkCreditCardBrand(
    CreditCardRequest data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/ConsultaCartaoAutorizadora'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = CreditCardBrandResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<BaseResponse> confirmComandaCart(
    ConfirmComandaRequest data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/ConfirmaComanda'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = BaseResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<CheckCupomResponse> checkCupom(
    CheckCupomRequest data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/aplicardesconto'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = CheckCupomResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<CreditCardBrandResponse> pay(
    CreditCardRequest data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/EfetuaTransacao'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = CreditCardBrandResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<CreditCardBrandResponse> payWithPicPay(
    CreditCardRequest data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/EfetuaTransacaoPicPay'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = CreditCardBrandResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<CreditCardBrandResponse> payWithPix(
    CreditCardRequest data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/EfetuaTransacaoPix'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = CreditCardBrandResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<CreditCardBrandResponse> checkPicPayPayment(
    String referenceId,
  ) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/ConsultaStatusPicPay/$referenceId'),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = CreditCardBrandResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<CreditCardBrandResponse> checkPixPayment(
    String referenceId,
  ) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/ConsultaStatusPix/$referenceId'),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = CreditCardBrandResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<CreditCardBrandResponse> cancelPicPayPayment(
    String referenceId,
  ) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/CancelarTransacaoPicPay/$referenceId'),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = CreditCardBrandResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<CreditCardBrandResponse> cancelPixPayment(
    String referenceId,
  ) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/CancelarRequisicaoPix/$referenceId'),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = CreditCardBrandResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<OrderResponse> provideHappeningOrdersList(
    BaseRequest data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/ConsultarPedidopendente'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = OrderResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<OrderResponse> rateApp(
    RatingRequest data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/avaliarZF'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = OrderResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<OrderResponse> providePastOrdersList(
    BaseRequest data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/ConsultarPedidoFinalizado'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = OrderResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<ComandaResponse> checkComanda(
    CheckComandaRequest data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/LerComanda'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = ComandaResponse.fromJson(json.decode(response.body));
    return result;
  }

  static Future<BaseResponse> sendSmsUpdateAccount(
    RequestSmsUpdateAccountRequest data,
  ) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/EnviaSMSAlteracaoCadastral'),
      body: data.toJson(),
      headers: _provideBasicHeader,
    );
    log(json.decode(response.body).toString());
    var result = BaseResponse.fromJson(json.decode(response.body));
    return result;
  }
}
