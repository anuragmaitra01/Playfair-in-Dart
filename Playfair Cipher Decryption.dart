//s.replaceAll(new RegExp(r'[^\w\s]+'),'')
void generateKeyTable(String key, int ks, var keyT) {
  int i, j, k;

// a 26 character hashmap
// to store count of the alphabet
  var dicty = List<int>.filled(26, 0);

  for (i = 0; i < ks; i++) {
    if (key[i] != 'j') dicty[key.codeUnitAt(i) - 'a'.codeUnitAt(0)] = 2;
  }
  dicty['j'.codeUnitAt(0) - 'a'.codeUnitAt(0)] = 1;

  i = 0;
  j = 0;
  for (k = 0; k < ks; k++) {
    if (dicty[key.codeUnitAt(k) - 'a'.codeUnitAt(0)] == 2) {
      dicty[key.codeUnitAt(k) - 'a'.codeUnitAt(0)] -= 1;
      keyT[i][j] = key[k];
      j++;
      if (j == 5) {
        i++;
        j = 0;
      }
    }
  }
  for (k = 0; k < 26; k++) {
    if (dicty[k] == 0) {
      keyT[i][j] = String.fromCharCode(k + 'a'.codeUnitAt(0));
      j++;
      if (j == 5) {
        i++;
        j = 0;
      }
    }
  }
}

void search(var keyT, String a, String b, var arr) {
  int i, j;

  if (a == 'j')
    a = 'i';
  else if (b == 'j') b = 'i';

  for (i = 0; i < 5; i++) {
    for (j = 0; j < 5; j++) {
      if (keyT[i][j] == a) {
        arr[0] = i;
        arr[1] = j;
      } else if (keyT[i][j] == b) {
        arr[2] = i;
        arr[3] = j;
      }
    }
  }
}

int mod5(int a) {
  if (a < 0) a += 5;
  return (a % 5);
}

String decrypt(String str, var keyT, int ps) {
  int i;
  var a = List<int>.filled(4, 0);
  for (i = 0; i < ps; i += 2) {
    search(keyT, str[i], str[i + 1], a);
    if (a[0] == a[2]) {
      str = str.substring(0, i) +
          keyT[a[0]][mod5(a[1] - 1)] +
          str.substring(i + 1);
      str = str.substring(0, i + 1) +
          keyT[a[0]][mod5(a[3] - 1)] +
          str.substring(i + 2);
    } else if (a[1] == a[3]) {
      str = str.substring(0, i) +
          keyT[mod5(a[0] - 1)][a[1]] +
          str.substring(i + 1);
      str = str.substring(0, i + 1) +
          keyT[mod5(a[2] - 1)][a[1]] +
          str.substring(i + 2);
    } else {
      str = str.substring(0, i) + keyT[a[0]][a[3]] + str.substring(i + 1);
      str = str.substring(0, i + 1) + keyT[a[2]][a[1]] + str.substring(i + 2);
    }
  }
  return str;
}

String decryptByPlayfairCipher(String str, String key) {
  int ps, ks;
  var keyT = List.generate(5, (i) => List.filled(5, ""), growable: false);

// Key
  ks = key.length;
  key = key.replaceAll(' ', '');
  key = key.replaceAll(new RegExp(r'[^\w\s]+'), '');
  key = key.toLowerCase();

// ciphertext
  ps = str.length;
  str = str.replaceAll(' ', '');
  str = str.replaceAll(new RegExp(r'[^\w\s]+'), '');
  str = str.toLowerCase();

  generateKeyTable(key, ks, keyT);

  str = decrypt(str, keyT, ps);
  return str;
}

int main() {
  String str, key;

// Key to be encrypted
  key = "Monarchy";
  print("Key text: $key");

// Ciphertext to be decrypted
  str = "gatlmzclrqtx";
  print("Plain text: $str");

// encrypt using Playfair Cipher
  str = decryptByPlayfairCipher(str, key);

  print("Deciphered text: $str");

  return 0;
}
