import '../../utils/constants.dart';

class Establishment {
  String idLj;
  String nmLj;
  String dsAtividadeLj;
  String cNPJLJ;
  String rAZAOSOCIALLJ;
  String eNDLJ;
  String nRLJ;
  String bAIRROLJ;
  String cIDADELJ;
  String uFLJ;
  String fONELJ;
  String lATITUDELJ;
  String lONGITUDELJ;
  String uRLCAPALJ;
  String dSFUNCIONAMENTOLJ;
  String rEDESSOCIAISLJ;
  String eMAILLJ;
  String pATHBDLJ;
  String HOSTLJ;
  String dISTANCIA;
  String dsFUNCIONAMENTOLJ;
  String redesSociaisLJ;
  String emailLJ;
  String facebookLJ;
  String twitterLJ;
  String instaLJ;
  String siteLJ;
  String whatsappLJ;
  String flKidsLJ;
  String flAcessibilidadeLJ;
  String flEstacionamentoLJ;
  String flWifiLJ;
  String flGeraPedidoLJ;
  String flLerComandaLJ;
  String FlLancarNaComandaLJ;
  String FlAleloLJ;
  String FlSodexoLJ;
  String FlVrLJ;
  String statusLJ;
  String flPicPayLJ;
  String flPixLJ;

  Establishment(
      {this.idLj,
      this.nmLj,
      this.dsAtividadeLj,
      this.cNPJLJ,
      this.rAZAOSOCIALLJ,
      this.eNDLJ,
      this.nRLJ,
      this.bAIRROLJ,
      this.cIDADELJ,
      this.uFLJ,
      this.fONELJ,
      this.lATITUDELJ,
      this.lONGITUDELJ,
      this.uRLCAPALJ,
      this.dSFUNCIONAMENTOLJ,
      this.rEDESSOCIAISLJ,
      this.eMAILLJ,
      this.pATHBDLJ,
      this.HOSTLJ,
      this.dISTANCIA,
      this.dsFUNCIONAMENTOLJ,
      this.redesSociaisLJ,
      this.emailLJ,
      this.facebookLJ,
      this.twitterLJ,
      this.instaLJ,
      this.siteLJ,
      this.whatsappLJ,
      this.flKidsLJ,
      this.flAcessibilidadeLJ,
      this.flEstacionamentoLJ,
      this.flWifiLJ,
      this.flGeraPedidoLJ,
      this.flLerComandaLJ,
      this.FlLancarNaComandaLJ,
      this.FlAleloLJ,
      this.FlSodexoLJ,
      this.FlVrLJ,
      this.statusLJ,
      this.flPicPayLJ,
      this.flPixLJ});

  Establishment.fromJson(Map<String, dynamic> json) {
    idLj = json['Id_lj'];
    nmLj = json['Nm_lj'];
    dsAtividadeLj = json['ds_Atividade_lj'];
    cNPJLJ = json['CNPJ_LJ'];
    rAZAOSOCIALLJ = json['RAZAO_SOCIAL_LJ'];
    eNDLJ = json['END_LJ'];
    nRLJ = json['NR_LJ'];
    bAIRROLJ = json['BAIRRO_LJ'];
    cIDADELJ = json['CIDADE_LJ'];
    uFLJ = json['UF_LJ'];
    fONELJ = json['FONE_LJ'];
    lATITUDELJ = json['LATITUDE_LJ'];
    lONGITUDELJ = json['LONGITUDE_LJ'];
    uRLCAPALJ = json['URL_CAPA_LJ'];
    dSFUNCIONAMENTOLJ = json['DS_FUNCIONAMENTO_LJ'];
    rEDESSOCIAISLJ = json['REDES_SOCIAIS_LJ'];
    eMAILLJ = json['EMAIL_LJ'];
    HOSTLJ = json['HOST_LJ'];
    pATHBDLJ = json['PATH_BD_LJ'];
    dISTANCIA = json['DISTANCIA'];
    dsFUNCIONAMENTOLJ = json['DS_FUNCIONAMENTO_LJ'];
    redesSociaisLJ = json['REDES_SOCIAIS_LJ'];
    emailLJ = json['EMAIL_LJ'];
    facebookLJ = json['FACEBOOK_LJ'];
    twitterLJ = json['TWITTER_LJ'];
    instaLJ = json['INSTA_LJ'];
    siteLJ = json['SITE_LJ'];
    whatsappLJ = json['WHATSWAPP_LJ'];
    flKidsLJ = json['FL_KIDS_LJ'];
    flAcessibilidadeLJ = json['FL_ESTACIONAMENTO_LJ'];
    flEstacionamentoLJ = json['FL_ACESSIBILIDADE_LJ'];
    flWifiLJ = json['FL_WIFI_LJ'];
    flGeraPedidoLJ = json['FL_GERAR_PEDIDO_LJ'];
    flLerComandaLJ = json['FL_LER_COMANDA_LJ'];
    FlLancarNaComandaLJ = json['FL_LANCAR_NA_COMANDA_LJ'];
    FlAleloLJ = json['FL_ALELO_LJ'];
    FlSodexoLJ = json['FL_SODEXO_LJ'];
    FlVrLJ = json['FL_VR_LJ'];
    statusLJ = json['STS_LJ'];
    flPicPayLJ = json['FL_PICPAY_LJ'];
    flPixLJ = json['FL_PIX_LJ'];
  }

  String provideFullAddress() {
    var fullAddress = eNDLJ;
    if (nRLJ.isNotEmpty) fullAddress = fullAddress + ", $nRLJ";
    if (bAIRROLJ.isNotEmpty) fullAddress = fullAddress + ", $bAIRROLJ";
    if (cIDADELJ.isNotEmpty) fullAddress = fullAddress + " - $cIDADELJ";
    if (uFLJ.isNotEmpty) fullAddress = fullAddress + " / $uFLJ";
    return fullAddress;
  }
}
