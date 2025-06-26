import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';

class BulaAISimplifierService {

  static Future<String> simplificarTextoDaBula(String textoDaBula) async {
    print("-> Enviando texto para a IA para simplificação...");

    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? 'CHAVE_NAO_ENCONTRADA';

    if (apiKey == 'CHAVE_NAO_ENCONTRADA') {
      print("ERRO: A chave GEMINI_API_KEY não foi encontrada no seu ficheiro .env");
      throw Exception("Chave de API do Gemini não configurada.");
    }

    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey');

    const prompt = """
      Você é um assistente de saúde amigável e seu objetivo é ajudar pacientes a entenderem bulas de remédio.
      Analise o texto da bula a seguir e transforme-o em um resumo claro, com linguagem popular e direta.
      Use uma linguagem que uma pessoa sem conhecimento médico possa entender facilmente.
      
      Estruture a resposta usando os seguintes tópicos em Markdown:
      - **Para que serve?** (A indicação do remédio)
      - **Como devo usar?** (A posologia e o modo de usar)
      - **Quais os principais riscos?** (As reações adversas mais importantes)
      - **Quando NÃO devo usar?** (As contraindicações)
      
      Use a segunda pessoa ("você") para falar diretamente com o paciente. Seja conciso e foque no que é mais crucial para a segurança e o uso correto.
      
      TEXTO DA BULA PARA ANALISAR:
    """;

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': prompt + textoDaBula}
          ]
        }
      ]
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      return decodedResponse['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception('Erro ao comunicar com a API de IA: ${response.body}');
    }
  }
}
