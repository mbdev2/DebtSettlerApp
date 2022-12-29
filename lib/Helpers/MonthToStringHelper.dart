// FUNKCIJA ZA PRETVARJANJE DATUMOV V String
String monthToStringHelper(int month) {
  switch (month) {
    case 1: {
      return "JAN";
    }
    case 2: {
      return "FEB";
    }
    case 3: {
      return "MAR";
    }
    case 4: {
      return "APR";
    }
    case 5: {
      return "MAJ";
    }
    case 6: {
      return "JUN";
    }
    case 7: {
      return "JUL";
    }
    case 8: {
      return "AVG";
    }
    case 9: {
      return "SEP";
    }
    case 10: {
      return "OKT";
    }
    case 11: {
      return "NOV";
    }
    case 12: {
      return "DEC";
    }
  }
  throw "WTF Kak si dobil mesec vecji od 12???";
}