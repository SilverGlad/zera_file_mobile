import 'dart:convert';

class Acompanhamentos {
  String tITULO;
  String fLObrigar;
  List<Options> opEs;
  bool selected = false;
  int selection;

  Acompanhamentos({this.tITULO, this.fLObrigar, this.opEs});

  Acompanhamentos.fromJson(Map<String, dynamic> json) {
    tITULO = json['TITULO'];
    fLObrigar = json['FL_Obrigar'];
    if (json['opções'] != null) {
      opEs = new List<Options>();
      json['opções'].forEach((v) {
        opEs.add(new Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TITULO'] = this.tITULO;
    data['FL_Obrigar'] = this.fLObrigar;
    if (this.opEs != null) {
      data['opções'] = this.opEs.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String toJson() => json.encode(toMap());
}

class Options {
  String dS;
  bool checked = false;

  Options({this.dS});

  Options.fromJson(Map<String, dynamic> json) {
    dS = json['DS'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DS'] = this.dS;
    return data;
  }

  String toJson() => json.encode(toMap());
}
