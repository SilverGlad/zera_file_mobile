// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Cancelar`
  String get dialog_cancel {
    return Intl.message(
      'Cancelar',
      name: 'dialog_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Carregando...`
  String get dialog_loading {
    return Intl.message(
      'Carregando...',
      name: 'dialog_loading',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get dialog_ok {
    return Intl.message(
      'OK',
      name: 'dialog_ok',
      desc: '',
      args: [],
    );
  }

  /// `Bem vindo ao Zera-Fila!`
  String get home_appBarTitle {
    return Intl.message(
      'Bem vindo ao Zera-Fila!',
      name: 'home_appBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Meus Pedidos`
  String get home_appBarTitle_order {
    return Intl.message(
      'Meus Pedidos',
      name: 'home_appBarTitle_order',
      desc: '',
      args: [],
    );
  }

  /// `Meu Perfil`
  String get home_appBarTitle_profile {
    return Intl.message(
      'Meu Perfil',
      name: 'home_appBarTitle_profile',
      desc: '',
      args: [],
    );
  }

  /// `Clique aqui e faça login ou crie sua conta para ter uma experiência completa`
  String get home_firstVersionMessage {
    return Intl.message(
      'Clique aqui e faça login ou crie sua conta para ter uma experiência completa',
      name: 'home_firstVersionMessage',
      desc: '',
      args: [],
    );
  }

  /// `Permita o uso da localização para que possamos encontrar os estabelecimentos próximos a você!`
  String get home_locationMessage {
    return Intl.message(
      'Permita o uso da localização para que possamos encontrar os estabelecimentos próximos a você!',
      name: 'home_locationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Permitir`
  String get home_allow {
    return Intl.message(
      'Permitir',
      name: 'home_allow',
      desc: '',
      args: [],
    );
  }

  /// `Início`
  String get home_panel_start {
    return Intl.message(
      'Início',
      name: 'home_panel_start',
      desc: '',
      args: [],
    );
  }

  /// `Pedidos`
  String get home_panel_order {
    return Intl.message(
      'Pedidos',
      name: 'home_panel_order',
      desc: '',
      args: [],
    );
  }

  /// `Perfil`
  String get home_panel_profile {
    return Intl.message(
      'Perfil',
      name: 'home_panel_profile',
      desc: '',
      args: [],
    );
  }

  /// `Endereço`
  String get detail_address_title {
    return Intl.message(
      'Endereço',
      name: 'detail_address_title',
      desc: '',
      args: [],
    );
  }

  /// `Abrir no mapa`
  String get detail_openMap {
    return Intl.message(
      'Abrir no mapa',
      name: 'detail_openMap',
      desc: '',
      args: [],
    );
  }

  /// `{value} de distância`
  String detail_distanceLabel(Object value) {
    return Intl.message(
      '$value de distância',
      name: 'detail_distanceLabel',
      desc: '',
      args: [value],
    );
  }

  /// `Contato`
  String get detail_contact_title {
    return Intl.message(
      'Contato',
      name: 'detail_contact_title',
      desc: '',
      args: [],
    );
  }

  /// `Toque em um dos telefones para ligar para o estabelecimento`
  String get detail_contact_message {
    return Intl.message(
      'Toque em um dos telefones para ligar para o estabelecimento',
      name: 'detail_contact_message',
      desc: '',
      args: [],
    );
  }

  /// `Características da casa`
  String get detail_facilities_title {
    return Intl.message(
      'Características da casa',
      name: 'detail_facilities_title',
      desc: '',
      args: [],
    );
  }

  /// `Espaço kids`
  String get detail_facilities_kids {
    return Intl.message(
      'Espaço kids',
      name: 'detail_facilities_kids',
      desc: '',
      args: [],
    );
  }

  /// `Acessibilidade`
  String get detail_facilities_accesibility {
    return Intl.message(
      'Acessibilidade',
      name: 'detail_facilities_accesibility',
      desc: '',
      args: [],
    );
  }

  /// `Estacionamento`
  String get detail_facilities_parking {
    return Intl.message(
      'Estacionamento',
      name: 'detail_facilities_parking',
      desc: '',
      args: [],
    );
  }

  /// `Wi-Fi`
  String get detail_facilities_wifi {
    return Intl.message(
      'Wi-Fi',
      name: 'detail_facilities_wifi',
      desc: '',
      args: [],
    );
  }

  /// `Horário de funcionamento`
  String get detail_time_title {
    return Intl.message(
      'Horário de funcionamento',
      name: 'detail_time_title',
      desc: '',
      args: [],
    );
  }

  /// `FECHADO`
  String get detail_closed {
    return Intl.message(
      'FECHADO',
      name: 'detail_closed',
      desc: '',
      args: [],
    );
  }

  /// `Domingo`
  String get weekday_sunday {
    return Intl.message(
      'Domingo',
      name: 'weekday_sunday',
      desc: '',
      args: [],
    );
  }

  /// `Segunda-feira`
  String get weekday_monday {
    return Intl.message(
      'Segunda-feira',
      name: 'weekday_monday',
      desc: '',
      args: [],
    );
  }

  /// `Terça-feira`
  String get weekday_tuesday {
    return Intl.message(
      'Terça-feira',
      name: 'weekday_tuesday',
      desc: '',
      args: [],
    );
  }

  /// `Quarta-feira`
  String get weekday_wednesday {
    return Intl.message(
      'Quarta-feira',
      name: 'weekday_wednesday',
      desc: '',
      args: [],
    );
  }

  /// `Quinta-feira`
  String get weekday_thursday {
    return Intl.message(
      'Quinta-feira',
      name: 'weekday_thursday',
      desc: '',
      args: [],
    );
  }

  /// `Sexta`
  String get weekday_friday {
    return Intl.message(
      'Sexta',
      name: 'weekday_friday',
      desc: '',
      args: [],
    );
  }

  /// `Sábado`
  String get weekday_saturday {
    return Intl.message(
      'Sábado',
      name: 'weekday_saturday',
      desc: '',
      args: [],
    );
  }

  /// `Fechado`
  String get detail_time_closed {
    return Intl.message(
      'Fechado',
      name: 'detail_time_closed',
      desc: '',
      args: [],
    );
  }

  /// `Redes sociais`
  String get detail_social_title {
    return Intl.message(
      'Redes sociais',
      name: 'detail_social_title',
      desc: '',
      args: [],
    );
  }

  /// `Facebook`
  String get detail_social_facebook {
    return Intl.message(
      'Facebook',
      name: 'detail_social_facebook',
      desc: '',
      args: [],
    );
  }

  /// `Instagram`
  String get detail_social_instagram {
    return Intl.message(
      'Instagram',
      name: 'detail_social_instagram',
      desc: '',
      args: [],
    );
  }

  /// `Twitter`
  String get detail_social_twitter {
    return Intl.message(
      'Twitter',
      name: 'detail_social_twitter',
      desc: '',
      args: [],
    );
  }

  /// `Site`
  String get detail_social_site {
    return Intl.message(
      'Site',
      name: 'detail_social_site',
      desc: '',
      args: [],
    );
  }

  /// `WhatsApp`
  String get detail_social_whatsapp {
    return Intl.message(
      'WhatsApp',
      name: 'detail_social_whatsapp',
      desc: '',
      args: [],
    );
  }

  /// `FAZER PEDIDO`
  String get detail_see_menu {
    return Intl.message(
      'FAZER PEDIDO',
      name: 'detail_see_menu',
      desc: '',
      args: [],
    );
  }

  /// `LER COMANDA`
  String get detail_scan {
    return Intl.message(
      'LER COMANDA',
      name: 'detail_scan',
      desc: '',
      args: [],
    );
  }

  /// `Ler comanda`
  String get detail_scanBS_title {
    return Intl.message(
      'Ler comanda',
      name: 'detail_scanBS_title',
      desc: '',
      args: [],
    );
  }

  /// `Leia com a camera ou digite manualmente o código de sua comanda para pagá-la via aplicativo`
  String get detail_scanBS_message {
    return Intl.message(
      'Leia com a camera ou digite manualmente o código de sua comanda para pagá-la via aplicativo',
      name: 'detail_scanBS_message',
      desc: '',
      args: [],
    );
  }

  /// `Ler com a câmera`
  String get detail_scanBS_readCamera {
    return Intl.message(
      'Ler com a câmera',
      name: 'detail_scanBS_readCamera',
      desc: '',
      args: [],
    );
  }

  /// `Digitar o código da comanda`
  String get detail_scanBS_typeManually {
    return Intl.message(
      'Digitar o código da comanda',
      name: 'detail_scanBS_typeManually',
      desc: '',
      args: [],
    );
  }

  /// `Validar`
  String get detail_scanBS_open {
    return Intl.message(
      'Validar',
      name: 'detail_scanBS_open',
      desc: '',
      args: [],
    );
  }

  /// `Validando comanda...`
  String get detail_scanBS_loading {
    return Intl.message(
      'Validando comanda...',
      name: 'detail_scanBS_loading',
      desc: '',
      args: [],
    );
  }

  /// `Esta comanda não existe ou não está aberta no momento`
  String get detail_scanBS_notFound {
    return Intl.message(
      'Esta comanda não existe ou não está aberta no momento',
      name: 'detail_scanBS_notFound',
      desc: '',
      args: [],
    );
  }

  /// `Cancelar`
  String get detail_scanBS_cancel {
    return Intl.message(
      'Cancelar',
      name: 'detail_scanBS_cancel',
      desc: '',
      args: [],
    );
  }

  /// `ESTABELECIMENTO FECHADO`
  String get detail_establishment_close {
    return Intl.message(
      'ESTABELECIMENTO FECHADO',
      name: 'detail_establishment_close',
      desc: '',
      args: [],
    );
  }

  /// `Erro ao receber lista de itens deste estabelecimento`
  String get detail_error_loading_menu {
    return Intl.message(
      'Erro ao receber lista de itens deste estabelecimento',
      name: 'detail_error_loading_menu',
      desc: '',
      args: [],
    );
  }

  /// `Você tem um carrinho aberto em outro restaurante, deseja excluir o carrinho atual e iniciar um novo?`
  String get detail_orderInAnotherLj_message {
    return Intl.message(
      'Você tem um carrinho aberto em outro restaurante, deseja excluir o carrinho atual e iniciar um novo?',
      name: 'detail_orderInAnotherLj_message',
      desc: '',
      args: [],
    );
  }

  /// `Excluir`
  String get detail_orderInAnotherLj_button {
    return Intl.message(
      'Excluir',
      name: 'detail_orderInAnotherLj_button',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menu_toolbar {
    return Intl.message(
      'Menu',
      name: 'menu_toolbar',
      desc: '',
      args: [],
    );
  }

  /// `Acompanhamentos`
  String get menu_acompanhamentos {
    return Intl.message(
      'Acompanhamentos',
      name: 'menu_acompanhamentos',
      desc: '',
      args: [],
    );
  }

  /// `Adicionar`
  String get menu_add {
    return Intl.message(
      'Adicionar',
      name: 'menu_add',
      desc: '',
      args: [],
    );
  }

  /// `(Obrigatório)`
  String get menu_required {
    return Intl.message(
      '(Obrigatório)',
      name: 'menu_required',
      desc: '',
      args: [],
    );
  }

  /// `Alguma observação?`
  String get menu_observation {
    return Intl.message(
      'Alguma observação?',
      name: 'menu_observation',
      desc: '',
      args: [],
    );
  }

  /// `Produto adicionado com sucesso ao carrinho!`
  String get menu_productAdded {
    return Intl.message(
      'Produto adicionado com sucesso ao carrinho!',
      name: 'menu_productAdded',
      desc: '',
      args: [],
    );
  }

  /// `Atualizando carrinho...`
  String get menu_loader {
    return Intl.message(
      'Atualizando carrinho...',
      name: 'menu_loader',
      desc: '',
      args: [],
    );
  }

  /// `Adicionando produto...`
  String get menu_adding {
    return Intl.message(
      'Adicionando produto...',
      name: 'menu_adding',
      desc: '',
      args: [],
    );
  }

  /// `Carrinho`
  String get carrinho_title {
    return Intl.message(
      'Carrinho',
      name: 'carrinho_title',
      desc: '',
      args: [],
    );
  }

  /// `Comanda {value}`
  String carrinho_comanda_title(Object value) {
    return Intl.message(
      'Comanda $value',
      name: 'carrinho_comanda_title',
      desc: '',
      args: [value],
    );
  }

  /// `Adicionar mais itens`
  String get carrinho_addMore {
    return Intl.message(
      'Adicionar mais itens',
      name: 'carrinho_addMore',
      desc: '',
      args: [],
    );
  }

  /// `Fechar pedido`
  String get carrinho_proceed {
    return Intl.message(
      'Fechar pedido',
      name: 'carrinho_proceed',
      desc: '',
      args: [],
    );
  }

  /// `Remover`
  String get carrinho_deleteItem {
    return Intl.message(
      'Remover',
      name: 'carrinho_deleteItem',
      desc: '',
      args: [],
    );
  }

  /// `Remover item?`
  String get carrinho_deleteItem_dialogTitle {
    return Intl.message(
      'Remover item?',
      name: 'carrinho_deleteItem_dialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Remover`
  String get carrinho_deleteItem_dialogButton {
    return Intl.message(
      'Remover',
      name: 'carrinho_deleteItem_dialogButton',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get carrinho_total {
    return Intl.message(
      'Total',
      name: 'carrinho_total',
      desc: '',
      args: [],
    );
  }

  /// `itens`
  String get carrinho_itens {
    return Intl.message(
      'itens',
      name: 'carrinho_itens',
      desc: '',
      args: [],
    );
  }

  /// `item`
  String get carrinho_item {
    return Intl.message(
      'item',
      name: 'carrinho_item',
      desc: '',
      args: [],
    );
  }

  /// `Limpar`
  String get carrinho_clear {
    return Intl.message(
      'Limpar',
      name: 'carrinho_clear',
      desc: '',
      args: [],
    );
  }

  /// `Limpar carrinho?`
  String get carrinho_clearDialog {
    return Intl.message(
      'Limpar carrinho?',
      name: 'carrinho_clearDialog',
      desc: '',
      args: [],
    );
  }

  /// `Removendo item...`
  String get carrinho_removing {
    return Intl.message(
      'Removendo item...',
      name: 'carrinho_removing',
      desc: '',
      args: [],
    );
  }

  /// `Conecte-se com seu endereço de email ou crie uma conta.`
  String get login_title {
    return Intl.message(
      'Conecte-se com seu endereço de email ou crie uma conta.',
      name: 'login_title',
      desc: '',
      args: [],
    );
  }

  /// `E-mail`
  String get login_email {
    return Intl.message(
      'E-mail',
      name: 'login_email',
      desc: '',
      args: [],
    );
  }

  /// `Senha`
  String get login_password {
    return Intl.message(
      'Senha',
      name: 'login_password',
      desc: '',
      args: [],
    );
  }

  /// `Digite o pin enviado`
  String get login_pin {
    return Intl.message(
      'Digite o pin enviado',
      name: 'login_pin',
      desc: '',
      args: [],
    );
  }

  /// `Digite o código que enviamos via sms para seu número cadastrado`
  String get login_validationCode_title {
    return Intl.message(
      'Digite o código que enviamos via sms para seu número cadastrado',
      name: 'login_validationCode_title',
      desc: '',
      args: [],
    );
  }

  /// `Código de validação`
  String get login_validationCode {
    return Intl.message(
      'Código de validação',
      name: 'login_validationCode',
      desc: '',
      args: [],
    );
  }

  /// `Esqueci minha senha`
  String get login_forgotPassword {
    return Intl.message(
      'Esqueci minha senha',
      name: 'login_forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Cadastrar-se`
  String get login_createAccount {
    return Intl.message(
      'Cadastrar-se',
      name: 'login_createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Conectar`
  String get login_connect {
    return Intl.message(
      'Conectar',
      name: 'login_connect',
      desc: '',
      args: [],
    );
  }

  /// `Cadastro`
  String get register_toolbar {
    return Intl.message(
      'Cadastro',
      name: 'register_toolbar',
      desc: '',
      args: [],
    );
  }

  /// `Dados Pessoais`
  String get register_personalData {
    return Intl.message(
      'Dados Pessoais',
      name: 'register_personalData',
      desc: '',
      args: [],
    );
  }

  /// `Nome completo`
  String get register_fullName {
    return Intl.message(
      'Nome completo',
      name: 'register_fullName',
      desc: '',
      args: [],
    );
  }

  /// `CPF`
  String get register_document {
    return Intl.message(
      'CPF',
      name: 'register_document',
      desc: '',
      args: [],
    );
  }

  /// `Dados para contato`
  String get register_contactData {
    return Intl.message(
      'Dados para contato',
      name: 'register_contactData',
      desc: '',
      args: [],
    );
  }

  /// `Celular (Ex. 99 99999-9999)`
  String get register_phone {
    return Intl.message(
      'Celular (Ex. 99 99999-9999)',
      name: 'register_phone',
      desc: '',
      args: [],
    );
  }

  /// `Digite um número válido, enviaremos um SMS para confirmar sua conta`
  String get register_phoneInfo {
    return Intl.message(
      'Digite um número válido, enviaremos um SMS para confirmar sua conta',
      name: 'register_phoneInfo',
      desc: '',
      args: [],
    );
  }

  /// `Endereço de e-mail`
  String get register_mail {
    return Intl.message(
      'Endereço de e-mail',
      name: 'register_mail',
      desc: '',
      args: [],
    );
  }

  /// `Formato de e-mail inválido`
  String get register_invalidMail {
    return Intl.message(
      'Formato de e-mail inválido',
      name: 'register_invalidMail',
      desc: '',
      args: [],
    );
  }

  /// `e-mails não são iguais`
  String get register_mailNotEquals {
    return Intl.message(
      'e-mails não são iguais',
      name: 'register_mailNotEquals',
      desc: '',
      args: [],
    );
  }

  /// `Confirmar endereço de e-mail`
  String get register_confirmMail {
    return Intl.message(
      'Confirmar endereço de e-mail',
      name: 'register_confirmMail',
      desc: '',
      args: [],
    );
  }

  /// `Dados para acesso`
  String get register_loginData {
    return Intl.message(
      'Dados para acesso',
      name: 'register_loginData',
      desc: '',
      args: [],
    );
  }

  /// `Senha`
  String get register_password {
    return Intl.message(
      'Senha',
      name: 'register_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirmar senha`
  String get register_confirmPassword {
    return Intl.message(
      'Confirmar senha',
      name: 'register_confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Senhas não são iguais`
  String get register_passwordsNotEquals {
    return Intl.message(
      'Senhas não são iguais',
      name: 'register_passwordsNotEquals',
      desc: '',
      args: [],
    );
  }

  /// `Criar conta`
  String get register_button {
    return Intl.message(
      'Criar conta',
      name: 'register_button',
      desc: '',
      args: [],
    );
  }

  /// `Para fazer login, digite o código enviado para seu telefone e e-mail`
  String get register_confirm_phone {
    return Intl.message(
      'Para fazer login, digite o código enviado para seu telefone e e-mail',
      name: 'register_confirm_phone',
      desc: '',
      args: [],
    );
  }

  /// `Não recebi`
  String get register_didntReceive {
    return Intl.message(
      'Não recebi',
      name: 'register_didntReceive',
      desc: '',
      args: [],
    );
  }

  /// `Enviar novamente`
  String get register_sendAgain {
    return Intl.message(
      'Enviar novamente',
      name: 'register_sendAgain',
      desc: '',
      args: [],
    );
  }

  /// `Validar`
  String get register_validate {
    return Intl.message(
      'Validar',
      name: 'register_validate',
      desc: '',
      args: [],
    );
  }

  /// `SMS digitado inválido`
  String get register_invalidSMS {
    return Intl.message(
      'SMS digitado inválido',
      name: 'register_invalidSMS',
      desc: '',
      args: [],
    );
  }

  /// `Conta criada com sucesso`
  String get register_accountCreated {
    return Intl.message(
      'Conta criada com sucesso',
      name: 'register_accountCreated',
      desc: '',
      args: [],
    );
  }

  /// `Alterar dados cadastrais`
  String get profile_changeData {
    return Intl.message(
      'Alterar dados cadastrais',
      name: 'profile_changeData',
      desc: '',
      args: [],
    );
  }

  /// `Indicar um restaurante`
  String get profile_indicate {
    return Intl.message(
      'Indicar um restaurante',
      name: 'profile_indicate',
      desc: '',
      args: [],
    );
  }

  /// `Termos de uso e privacidade`
  String get profile_terms {
    return Intl.message(
      'Termos de uso e privacidade',
      name: 'profile_terms',
      desc: '',
      args: [],
    );
  }

  /// `FAQ`
  String get profile_faq {
    return Intl.message(
      'FAQ',
      name: 'profile_faq',
      desc: '',
      args: [],
    );
  }

  /// `Fale conosco`
  String get profile_talkToUs {
    return Intl.message(
      'Fale conosco',
      name: 'profile_talkToUs',
      desc: '',
      args: [],
    );
  }

  /// `Nos envie sugestões, dúvidas, elogios ou reclamações e entraremos em contato com você.`
  String get profile_talkToUs_hint {
    return Intl.message(
      'Nos envie sugestões, dúvidas, elogios ou reclamações e entraremos em contato com você.',
      name: 'profile_talkToUs_hint',
      desc: '',
      args: [],
    );
  }

  /// `Enviar`
  String get profile_talkToUs_button {
    return Intl.message(
      'Enviar',
      name: 'profile_talkToUs_button',
      desc: '',
      args: [],
    );
  }

  /// `Sair`
  String get profile_logout {
    return Intl.message(
      'Sair',
      name: 'profile_logout',
      desc: '',
      args: [],
    );
  }

  /// `Sair do Zera-fila`
  String get profile_logoutDialog_title {
    return Intl.message(
      'Sair do Zera-fila',
      name: 'profile_logoutDialog_title',
      desc: '',
      args: [],
    );
  }

  /// `Deseja desconectar-se da sua conta no zera-fila?`
  String get profile_logoutDialog_message {
    return Intl.message(
      'Deseja desconectar-se da sua conta no zera-fila?',
      name: 'profile_logoutDialog_message',
      desc: '',
      args: [],
    );
  }

  /// `Sair`
  String get profile_logoutDialog_button {
    return Intl.message(
      'Sair',
      name: 'profile_logoutDialog_button',
      desc: '',
      args: [],
    );
  }

  /// `Tempo médio de preparação:`
  String get checkout_cookTime {
    return Intl.message(
      'Tempo médio de preparação:',
      name: 'checkout_cookTime',
      desc: '',
      args: [],
    );
  }

  /// `Pedido:`
  String get checkout_order {
    return Intl.message(
      'Pedido:',
      name: 'checkout_order',
      desc: '',
      args: [],
    );
  }

  /// `Total dos itens:`
  String get checkout_orderComanda {
    return Intl.message(
      'Total dos itens:',
      name: 'checkout_orderComanda',
      desc: '',
      args: [],
    );
  }

  /// `Descontos:`
  String get checkout_discount {
    return Intl.message(
      'Descontos:',
      name: 'checkout_discount',
      desc: '',
      args: [],
    );
  }

  /// `Taxa de serviço:`
  String get checkout_serviceTax {
    return Intl.message(
      'Taxa de serviço:',
      name: 'checkout_serviceTax',
      desc: '',
      args: [],
    );
  }

  /// `Total:`
  String get checkout_total {
    return Intl.message(
      'Total:',
      name: 'checkout_total',
      desc: '',
      args: [],
    );
  }

  /// `Total da comanda:`
  String get checkout_totalComanda {
    return Intl.message(
      'Total da comanda:',
      name: 'checkout_totalComanda',
      desc: '',
      args: [],
    );
  }

  /// `Digite seu cupom de desconto`
  String get checkout_coupon {
    return Intl.message(
      'Digite seu cupom de desconto',
      name: 'checkout_coupon',
      desc: '',
      args: [],
    );
  }

  /// `Observações sobre o pedido ou retirada`
  String get checkout_obs {
    return Intl.message(
      'Observações sobre o pedido ou retirada',
      name: 'checkout_obs',
      desc: '',
      args: [],
    );
  }

  /// `Cupom de desconto inválido`
  String get checkout_coupon_invalid {
    return Intl.message(
      'Cupom de desconto inválido',
      name: 'checkout_coupon_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Validar`
  String get checkout_validateCoupon {
    return Intl.message(
      'Validar',
      name: 'checkout_validateCoupon',
      desc: '',
      args: [],
    );
  }

  /// `Retirar`
  String get checkout_withdrawTitle {
    return Intl.message(
      'Retirar',
      name: 'checkout_withdrawTitle',
      desc: '',
      args: [],
    );
  }

  /// `Agora`
  String get checkout_withdrawNow {
    return Intl.message(
      'Agora',
      name: 'checkout_withdrawNow',
      desc: '',
      args: [],
    );
  }

  /// `Agendar`
  String get checkout_withdrawSchedule {
    return Intl.message(
      'Agendar',
      name: 'checkout_withdrawSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Às {value}`
  String checkout_withdrawScheduleItem(Object value) {
    return Intl.message(
      'Às $value',
      name: 'checkout_withdrawScheduleItem',
      desc: '',
      args: [value],
    );
  }

  /// `Selecione o horário de retirada`
  String get checkout_withdrawScheduleTitle {
    return Intl.message(
      'Selecione o horário de retirada',
      name: 'checkout_withdrawScheduleTitle',
      desc: '',
      args: [],
    );
  }

  /// `Agendamento indisponível`
  String get checkout_withdrawScheduleNotAllowed {
    return Intl.message(
      'Agendamento indisponível',
      name: 'checkout_withdrawScheduleNotAllowed',
      desc: '',
      args: [],
    );
  }

  /// `Forma de pagamento`
  String get checkout_paymentTitle {
    return Intl.message(
      'Forma de pagamento',
      name: 'checkout_paymentTitle',
      desc: '',
      args: [],
    );
  }

  /// `Escolher`
  String get checkout_paymentMethodChange {
    return Intl.message(
      'Escolher',
      name: 'checkout_paymentMethodChange',
      desc: '',
      args: [],
    );
  }

  /// `Cartões cadastrados`
  String get checkout_choosePaymentForm {
    return Intl.message(
      'Cartões cadastrados',
      name: 'checkout_choosePaymentForm',
      desc: '',
      args: [],
    );
  }

  /// `Adicionar novo cartão`
  String get checkout_createNewCreditCard {
    return Intl.message(
      'Adicionar novo cartão',
      name: 'checkout_createNewCreditCard',
      desc: '',
      args: [],
    );
  }

  /// `Apagar cartão`
  String get checkout_deleteCardDialog_title {
    return Intl.message(
      'Apagar cartão',
      name: 'checkout_deleteCardDialog_title',
      desc: '',
      args: [],
    );
  }

  /// `Deseja apagar este cartão da sua lista?`
  String get checkout_deleteCardDialog_message {
    return Intl.message(
      'Deseja apagar este cartão da sua lista?',
      name: 'checkout_deleteCardDialog_message',
      desc: '',
      args: [],
    );
  }

  /// `Apagar`
  String get checkout_deleteCardDialog_button {
    return Intl.message(
      'Apagar',
      name: 'checkout_deleteCardDialog_button',
      desc: '',
      args: [],
    );
  }

  /// `Continuar`
  String get checkout_choosePaymentForm_selectButton {
    return Intl.message(
      'Continuar',
      name: 'checkout_choosePaymentForm_selectButton',
      desc: '',
      args: [],
    );
  }

  /// `Nenhum cartão salvo`
  String get checkout_choosePaymentForm_empty {
    return Intl.message(
      'Nenhum cartão salvo',
      name: 'checkout_choosePaymentForm_empty',
      desc: '',
      args: [],
    );
  }

  /// `{value} final {value2}`
  String checkout_choosePaymentForm_text(Object value, Object value2) {
    return Intl.message(
      '$value final $value2',
      name: 'checkout_choosePaymentForm_text',
      desc: '',
      args: [value, value2],
    );
  }

  /// `Cadastrar novo cartão`
  String get checkout_createNewPayment_selectType {
    return Intl.message(
      'Cadastrar novo cartão',
      name: 'checkout_createNewPayment_selectType',
      desc: '',
      args: [],
    );
  }

  /// `Crédito`
  String get checkout_createNewPayment_credit {
    return Intl.message(
      'Crédito',
      name: 'checkout_createNewPayment_credit',
      desc: '',
      args: [],
    );
  }

  /// `Sodexo Alimentação`
  String get checkout_createNewPayment_sodexoAli {
    return Intl.message(
      'Sodexo Alimentação',
      name: 'checkout_createNewPayment_sodexoAli',
      desc: '',
      args: [],
    );
  }

  /// `Sodexo Refeição`
  String get checkout_createNewPayment_sodexoRef {
    return Intl.message(
      'Sodexo Refeição',
      name: 'checkout_createNewPayment_sodexoRef',
      desc: '',
      args: [],
    );
  }

  /// `Alelo Alimentação`
  String get checkout_createNewPayment_aleloAli {
    return Intl.message(
      'Alelo Alimentação',
      name: 'checkout_createNewPayment_aleloAli',
      desc: '',
      args: [],
    );
  }

  /// `Alelo Refeição`
  String get checkout_createNewPayment_aleloRef {
    return Intl.message(
      'Alelo Refeição',
      name: 'checkout_createNewPayment_aleloRef',
      desc: '',
      args: [],
    );
  }

  /// `VR Alimentação`
  String get checkout_createNewPayment_vrAli {
    return Intl.message(
      'VR Alimentação',
      name: 'checkout_createNewPayment_vrAli',
      desc: '',
      args: [],
    );
  }

  /// `VR Refeição`
  String get checkout_createNewPayment_vrRef {
    return Intl.message(
      'VR Refeição',
      name: 'checkout_createNewPayment_vrRef',
      desc: '',
      args: [],
    );
  }

  /// `Realizar pagamento`
  String get checkout_pay {
    return Intl.message(
      'Realizar pagamento',
      name: 'checkout_pay',
      desc: '',
      args: [],
    );
  }

  /// `Finalizar pedido`
  String get checkout_confirmDialog_title {
    return Intl.message(
      'Finalizar pedido',
      name: 'checkout_confirmDialog_title',
      desc: '',
      args: [],
    );
  }

  /// `Deseja finalizar o pedido e realizar o pagamento? Após esta ação o pedido será encaminhado para cozinha e não poderá ser alterado.`
  String get checkout_confirmDialog_message {
    return Intl.message(
      'Deseja finalizar o pedido e realizar o pagamento? Após esta ação o pedido será encaminhado para cozinha e não poderá ser alterado.',
      name: 'checkout_confirmDialog_message',
      desc: '',
      args: [],
    );
  }

  /// `Pagar`
  String get checkout_confirmDialog_pay {
    return Intl.message(
      'Pagar',
      name: 'checkout_confirmDialog_pay',
      desc: '',
      args: [],
    );
  }

  /// `Voltar`
  String get checkout_confirmDialog_back {
    return Intl.message(
      'Voltar',
      name: 'checkout_confirmDialog_back',
      desc: '',
      args: [],
    );
  }

  /// `Finalizando pedido`
  String get checkout_paying_loader {
    return Intl.message(
      'Finalizando pedido',
      name: 'checkout_paying_loader',
      desc: '',
      args: [],
    );
  }

  /// `Número do cartão`
  String get checkout_newCard_number {
    return Intl.message(
      'Número do cartão',
      name: 'checkout_newCard_number',
      desc: '',
      args: [],
    );
  }

  /// `Data de vencimento (mm/aa)`
  String get checkout_newCard_validDue {
    return Intl.message(
      'Data de vencimento (mm/aa)',
      name: 'checkout_newCard_validDue',
      desc: '',
      args: [],
    );
  }

  /// `CVV`
  String get checkout_newCard_code {
    return Intl.message(
      'CVV',
      name: 'checkout_newCard_code',
      desc: '',
      args: [],
    );
  }

  /// `CPF do titular`
  String get checkout_newCard_document {
    return Intl.message(
      'CPF do titular',
      name: 'checkout_newCard_document',
      desc: '',
      args: [],
    );
  }

  /// `Nome do titular (Igual ao cartão)`
  String get checkout_newCard_holderName {
    return Intl.message(
      'Nome do titular (Igual ao cartão)',
      name: 'checkout_newCard_holderName',
      desc: '',
      args: [],
    );
  }

  /// `Salvar dados do cartão para próxima compra`
  String get checkout_newCard_save {
    return Intl.message(
      'Salvar dados do cartão para próxima compra',
      name: 'checkout_newCard_save',
      desc: '',
      args: [],
    );
  }

  /// `Continuar`
  String get checkout_newCard_continue {
    return Intl.message(
      'Continuar',
      name: 'checkout_newCard_continue',
      desc: '',
      args: [],
    );
  }

  /// `Validando cartão`
  String get checkout_newCard_loading_brand {
    return Intl.message(
      'Validando cartão',
      name: 'checkout_newCard_loading_brand',
      desc: '',
      args: [],
    );
  }

  /// `{value} já recebeu o seu\npedido e irá prepara-lo`
  String orderConfirmed_message(Object value) {
    return Intl.message(
      '$value já recebeu o seu\npedido e irá prepara-lo',
      name: 'orderConfirmed_message',
      desc: '',
      args: [value],
    );
  }

  /// `Número do pedido: `
  String get orderConfirmed_message2 {
    return Intl.message(
      'Número do pedido: ',
      name: 'orderConfirmed_message2',
      desc: '',
      args: [],
    );
  }

  /// `Acompanhar pedidos`
  String get orderConfirmed_seeDetails {
    return Intl.message(
      'Acompanhar pedidos',
      name: 'orderConfirmed_seeDetails',
      desc: '',
      args: [],
    );
  }

  /// `Voltar ao início`
  String get orderConfirmed_back {
    return Intl.message(
      'Voltar ao início',
      name: 'orderConfirmed_back',
      desc: '',
      args: [],
    );
  }

  /// `{value}`
  String orderConfirmed_comandaMessage(Object value) {
    return Intl.message(
      '$value',
      name: 'orderConfirmed_comandaMessage',
      desc: '',
      args: [value],
    );
  }

  /// `Avalie sua experiência com o app`
  String get orderConfirmed_rating {
    return Intl.message(
      'Avalie sua experiência com o app',
      name: 'orderConfirmed_rating',
      desc: '',
      args: [],
    );
  }

  /// `Digite uma avaliação (opcional)`
  String get orderConfirmed_obs {
    return Intl.message(
      'Digite uma avaliação (opcional)',
      name: 'orderConfirmed_obs',
      desc: '',
      args: [],
    );
  }

  /// `Fechar`
  String get orderConfirmed_comandaButton {
    return Intl.message(
      'Fechar',
      name: 'orderConfirmed_comandaButton',
      desc: '',
      args: [],
    );
  }

  /// `Em andamento`
  String get order_happening {
    return Intl.message(
      'Em andamento',
      name: 'order_happening',
      desc: '',
      args: [],
    );
  }

  /// `Histórico`
  String get order_past {
    return Intl.message(
      'Histórico',
      name: 'order_past',
      desc: '',
      args: [],
    );
  }

  /// `Pedido:`
  String get order_orderNumber {
    return Intl.message(
      'Pedido:',
      name: 'order_orderNumber',
      desc: '',
      args: [],
    );
  }

  /// `Total de itens: {value}`
  String order_totalOfItens(Object value) {
    return Intl.message(
      'Total de itens: $value',
      name: 'order_totalOfItens',
      desc: '',
      args: [value],
    );
  }

  /// `Hora do pedido: {value}`
  String order_time(Object value) {
    return Intl.message(
      'Hora do pedido: $value',
      name: 'order_time',
      desc: '',
      args: [value],
    );
  }

  /// `Aguardando confirmação`
  String get order_status_paid {
    return Intl.message(
      'Aguardando confirmação',
      name: 'order_status_paid',
      desc: '',
      args: [],
    );
  }

  /// `Em preparação...`
  String get order_status_confirmed {
    return Intl.message(
      'Em preparação...',
      name: 'order_status_confirmed',
      desc: '',
      args: [],
    );
  }

  /// `Cancelado`
  String get order_status_canceled {
    return Intl.message(
      'Cancelado',
      name: 'order_status_canceled',
      desc: '',
      args: [],
    );
  }

  /// `Pedido pronto!`
  String get order_status_finished {
    return Intl.message(
      'Pedido pronto!',
      name: 'order_status_finished',
      desc: '',
      args: [],
    );
  }

  /// `Detalhes do pedido`
  String get orderDetail_title {
    return Intl.message(
      'Detalhes do pedido',
      name: 'orderDetail_title',
      desc: '',
      args: [],
    );
  }

  /// `Status do pedido`
  String get orderDetail_status {
    return Intl.message(
      'Status do pedido',
      name: 'orderDetail_status',
      desc: '',
      args: [],
    );
  }

  /// `Retirada`
  String get orderDetail_location {
    return Intl.message(
      'Retirada',
      name: 'orderDetail_location',
      desc: '',
      args: [],
    );
  }

  /// `Tempo médio de preparo: `
  String get orderDetail_time {
    return Intl.message(
      'Tempo médio de preparo: ',
      name: 'orderDetail_time',
      desc: '',
      args: [],
    );
  }

  /// `Horário de retirada:`
  String get orderDetail_locationDetail {
    return Intl.message(
      'Horário de retirada:',
      name: 'orderDetail_locationDetail',
      desc: '',
      args: [],
    );
  }

  /// `Retirar ao concluir`
  String get orderDetail_locationDetailNow {
    return Intl.message(
      'Retirar ao concluir',
      name: 'orderDetail_locationDetailNow',
      desc: '',
      args: [],
    );
  }

  /// `Observação: {value}`
  String orderDetail_locationDetailObs(Object value) {
    return Intl.message(
      'Observação: $value',
      name: 'orderDetail_locationDetailObs',
      desc: '',
      args: [value],
    );
  }

  /// `Retirar às {value}`
  String orderDetail_locationDetailSchedule(Object value) {
    return Intl.message(
      'Retirar às $value',
      name: 'orderDetail_locationDetailSchedule',
      desc: '',
      args: [value],
    );
  }

  /// `Abrir no mapa`
  String get orderDetail_openMap {
    return Intl.message(
      'Abrir no mapa',
      name: 'orderDetail_openMap',
      desc: '',
      args: [],
    );
  }

  /// `Itens do pedido`
  String get orderDetail_item {
    return Intl.message(
      'Itens do pedido',
      name: 'orderDetail_item',
      desc: '',
      args: [],
    );
  }

  /// `Total do pedido:`
  String get orderDetail_totalOrder {
    return Intl.message(
      'Total do pedido:',
      name: 'orderDetail_totalOrder',
      desc: '',
      args: [],
    );
  }

  /// `Desconto:`
  String get orderDetail_discont {
    return Intl.message(
      'Desconto:',
      name: 'orderDetail_discont',
      desc: '',
      args: [],
    );
  }

  /// `Acrescimo:`
  String get orderDetail_addition {
    return Intl.message(
      'Acrescimo:',
      name: 'orderDetail_addition',
      desc: '',
      args: [],
    );
  }

  /// `Total:`
  String get orderDetail_total {
    return Intl.message(
      'Total:',
      name: 'orderDetail_total',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}