/// Representa um único resultado da pesquisa de medicamentos.
class Medicamento {
  final String nome;
  final String informacoes;
  final String textoCompleto;
  final DateTime? dataAdicao;

  // 'nome': _nomeMedicamento,
  //     'informacoes': _informacoesSimplificadas,
  //     'textoCompleto': _textoExtraido,
  //     'dataAdicao':

  Medicamento({
    required this.nome,
    required this.informacoes,
    required this.textoCompleto,
    this.dataAdicao
  });

}

class MedicamentoDetalhado {
  final String nomeProduto;
  final String empresa;
  final String idBulaPaciente;
  final String idBulaProfissional;

  MedicamentoDetalhado({
    required this.nomeProduto,
    required this.empresa,
    required this.idBulaPaciente,
    required this.idBulaProfissional,
  });

  factory MedicamentoDetalhado.fromJson(Map<String, dynamic> json) {
    return MedicamentoDetalhado(
      nomeProduto: json['nomeProduto'] ?? 'Nome não disponível',
      empresa: json['razaoSocial'] ?? 'Empresa não disponível',
      idBulaPaciente: json['idBulaPacienteProtegido'] ?? '',
      idBulaProfissional: json['idBulaProfissionalProtegido'] ?? '',
    );
  }
}
