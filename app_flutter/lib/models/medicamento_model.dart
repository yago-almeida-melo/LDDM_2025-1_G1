/// Representa um único resultado da pesquisa de medicamentos.
class Medicamento {
  final String nomeProduto;
  final String empresa;
  final String numProcesso;

  Medicamento({
    required this.nomeProduto,
    required this.empresa,
    required this.numProcesso,
  });

  factory Medicamento.fromJson(Map<String, dynamic> json) {
    return Medicamento(
      nomeProduto: json['nomeProduto'] ?? 'Nome não disponível',
      empresa: json['empresa'] ?? 'Empresa não disponível',
      numProcesso: json['numProcesso'] ?? '',
    );
  }
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
