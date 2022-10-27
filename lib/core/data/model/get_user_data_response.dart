class UserDataResponse {
  String erro;
  String mensagem;
  DadosCadastrais dadosCadastrais;

  UserDataResponse({this.erro, this.mensagem, this.dadosCadastrais});

  UserDataResponse.fromJson(Map<String, dynamic> json) {
    erro = json['Erro'];
    mensagem = json['Mensagem'];
    if (json['dados cadastrais'] != null) {
      json['dados cadastrais'].forEach((v) {
        dadosCadastrais = new DadosCadastrais.fromJson(v);
        return;
      });
    }
  }

  bool isSucessful() {
    var errorLowerCased = this.erro.toLowerCase();
    return errorLowerCased == "false";
  }
}

class DadosCadastrais {
  String fone;
  String email;
  String snome;
  String senha;
  String nome;
  String cpf;

  DadosCadastrais(this.fone, this.email, this.snome, this.senha, this.nome, this.cpf);

  DadosCadastrais.fromJson(Map<String, dynamic> json) {
    fone = json['fone'];
    email = json['email'];
    snome = json['snome'];
    senha = json['senha'];
    nome = json['nome'];
    cpf = json['cpf'];
  }
}
