class DataHelper {
  static String getWeek() {
    int numeroDaSemana = DateTime.now().weekday;
    //numeroDaSemana = 6;

    String diaDaSemana = '';
    switch (numeroDaSemana) {
      case 1:
        diaDaSemana = 'Segunda-Feira';
        break;
      case 2:
        diaDaSemana = 'Terça-Feira';
        break;
      case 3:
        diaDaSemana = 'Quarta-Feira';
        break;
      case 4:
        diaDaSemana = 'Quinta-Feira';
        break;
      case 5:
        diaDaSemana = 'Sexta-Feira';
        break;
      case 6:
        diaDaSemana = 'Sábado';
        break;
      case 7:
        diaDaSemana = 'Domingo';
        break;
      default:
    }
    return diaDaSemana;
  }

  static String getMounthAndYear(String data) {
    List<String> mesAno = data.split('-');
    String mes = mesAno[0];
    String ano = mesAno[1];

    String mesPorExtenso = getMounth(mes);
    String mesPorExtensoAndAno = mesPorExtenso + ' de ' + ano;
    return mesPorExtensoAndAno;
  }

  static String getMounth(String mounth) {
    String mesPorExtenso = '';
    switch (mounth) {
      case '1':
        mesPorExtenso = 'Janeiro';
        break;
      case '2':
        mesPorExtenso = 'Fevereiro';
        break;
      case '3':
        mesPorExtenso = 'Março';
        break;
      case '4':
        mesPorExtenso = 'Abril';
        break;
      case '5':
        mesPorExtenso = 'Maio';
        break;
      case '6':
        mesPorExtenso = 'Junho';
        break;
      case '7':
        mesPorExtenso = 'Julho';
        break;
      case '8':
        mesPorExtenso = 'Agosto';
        break;
      case '9':
        mesPorExtenso = 'Setembro';
        break;
      case '10':
        mesPorExtenso = 'Outubro';
        break;
      case '11':
        mesPorExtenso = 'Novembro';
        break;
      case '12':
        mesPorExtenso = 'Dezembro';
        break;
      default:
    }

    return mesPorExtenso;
  }
}
