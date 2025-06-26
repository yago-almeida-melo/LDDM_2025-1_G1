import '../services/bula_service.dart';

class BulaProvider {

  Future<String> simplificarBula(String textoCompletoDaBula) async {
    try {
      if (textoCompletoDaBula.isEmpty) {
        return "O texto da bula está vazio.";
      }
      final bulaSimplificada = await BulaAISimplifierService.simplificarTextoDaBula(textoCompletoDaBula);
      return bulaSimplificada;
    } catch (e) {
      print("Ocorreu um erro no BulaProvider: $e");
      return "Não foi possível simplificar a bula no momento.";
    }
  }

  Future<String> buscarInfoRemedio(String textoExtraido) async {
    try {
      if (textoExtraido.isEmpty) {
        return "O texto extraido está vazio.";
      }
      final bulaSimplificada = await BulaAISimplifierService.buscarInfoRemedio(textoExtraido);
      return bulaSimplificada;
    } catch (e) {
      print("Ocorreu um erro no BulaProvider: $e");
      return "Não foi possível simplificar a bula no momento.";
    }
  }
}
