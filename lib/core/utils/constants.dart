import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'colors.dart';

// Font constants
const fontWeightMedium = FontWeight.w500;

// Theme constants
const appBarTextStyle = TextStyle(
  fontWeight: fontWeightMedium,
  color: colorDefaultText,
  fontSize: 14,
);

// Hero constants
const hero_OpenEstablishmentDetail = "establishment_image_";

//format constants
final currencyFormatter = NumberFormat("#,##0.00", "pt_BR");

//bottomsheet
final bottomSheetMaxSize = 0.95;

//credit card regex
final VISA_REGEX = RegExp(r'^4[0-9]{0,18}$');
final VISA2_REGEX = RegExp(r'^(450903)[0-9]{0,10}$');
final VISA3_REGEX = RegExp(r'^(4571)[0-9]{0,12}$');
final MASTER_REGEX = RegExp(r'^(5[1-5][0-9]{0,14}|2[2-7][0-9]{0,14})$');
final MASTER2_REGEX = RegExp(r'^(510099)[0-9]{0,10}$');
final MASTER3_REGEX = RegExp(r'^(5[0|6-8][0-9]{0,17}|6[0-9]{0,18})$');
final MASTER4_REGEX = RegExp(r'^(6759)[0-9]{0,15}$');
final ELO_REGEX = RegExp(
    r'^((((506699)|(506770)|(506771)|(506772)|(506773)|(506774)|(506775)|(506776)|(506777)|(506778)|(401178)|(438935)|(451416)|(457631)|(457632)|(504175)|(627780)|(636368)|(636297))[0-9]{0,10})|((50676)|(50675)|(50674)|(50673)|(50672)|(50671)|(50670))[0-9]{0,11})$');
final HIPER_REGEX = RegExp(r'^(606282)[0-9]{0,10}$');
final AMEX_REGEX = RegExp(r'^3[47][0-9]{0,13}$');

//credit card brand name
const PICPAY = "picPay";
const PIX = "pix";
const MASTER = "Master";
const MASTER2 = "Mastercard";
const VISA = "Visa";
const ELO = "Elo";
const AMEX = "Amex";
const HIPER = "Hiper";

//ticket
const ALELO_REF = "Alelo Ref";
const ALELO_ALI = "Alelo Ali";
const SODEXO_REF = "Sodexo Ref";
const SODEXO_ALI = "Sodexo Ali";
const VR_REF = "VR ref";
const VR_ALI = "VR ali";
