import 'dart:io';
import 'dart:convert';

void main() async {
  print('시작 단어를 입력하세요(player1턴):');
  var turn = 2;
  var broken = false;
  var start_word = stdin.readLineSync()!;
  while (turn == 2) {
    if (start_word == 'gg') {
      print("player2승리");
      broken = true;
      break;
    }
    if (start_word.length < 2) {
      print('2글자 이상을 입력해 주세요');
      print('--------------------');
      start_word = stdin.readLineSync()!;
      continue;
    }

    var encodedInput = Uri.encodeComponent(start_word);

    var apiKey = "1A6D29BB92291684B07CC85A0708658F";

    var url = Uri.parse(
      'https://stdict.korean.go.kr/api/search.do?key=$apiKey&q=$encodedInput&req_type=json',
    );

    var client = HttpClient();
    var request = await client.getUrl(url);
    request.headers.add(
      'User-Agent',
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
    );

    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();

    if (responseBody.isEmpty ||
        responseBody.contains('"error"') ||
        !responseBody.contains('"item"')) {
      print('사전에 없는 단어입니다');
      print('--------------------');
      start_word = stdin.readLineSync()!;
      continue;
    }
    turn++;
  }
  var history = [start_word];
  turn = 2;
  while (true) {
    if (broken == true) {
      break;
    }
    print('제시어: ' + start_word);
    if (turn % 2 == 0) {
      print('[player2턴]');
    } else {
      print('[player1턴]');
    }
    var input = stdin.readLineSync()!;

    if (input == 'gg') {
      if (turn % 2 == 0) {
        print('player1승리');
      } else {
        print('player2승리');
      }
      break;
    }
    if (input.length < 2) {
      print('2글자 이상을 입력해 주세요');
      print('--------------------');
      continue;
    }

    if (history.contains(input) == true) {
      print('이미 사용한 단어입니다');
      print('--------------------');
      continue;
    }

    var encodedInput = Uri.encodeComponent(input);

    var apiKey = "1A6D29BB92291684B07CC85A0708658F";

    var url = Uri.parse(
      'https://stdict.korean.go.kr/api/search.do?key=$apiKey&q=$encodedInput&req_type=json',
    );

    var client = HttpClient();
    var request = await client.getUrl(url);
    request.headers.add(
      'User-Agent',
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
    );

    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();

    if (responseBody.isEmpty ||
        responseBody.contains('"error"') ||
        !responseBody.contains('"item"')) {
      print('사전에 없는 단어입니다');
      print('--------------------');
      continue;
    }

    var last_char_length = start_word.length;
    var last_char = start_word.substring(
      last_char_length - 1,
      start_word.length,
    );
    var first_char = input.substring(0, 1);

    if (last_char == first_char) {
      print('인정');
      turn++;
      start_word = input;
      history.add(input);
      print('--------------------');
    } else {
      print('올바른 단어를 입력해 주세요');
      continue;
    }
  }
}
